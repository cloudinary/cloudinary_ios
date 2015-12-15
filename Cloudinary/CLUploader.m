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
#import "NSDictionary+CLUtilities.h"

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
    NSPort* _port;
}

- (id)init:(CLCloudinary *)cloudinary delegate:(id<CLUploaderDelegate>)delegate
{
    if ( self = [super init] )
    {
        _delegate = delegate;
        _cloudinary = cloudinary;
        _responseData = [NSMutableData data];
        _port = nil;
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

- (void)unsignedUpload:(id)file uploadPreset:(NSString*)uploadPreset options:(NSDictionary *)options
{
    [self unsignedUpload:file uploadPreset:uploadPreset options:options withCompletion:nil andProgress:nil];
}

- (void)destroy:(NSString *)publicId options:(NSDictionary *)options
{
    [self destroy:publicId options:options withCompletion:nil andProgress:nil];
}

- (void)rename:(NSString *)fromPublicId toPublicId:(NSString *)toPublicId options:(NSDictionary *)options
{
    [self rename:fromPublicId toPublicId:toPublicId options:options withCompletion:nil andProgress:nil];
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

- (void) generateSprite:(NSString *) tag options:(NSDictionary *)options
{
    [self generateSprite: tag options:options withCompletion:nil andProgress:nil];
}


- (void) multi:(NSString *) tag options:(NSDictionary *)options
{
    [self multi: tag options:options withCompletion:nil andProgress:nil];
}


- (void)upload:(id)file options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSMutableDictionary *params = (NSMutableDictionary *)[self buildUploadParams:options];
    [self callApi:@"upload" file:file params:params options:options];
}

- (void)unsignedUpload:(id)file uploadPreset:(NSString*)uploadPreset options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    NSMutableDictionary *extraOptions = [NSMutableDictionary dictionaryWithDictionary:@{@"upload_preset": uploadPreset, @"unsigned": @YES}];
    if (options != nil) {
        [extraOptions addEntriesFromDictionary:options];
    }
    return [self upload:file options:extraOptions withCompletion:completionBlock andProgress:progressBlock];
}

- (void)destroy:(NSString *)publicId options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSString* type = [options cl_valueForKey:@"type" defaultValue:@"upload"];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:type, @"type", publicId, @"public_id",[CLCloudinary asBool:[options valueForKey:@"invalidate"]], @"invalidate", nil];
    [self callApi:@"destroy" file:nil params:params options:options];
}

- (void)rename:(NSString *)fromPublicId toPublicId:(NSString *)toPublicId options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSString* type = [options cl_valueForKey:@"type" defaultValue:@"upload"];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:fromPublicId forKey:@"from_public_id"];
    [params setValue:toPublicId forKey:@"to_public_id"];
    [params setValue:type forKey:@"type"];
    [params setValue:[CLCloudinary asBool:[options valueForKey:@"overwrite"]] forKey: @"overwrite"];
    [params setValue:[CLCloudinary asBool:[options valueForKey:@"invalidate"]] forKey: @"invalidate"];
    [self callApi:@"rename" file:nil params:params options:options];
}

- (void)explicit:(NSString *)publicId options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:publicId forKey:@"public_id"];
    [params setValue:[options valueForKey:@"type"] forKey:@"type"];
    [params setValue:[self buildEager:[options valueForKey:@"eager"]] forKey:@"eager"];
    [params setValue:[options valueForKey:@"eager_notification_url"] forKey:@"eager_notification_url"];
    [params setValue:[CLCloudinary asBool:[options valueForKey:@"eager_async"]] forKey: @"eager_async"];
    [params setValue:[CLCloudinary asBool:[options valueForKey:@"invalidate"]] forKey: @"invalidate"];
    [params setValue:[self buildCustomHeaders:[options valueForKey:@"headers"]] forKey:@"headers"];
    NSArray* tags = [CLCloudinary asArray:[options valueForKey:@"tags"]];
    [params setValue:[tags componentsJoinedByString:@","] forKey:@"tags"];
    [self callApi:@"explicit" file:nil params:params options:options];
}

