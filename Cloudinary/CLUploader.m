//
//  Uploader.m
//  Cloudinary
//
//  Created by Tal Lev-Ami on 26/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "CLUploader.h"
#import "CLEagerTransformation.h"
#import "CLTransformation.h"
#import "NSDictionary+Utilities.h"

@interface CLUploader ()<NSURLConnectionDataDelegate>

@property (readwrite, strong, nonatomic) CLCloudinary *cloudinary;

@end

@implementation CLUploader {
    id _context;
    CLUploaderCompletion _completion;
    CLUploaderProgress _progress;
    NSMutableData *_responseData;
    NSHTTPURLResponse *response;
    NSURLConnection *connection;
}

- (id)init:(CLCloudinary *)cloudinary delegate:(id<CLUploaderDelegate>)delegate
{
    if ( self = [super init] )
    {
        _delegate = delegate;
        _cloudinary = cloudinary;
        _responseData = [NSMutableData data];
    }
    return self;    
}

- (void)setCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    _completion = completionBlock;
    _progress = progressBlock;
}

- (void)upload:(id)file options:(NSDictionary *)options
{
    [self upload:file options:options withCompletion:nil andProgress:nil];
}

- (void)destroy:(NSString *)publicId options:(NSDictionary *)options
{
    [self destroy:publicId options:options withCompletion:nil andProgress:nil];
}

- (void)explicit:(NSString *)publicId options:(NSDictionary *)options
{
    [self explicit:publicId options:options withCompletion:nil andProgress:nil];
}

- (void)addTag:(NSString *)tag publicIds:(NSArray *)publicIds options:(NSDictionary *)options
{
    [self addTag:tag publicIds:publicIds options:options withCompletion:nil andProgress:nil];
}

- (void)removeTag:(NSString *)tag publicIds:(NSArray *)publicIds options:(NSDictionary *)options;
{
    [self removeTag:tag publicIds:publicIds options:options withCompletion:nil andProgress:nil];
}

- (void)replaceTag:(NSString *)tag publicIds:(NSArray *)publicIds options:(NSDictionary *)options;
{
    [self replaceTag:tag publicIds:publicIds options:options withCompletion:nil andProgress:nil];
}

- (void)text:(NSString *)text options:(NSDictionary *)options;
{
    [self text:text options:options withCompletion:nil andProgress:nil];
}

- (void)upload:(id)file options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSMutableDictionary *params = (NSMutableDictionary *)[self buildUploadParams:options];
    [self callApi:@"upload" file:file params:params options:options];
}

- (void)destroy:(NSString *)publicId options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSString* type = [options valueForKey:@"type" defaultValue:@"upload"];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:type, @"type", publicId, @"public_id", nil];
    [self callApi:@"destroy" file:nil params:params options:options];
}

- (void)explicit:(NSString *)publicId options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:publicId forKey:@"public_id"];
    [params setValue:[options valueForKey:@"type"] forKey:@"type"];
    [params setValue:[self buildEager:[options valueForKey:@"eager"]] forKey:@"eager"];
    [params setValue:[self buildCustomHeaders:[options valueForKey:@"headers"]] forKey:@"headers"];
    NSArray* tags = [CLCloudinary asArray:[options valueForKey:@"tags"]];
    [params setValue:[tags componentsJoinedByString:@","] forKey:@"tags"];    
    [self callApi:@"explicit" file:nil params:params options:options];
}
- (void)addTag:(NSString *)tag publicIds:(NSArray *)publicIds options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSNumber* exclusive = [CLCloudinary asBool:[options valueForKey:@"exclusive"]];
    NSString* command = [exclusive boolValue] ? @"set_exclusive" : @"add";
    [self callTagsApi:tag command:command publicIds:publicIds options:options];
}
- (void)removeTag:(NSString *)tag publicIds:(NSArray *)publicIds options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    [self callTagsApi:tag command:@"remove" publicIds:publicIds options:options];
}
- (void)replaceTag:(NSString *)tag publicIds:(NSArray *)publicIds options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    [self callTagsApi:tag command:@"replace" publicIds:publicIds options:options];
}
- (void)text:(NSString *)text options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    static NSArray* TEXT_PARAMS = nil;
    if (TEXT_PARAMS == nil){
        TEXT_PARAMS = @[@"public_id", @"font_family", @"font_size", @"font_color", @"text_align", @"font_weight",
                       @"font_style", @"background", @"opacity", @"text_decoration"];
    }
    if (options == nil)options = @{};
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:text forKey:@"text"];
    for (NSString* param in TEXT_PARAMS){
        NSString* paramValue = [CLCloudinary asString:[options valueForKey:param]];
        [params setValue:paramValue forKey:param];
    }
    [self callApi:@"text" file:nil params:params options:options];
}

