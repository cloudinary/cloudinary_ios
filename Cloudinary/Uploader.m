//
//  Uploader.m
//  Cloudinary
//
//  Created by Tal Lev-Ami on 26/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "Uploader.h"
#import "EagerTransformation.h"
#import "Transformation.h"
#import "SBJson.h"

@interface Uploader () {
    Cloudinary *cloudinary;
    id delegate;
    NSMutableData *responseData;
    NSHTTPURLResponse *response;
}
@end

@implementation Uploader

- (id) init:(Cloudinary*)cloudinary_ delegate:(id)delegate_
{
    if ( self = [super init] )
    {
        delegate = delegate_;
        cloudinary = cloudinary_;
        responseData = [NSMutableData data];
    }
    return self;    
}

- (void) upload:(id)file options:(NSDictionary*) options
{
    if (options == nil) options = [NSDictionary dictionary];
    NSDictionary* params = [self buildUploadParams:options];
    [self callApi:@"upload" file:file params:params options:options];
}
- (void) destroy:(NSString*)publicId options:(NSDictionary*) options
{
    if (options == nil) options = [NSDictionary dictionary];
    NSString* type = [options valueForKey:@"type" defaultValue:@"upload"];
    NSDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:type, @"type", publicId, @"public_id", nil];
    [self callApi:@"destroy" file:nil params:params options:options];
}
- (void) explicit:(NSString*)publicId options:(NSDictionary*) options
{
    if (options == nil) options = [NSDictionary dictionary];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:publicId forKey:@"public_id"];
    [params setValue:[options valueForKey:@"type"] forKey:@"type"];
    [params setValue:[self buildEager:[options valueForKey:@"eager"]] forKey:@"eager"];
    [params setValue:[self buildCustomHeaders:[options valueForKey:@"headers"]] forKey:@"headers"];
    NSArray* tags = [Cloudinary asArray:[options valueForKey:@"tags"]];
    [params setValue:[tags componentsJoinedByString:@","] forKey:@"tags"];    
    [self callApi:@"explicit" file:nil params:params options:options];
}
- (void) addTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*) options
{
    if (options == nil) options = [NSDictionary dictionary];
    NSNumber* exclusive = [Cloudinary asBool:[options valueForKey:@"exclusive"]];
    NSString* command = [exclusive boolValue] ? @"set_exclusive" : @"add";
    [self callTagsApi:tag command:command publicIds:publicIds options:options];
}
- (void) removeTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*) options
{
    if (options == nil) options = [NSDictionary dictionary];
    [self callTagsApi:tag command:@"remove" publicIds:publicIds options:options];
}
- (void) replaceTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*) options
{
    if (options == nil) options = [NSDictionary dictionary];
    [self callTagsApi:tag command:@"replace" publicIds:publicIds options:options];
}
- (void) text:(NSString*)text options:(NSDictionary*) options
{
    NSArray* TEXT_PARAMS = [NSArray arrayWithObjects:
        @"public_id", @"font_family", @"font_size", @"font_color", @"text_align", @"font_weight",
        @"font_style", @"background", @"opacity", @"text_decoration", nil];
    if (options == nil) options = [NSDictionary dictionary];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:text forKey:@"text"];
    for (NSString* param in TEXT_PARAMS) {
        NSString* paramValue = [Cloudinary asString:[options valueForKey:param]];
        [params setValue:paramValue forKey:param];
    }
    [self callApi:@"text" file:nil params:params options:options];
}