- (void) generateSprite:(NSString *)tag options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [params setValue:tag forKey:@"tag"];
    [params setValue:[options valueForKey:@"notification_url"] forKey:@"notification_url"];
    [params setValue:[CLCloudinary asBool:[options valueForKey:@"async"]] forKey:@"async"];
    
    id transParam = [options valueForKey:@"transformation"];
    CLTransformation* transformation = nil;
    if ([transParam isKindOfClass:[CLTransformation class]]){
        transformation = (CLTransformation *) transParam;
    } else if ([transParam isKindOfClass:[NSString class]]) {
        transformation = [[CLTransformation alloc] init];
        transformation.rawTransformation = transParam;
    } else {
        transformation = [[CLTransformation alloc] init];
    }
    
    NSString* format = (NSString*) [options valueForKey:@"format"];
    if (format != nil) {
        transformation.fetchFormat = format;
    }
    
    [params setValue:[transformation generate] forKey:@"transformation"];
    
    [self callApi:@"sprite" file:nil params:params options:options];
}


- (void) multi:(NSString *)tag options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock
{
    [self setCompletion:completionBlock andProgress:progressBlock];
    if (options == nil)options = @{};
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [params setValue:tag forKey:@"tag"];
    [params setValue:[options valueForKey:@"notification_url"] forKey:@"notification_url"];
    [params setValue:[options valueForKey:@"format"] forKey:@"format"];
    [params setValue:[CLCloudinary asBool:[options valueForKey:@"async"]] forKey:@"async"];
    
    id transformation = [options cl_valueForKey:@"transformation" defaultValue:@""];
    if ([transformation isKindOfClass:[CLTransformation class]]){
        transformation = [((CLTransformation *)transformation)generate];
    }
    [params setValue:transformation forKey:@"transformation"];
    [self callApi:@"multi" file:nil params:params options:options];
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

- (void)deleteByToken:(NSString*)token options:(NSDictionary *)options
{
    [self deleteByToken:token options:options withCompletion:nil];
}

- (void)deleteByToken:(NSString*)token options:(NSDictionary *)options withCompletion:(CLUploaderCompletion)completionBlock
{
    [self setCompletion:completionBlock andProgress:nil];
    if (options == nil) options = @{};
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:token forKey:@"token"];
    
    [self callApi:@"delete_by_token" file:nil params:params options:options];
}