- (void)cancel
{
    if (connection != nil){
        [connection cancel];
        connection = nil;
    }
    [_responseData setLength:0];
}

// internal
- (void)callApi:(NSString *)action file:(id)file params:(NSMutableDictionary *)params options:(NSDictionary *)options
{
    if (options == nil)options = @{};
    _context = [options valueForKey:@"context"];
    NSString* apiKey = [_cloudinary get:@"api_key" options:options defaultValue:[params valueForKey:@"api_key"]];
    if (apiKey == nil)[NSException raise:@"CloudinaryError" format:@"Must supply api_key"];
    if ([options valueForKey:@"signature"] == nil || [options valueForKey:@"timestamp"] == nil){
        NSString* apiSecret = [_cloudinary get:@"api_secret" options:options defaultValue:nil];
        if (apiSecret == nil)[NSException raise:@"CloudinaryError" format:@"Must supply api_secret"];
        NSDate *today = [NSDate date];
        [params setValue:@((int)[today timeIntervalSince1970])forKey:@"timestamp"];
        [params setValue:[_cloudinary apiSignRequest:params secret:apiSecret] forKey:@"signature"];
        [params setValue:apiKey forKey:@"api_key"];
    } else {
        [params setValue:[options valueForKey:@"timestamp"] forKey:@"timestamp"];
        [params setValue:[options valueForKey:@"signature"] forKey:@"signature"];
        [params setValue:apiKey forKey:@"api_key"];
    }
    
    NSString* apiUrl = [_cloudinary cloudinaryApiUrl:action options:options];

    NSURLRequest *req = [self request:apiUrl params:params file:file];
    // create the connection with the request and start loading the data
    connection = [NSURLConnection connectionWithRequest:req delegate:self];
    if (connection == nil){
        [self error:@"Failed to initiate connection" code:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response_
{
    [_responseData setLength:0];
    response = response_;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)nserror
{
    NSInteger code = [response statusCode];

    [self error:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
          [nserror localizedDescription],
          [nserror userInfo][NSURLErrorFailingURLStringErrorKey]]
               code:code];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSInteger code = [response statusCode];
    
    if (code != 200 && code != 400 && code != 401 && code != 500){
        [self error:[NSString stringWithFormat:@"Server returned unexpected status code - %d - %@", code, [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]] code:code];
        return;
    }

    NSData *data = (NSData *)_responseData;
    NSError *error = nil;
    // parse the JSON and use it
    id json = [NSJSONSerialization JSONObjectWithData:data options:nil error:&error];
    
    if (error){
        // log the error
        DebugLog(@"Error: %@", error);[self error:[NSString stringWithFormat:@"Error parsing response. Error - %@. Response - %@.", error, [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]] code:code];
    }
    else if ([json isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = (NSDictionary *)json;
        
        NSDictionary* errorResponse = [dict valueForKey:@"error"];
        if (errorResponse == nil){
            [self success:dict];
        }
        else {
            [self error:[errorResponse valueForKey:@"message"] code:code];
        }
    }
    else {
        NSAssert(NO, @"Condition should never be met");
    }
}

- (NSURLRequest *)request:(NSString *)url params:(NSDictionary *)params file:(id)file
{
    NSString *boundary = [_cloudinary randomPublicId];
    
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                  timeoutInterval:60.0];

    [req setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", boundary];
    [req setValue:contentType forHTTPHeaderField:@"Content-type"];
    
    NSMutableData* postBody = [NSMutableData data];
    for (NSString* param in [params allKeys]){
        NSString* paramValue = [CLCloudinary asString:[params valueForKey:param]];
        if ([paramValue length] == 0)continue;
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
            if ([(NSString *)file rangeOfString:@"^https?:/.*" options:NSCaseInsensitiveSearch|NSRegularExpressionSearch].location != NSNotFound)
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
                if (error != nil){
                    [NSException raise:@"CloudinaryError" format:@"Error reading requested file - %@ %@",
                                 [error localizedDescription],
                                 [error userInfo][NSURLErrorFailingURLStringErrorKey], nil];
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
            [NSException raise:@"CloudinaryError" format:@"file number be either url, path to file or NSData"];
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

- (void)callTagsApi:(NSString *)tag command:(NSString *)command publicIds:(NSArray *)publicIds options:(NSDictionary *)options
{
    if (options == nil)options = @{};
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:tag forKey:@"tag"];
    [params setValue:command forKey:@"command"];
    [params setValue:[options valueForKey:@"type"] forKey:@"type"];
    [params setValue:[publicIds componentsJoinedByString:@","] forKey:@"public_ids"];
    [self callApi:@"tags" file:nil params:params options:options];
}
- (NSString *)buildEager:(NSArray *)transformations
{
    if (transformations == nil){
        return nil;
    }
    NSMutableArray* eager = [NSMutableArray arrayWithCapacity:[transformations count]];
    for (CLTransformation* transformation in transformations){
        NSMutableArray* singleEager = [NSMutableArray array];
        NSString* transformationString = [transformation generate];
        if ([transformationString length] > 0)
        {
            [singleEager addObject:transformationString];
        }
        if ([transformation isKindOfClass:[CLEagerTransformation class]])
        {
            CLEagerTransformation* eagerTransformation = (CLEagerTransformation *)transformation;
            if ([eagerTransformation.format length] > 0)
            {
                [singleEager addObject:eagerTransformation.format];
            }
        }
        [eager addObject:[singleEager componentsJoinedByString:@"/"]];
    }
    return [eager componentsJoinedByString:@"|"];
    
}
- (NSString *)buildCustomHeaders:(id)headers
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
        for (NSString* header in (NSArray *)headers){
            [headersString appendString:header];
            [headersString appendString:@"\n"];
        }
        return headersString;
    } else {
        NSDictionary* headersDict = (NSDictionary *)headers;
        NSMutableString* headersString = [NSMutableString string];
        for (NSString* header in [headersDict allKeys]){
            [headersString appendString:header];
            [headersString appendString:@": "];
            [headersString appendString:[headersDict valueForKey:header]];
            [headersString appendString:@"\n"];
        }
        return headersString;
    }
}
- (NSDictionary *)buildUploadParams:(NSDictionary *)options
{
    if (options == nil)options = @{};
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    id transformation = [options valueForKey:@"transformation" defaultValue:@""];
    if ([transformation isKindOfClass:[CLTransformation class]]){
        transformation = [((CLTransformation *)transformation)generate];
    }
    [params setValue:transformation forKey:@"transformation"];
    [params setValue:[options valueForKey:@"public_id"] forKey:@"public_id"];
    [params setValue:[options valueForKey:@"format"] forKey:@"format"];
    [params setValue:[options valueForKey:@"type"] forKey:@"type"];
    static NSArray * CL_BOOLEAN_UPLOAD_OPTIONS = nil;
    if (CL_BOOLEAN_UPLOAD_OPTIONS == nil)
        CL_BOOLEAN_UPLOAD_OPTIONS = @[@"backup", @"exif", @"faces", @"colors", @"image_metadata"];

    for (NSString* flag in CL_BOOLEAN_UPLOAD_OPTIONS){
        NSNumber* value = [CLCloudinary asBool:[options valueForKey:flag]];
        if (value != nil){
            NSString* valueString = [value boolValue] ? @"true" : @"false";
            [options setValue:valueString forKey:flag];
        }
    }
    [params setValue:[self buildEager:[options valueForKey:@"eager"]] forKey:@"eager"];
    [params setValue:[self buildCustomHeaders:[options valueForKey:@"headers"]] forKey:@"headers"];
    NSArray* tags = [CLCloudinary asArray:[options valueForKey:@"tags"]];
    [params setValue:[tags componentsJoinedByString:@","] forKey:@"tags"];
    return params;    
}

- (void)success:(NSDictionary *)result
{
    if (_completion != nil)
    {
        _completion(result, nil, 200, _context);
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(uploaderSuccess:context:)])
    {
        [_delegate uploaderSuccess:result context:_context];
    }
}

- (void)error:(NSString *)result code:(NSInteger)code
{
    if (_completion != nil)
    {
        _completion(nil, result, code, _context);
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(uploaderSuccess:context:)])
    {
        [_delegate uploaderError:result code:code context:_context];
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (_progress != nil)
    {
        _progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite, _context);
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(uploaderProgress:totalBytesWritten:totalBytesExpectedToWrite:context:)]){
        [_delegate uploaderProgress:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite context:_context];
    }
}

@end