// internal
- (void) callApi:(NSString*) action file:(id)file params:(NSMutableDictionary*)params options:(NSDictionary*) options
{
    if (options == nil) options = [NSDictionary dictionary];
    NSString* apiKey = [cloudinary get:@"api_key" options:options defaultValue:nil];
    if (apiKey == nil) [NSException raise:@"ArgumentError" format:@"Must supply api_key"];
    if ([options valueForKey:@"signature"] == nil) {
        NSString* apiSecret = [cloudinary get:@"api_secret" options:options defaultValue:nil];
        if (apiSecret == nil) [NSException raise:@"ArgumentError" format:@"Must supply api_secret"];
        NSDate *today = [NSDate date];
        [params setValue:[NSNumber numberWithInt:(int) [today timeIntervalSince1970]] forKey:@"timestamp"];
        [params setValue:[cloudinary apiSignRequest:params secret:apiSecret] forKey:@"signature"];
        [params setValue:apiKey forKey:@"api_key"];
    }
    
    NSString* apiUrl = [cloudinary cloudinaryApiUrl:action options:options];

    NSURLRequest *req = [self request:apiUrl params:params file:file];
    // create the connection with the request and start loading the data
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    if (connection == nil) {
        [delegate error:@"Failed to initiate connection"];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse*)response_
{
    [responseData setLength:0];
    response = response_;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)nserror
{
    [delegate error:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
          [nserror localizedDescription],
          [[nserror userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    int code = [response statusCode];
    
    if (code != 200 && code != 400 && code != 401 && code != 500) {
        [delegate error:[NSString stringWithFormat:@"Server returned unexpected status code - %d - %@", code, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]]];
        return;
    }
    
    SBJsonParser *parser = [SBJsonParser new];
    NSDictionary* result = [parser objectWithData:responseData];
    if (result == nil) {
        [delegate error:[NSString stringWithFormat:@"Error parsing response. Error - %@. Response - %@.", parser.error, [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]]];
        return;
    }
    NSDictionary* errorResponse = [result valueForKey:@"error"];
    if (errorResponse == nil)
    {
        [delegate success:result];
    }
    else
    {
        [delegate error:[errorResponse valueForKey:@"message"]];
    }
}


- (NSURLRequest*) request:(NSString*)url params:(NSDictionary*)params file:(id)file
{
    NSString *boundary = [cloudinary randomPublicId];
    
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                  timeoutInterval:60.0];

    [req setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", boundary];
    [req setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSMutableData* postBody = [NSMutableData data];
    for (NSString* param in [params allKeys]) {
        NSString* paramValue = [Cloudinary asString:[params valueForKey:param]];
        if ([paramValue length] == 0) continue;
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[paramValue dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if (file != nil)
    {
        NSString* filename = @"file";
        NSData *data;
        if ([file isKindOfClass:[NSString class]])
        {
            if ([(NSString*)file rangeOfString:@"^https?:/.*" options:NSCaseInsensitiveSearch|NSRegularExpressionSearch].location != NSNotFound)
            {
                [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[@"Content-Disposition: form-data; name=\"file\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[file dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                data = nil;
            }
            else
            {
                NSError* error = nil;
                data = [NSData dataWithContentsOfFile:file options:0 error:&error];
                if (error != nil) {
                    [NSException raise:@"ArgumentException" format:@"Error reading requested file - %@ %@",
                                 [error localizedDescription],
                                 [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey], nil];
                }
                filename = [file lastPathComponent];
            }
        }
        else if ([file isKindOfClass:[NSData class]])
        {
            data = file;
        }
        else
        {
            [NSException raise:@"ArgumentException" format:@"file number be either url, path to file or NSData"];
        }
        if (data != nil)
        {
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:data];
            [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    [postBody appendData:[[NSString stringWithFormat:@"--%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [req setHTTPBody:postBody];
    return req;
}

- (void) callTagsApi:(NSString*)tag command:(NSString*)command publicIds:(NSArray*)publicIds options:(NSDictionary*) options
{
    if (options == nil) options = [NSDictionary dictionary];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:tag forKey:@"tag"];
    [params setValue:command forKey:@"command"];
    [params setValue:[options valueForKey:@"type"] forKey:@"type"];
    [params setValue:[publicIds componentsJoinedByString:@","] forKey:@"public_ids"];
    [self callApi:@"tags" file:nil params:params options:options];
}
- (NSString*) buildEager:(NSArray*)transformations
{
    if (transformations == nil) {
        return nil;
    }
    NSMutableArray* eager = [NSMutableArray arrayWithCapacity:[transformations count]];
    for (Transformation* transformation in transformations) {
        NSMutableArray* singleEager = [NSMutableArray array];
        NSString* transformationString = [transformation generate];
        if ([transformationString length] > 0)
        {
            [singleEager addObject:transformationString];
        }
        if ([transformation isKindOfClass:[EagerTransformation class]])
        {
            EagerTransformation* eagerTransformation = (EagerTransformation*) transformation;
            if ([eagerTransformation.format length] > 0)
            {
                [singleEager addObject:eagerTransformation.format];
            }
        }
        [eager addObject:[singleEager componentsJoinedByString:@"/"]];
    }
    return [eager componentsJoinedByString:@"|"];
    
}
- (NSString*) buildCustomHeaders:(id)headers
{
    if (headers == nil)
    {
        return nil;
    }
    else if ([headers isKindOfClass:[NSString class]])
    {
        return headers;
    }
    else if ([headers isKindOfClass:[NSArray class]])
    {
        NSMutableString* headersString = [NSMutableString string];
        for (NSString* header in (NSArray*)headers) {
            [headersString appendString:header];
            [headersString appendString:@"\n"];
        }
        return headersString;
    } else {
        NSDictionary* headersDict = (NSDictionary*)headers;
        NSMutableString* headersString = [NSMutableString string];
        for (NSString* header in [headersDict allKeys]) {
            [headersString appendString:header];
            [headersString appendString:@": "];
            [headersString appendString:[headersDict valueForKey:header]];
            [headersString appendString:@"\n"];
        }
        return headersString;
    }
}
- (NSDictionary*) buildUploadParams:(NSDictionary*) options
{
    if (options == nil) options = [NSDictionary dictionary];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    id transformation = [options valueForKey:@"transformation" defaultValue:@""];
    if ([transformation isKindOfClass:[Transformation class]]) {
        transformation = [((Transformation*) transformation) generate];
    }
    [params setValue:transformation forKey:@"transformation"];
    [params setValue:[options valueForKey:@"public_id"] forKey:@"public_id"];
    [params setValue:[options valueForKey:@"format"] forKey:@"format"];
    [params setValue:[options valueForKey:@"type"] forKey:@"type"];
    NSNumber* backup = [Cloudinary asBool:[options valueForKey:@"backup"]];
    if (backup != nil)
    {
        NSString* backupString = [backup boolValue] ? @"true" : @"false";
        [options setValue:backupString forKey:@"backup"];
    }
    [params setValue:[self buildEager:[options valueForKey:@"eager"]] forKey:@"eager"];
    [params setValue:[self buildCustomHeaders:[options valueForKey:@"headers"]] forKey:@"headers"];
    NSArray* tags = [Cloudinary asArray:[options valueForKey:@"tags"]];
    [params setValue:[tags componentsJoinedByString:@","] forKey:@"tags"];
    return params;    
}


@end