// internal
- (void)callApi:(NSString *)action file:(id)file params:(NSMutableDictionary *)params options:(NSDictionary *)options
{
    if (options == nil)options = @{};
    _context = [options valueForKey:@"_context"];
    if ([options valueForKey:@"unsigned"]) {
        // Nothing to do
    } else {
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
    }
    
    NSString* apiUrl = [_cloudinary cloudinaryApiUrl:action options:options];

    NSURLRequest *req = [self request:apiUrl params:params file:file timeout:[options valueForKey:@"timeout"]];
    // create the connection with the request and start loading the data
    if ([[_cloudinary get:@"sync" options:options defaultValue:@NO] boolValue]) {
        NSError* nserror = nil;
        NSURLResponse* nsresponse = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&nsresponse error:&nserror];
        NSURLConnection* dummyConnection = [NSURLConnection alloc];
        if (nserror != NULL) {
            [self connection:dummyConnection didFailWithError:nserror];
        } else {
            [self connection:dummyConnection didReceiveResponse:nsresponse];
            [self connection:dummyConnection didReceiveData:data];
            [self connectionDidFinishLoading:dummyConnection];
        }
    } else {
        connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
        if (connection == nil){
            [self error:@"Failed to initiate connection" code:0];
        }
        if ([[_cloudinary get:@"runLoop" options:options defaultValue:@NO] boolValue]) {
            _port = [NSPort port];
            NSRunLoop* runloop = [NSRunLoop currentRunLoop];
            [runloop addPort:_port forMode:NSDefaultRunLoopMode];
            [connection scheduleInRunLoop:runloop forMode:NSDefaultRunLoopMode];
        }
        else
        {
            [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                  forMode:NSDefaultRunLoopMode];
        }
        [connection start];
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
    if (_port != nil) {
        [[NSRunLoop currentRunLoop] removePort:_port forMode:NSDefaultRunLoopMode];
        _port = nil;
    }

    NSInteger code = [response statusCode];

    [self error:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",
          [nserror localizedDescription],
          [nserror userInfo][NSURLErrorFailingURLStringErrorKey]]
               code:code];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_port != nil) {
        [[NSRunLoop currentRunLoop] removePort:_port forMode:NSDefaultRunLoopMode];
        _port = nil;
    }

    NSInteger code = [response statusCode];

    if (code != 200 && code != 400 && code != 401 && code != 403 && code != 404 && code != 500){
        [self error:[NSString stringWithFormat:@"Server returned unexpected status code - %ld - %@", (long) code, [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]] code:code];
        return;
    }

    NSData *data = (NSData *)_responseData;
    NSError *error = nil;
    // parse the JSON and use it
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error){
        // log the error
        [self error:[NSString stringWithFormat:@"Error parsing response. Error - %@. Response - %@.", error, [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]] code:code];
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

- (void)encodeParam:(NSMutableData*)postBody param:(NSString*)param paramValue:(NSString*)paramValue boundary:(NSString*)boundary
{
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[paramValue dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURLRequest *)request:(NSString *)url params:(NSDictionary *)params file:(id)file timeout:(NSNumber*)timeout
{
    NSString *boundary = [_cloudinary randomPublicId];
    float timeoutInternal = timeout ? [timeout floatValue] : 60.0;
    
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                  timeoutInterval:timeoutInternal];

    [req setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", boundary];
    [req setValue:contentType forHTTPHeaderField:@"Content-type"];
    NSString *userAgent = [NSString stringWithFormat:@"CloudinaryiOS/%@", [CLCloudinary version]];
    [req setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    NSMutableData* postBody = [NSMutableData data];
    for (NSString* param in [params allKeys]){
        NSObject* value = [params valueForKey:param];
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *arrayValue = (NSArray*) value;
            for (NSString *paramValue in arrayValue) {
                [self encodeParam:postBody param:[param stringByAppendingString:@"[]"] paramValue:paramValue boundary:boundary];
            }
        } else {
            NSString *paramValue = [CLCloudinary asString:value];
            if ([paramValue length] == 0) continue;
            [self encodeParam:postBody param:param paramValue:paramValue boundary:boundary];
        }
    }
    if (file != nil)
    {
        NSString* filename = @"file";
        NSData *data;
        if ([file isKindOfClass:[NSString class]])
        {
            if ([(NSString *)file rangeOfString:@"^ftp:|^https?:|^s3:|^data:[^;]*;base64,([a-zA-Z0-9/+\n=]+)$" options:NSCaseInsensitiveSearch|NSRegularExpressionSearch].location != NSNotFound)
            {
                [self encodeParam:postBody param:@"file" paramValue:file boundary:boundary];
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
    [req setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    return req;
}

- (void)callTagsApi:(NSString *)tag command:(NSString *)command publicIds:(NSArray *)publicIds options:(NSDictionary *)options
{
    if (options == nil)options = @{};
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:tag forKey:@"tag"];
    [params setValue:command forKey:@"command"];
    [params setValue:[options valueForKey:@"type"] forKey:@"type"];
    [params setValue:publicIds forKey:@"public_ids"];
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
- (NSString *)buildContext:(NSDictionary *)context
{
    if (context == nil) {
        return nil;
    }
    NSMutableArray* contextStrings = [NSMutableArray arrayWithCapacity:[context count]];
    for (NSString* key in context){
        NSString* value = [context valueForKey:key];
        [contextStrings addObject:[@[key, value] componentsJoinedByString:@"="]];
    }
    return [contextStrings componentsJoinedByString:@"|"];
}
- (NSString *)buildCoordinates:(id) coordinates
{
    if (coordinates == nil){
        return nil;
    }
    coordinates = [CLCloudinary asArray:coordinates];
    if ([coordinates count] > 0 && [coordinates[0] isKindOfClass:[NSString class]]) {
        return [coordinates componentsJoinedByString:@","];
    } else {
        NSMutableArray* coordinate_strings = [NSMutableArray arrayWithCapacity:[coordinates count]];
        for (id tuple in coordinates) {
            [coordinate_strings addObject:[tuple componentsJoinedByString:@","]];
        }
        return [coordinate_strings componentsJoinedByString:@"|"];
    }
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
    static NSArray * CL_BOOLEAN_UPLOAD_OPTIONS = nil;
    if (CL_BOOLEAN_UPLOAD_OPTIONS == nil)
        CL_BOOLEAN_UPLOAD_OPTIONS = @[@"backup", @"exif", @"faces", @"colors", @"image_metadata", @"use_filename", @"unique_filename", @"discard_original_filename", @"eager_async", @"invalidate", @"overwrite", @"phash", @"return_delete_token"];
    static NSArray * CL_SIMPLE_UPLOAD_OPTIONS = nil;
    if (CL_SIMPLE_UPLOAD_OPTIONS == nil)
        CL_SIMPLE_UPLOAD_OPTIONS = @[@"public_id", @"callback", @"format", @"type", @"notification_url", @"eager_notification_url", @"proxy", @"folder", @"moderation", @"raw_convert", @"ocr", @"categorization", @"detection", @"similarity_search", @"auto_tagging", @"upload_preset"];

    if (options == nil)options = @{};
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    for (NSString* param in CL_SIMPLE_UPLOAD_OPTIONS){
        [params setValue:options[param] forKey:param];
    }
    for (NSString* flag in CL_BOOLEAN_UPLOAD_OPTIONS){
        [params setValue:[CLCloudinary asBool:options[flag]] forKey: flag];
    }

    if (options[@"signature"] == nil) {
        id transformation = [options cl_valueForKey:@"transformation" defaultValue:@""];
        if ([transformation isKindOfClass:[CLTransformation class]]){
            transformation = [((CLTransformation *)transformation)generate];
        }
        [params setValue:transformation forKey:@"transformation"];
        NSArray* tags = [CLCloudinary asArray:options[@"tags"]];
        [params setValue:[tags componentsJoinedByString:@","] forKey:@"tags"];
        NSArray* allowedFormats = [CLCloudinary asArray:options[@"allowed_formats"]];
        [params setValue:[allowedFormats componentsJoinedByString:@","] forKey:@"allowed_formats"];
        [params setValue:[self buildContext:options[@"context"]] forKey:@"context"];
        [params setValue:[self buildCoordinates:options[@"face_coordinates"]] forKey:@"face_coordinates"];
        [params setValue:[self buildCoordinates:options[@"custom_coordinates"]] forKey:@"custom_coordinates"];
        [params setValue:[self buildEager:options[@"eager"]] forKey:@"eager"];
        [params setValue:[self buildCustomHeaders:options[@"headers"]] forKey:@"headers"];
    } else {
        [params setValue:options[@"transformation"] forKey:@"transformation"];
        [params setValue:options[@"tags"] forKey:@"tags"];
        [params setValue:options[@"allowed_formats"] forKey:@"allowed_formats"];
        [params setValue:options[@"context"] forKey:@"context"];
        [params setValue:options[@"face_coordinates"] forKey:@"face_coordinates"];
        [params setValue:options[@"custom_coordinates"] forKey:@"custom_coordinates"];
        [params setValue:options[@"eager"] forKey:@"eager"];
        [params setValue:options[@"headers"] forKey:@"headers"];
    }
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
