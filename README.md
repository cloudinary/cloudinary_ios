Cloudinary iOS SDK
==================

Cloudinary is a cloud service that offers a solution to a web application's entire image management pipeline.

Easily upload images to the cloud. Automatically perform smart image resizing, cropping and conversion without installing any complex software. Integrate Facebook or Twitter profile image extraction in a snap, in any dimension and style to match your website’s graphics requirements. Images are seamlessly delivered through a fast CDN, and much much more.

Cloudinary offers comprehensive APIs and administration capabilities and is easy to integrate with any web application, existing or new.

Cloudinary provides URL and HTTP based APIs that can be easily integrated with any Web development framework.

For iOS, Cloudinary provides an SDK for simplifying the integration even further.

## Setup ######################################################################

Download the latest SDK version from the following URL:

[http://res.cloudinary.com/cloudinary/raw/upload/cloudinary_ios_v1.0.15.zip](http://res.cloudinary.com/cloudinary/raw/upload/cloudinary_ios_v1.0.15.zip)


Extract the ZIP file and drag `libCloudinary.a` to the `Frameworks` folder of your Xcode project. Drag the `Cloudinary` folder that contains all .h include files to your Xcode project.

In Xcode, double-click the target's name under `Targets` in the `Project` window. Choose the `Build Settings` tab. Search for the `Other Linker Flags` build setting under the `Linking` collection and set its value to `-ObjC`.

## Try it right away

Sign up for a [free account](https://cloudinary.com/users/register/free) so you can try out image transformations and seamless image delivery through CDN.

*:information_source: Replace `demo` in all the following examples with your Cloudinary's `cloud name`.*  

Accessing an uploaded image with the `sample` public ID through a CDN:

    http://res.cloudinary.com/demo/image/upload/sample.jpg

![Sample](https://res.cloudinary.com/demo/image/upload/w_0.4/sample.jpg "Sample")

Generating a 150x100 version of the `sample` image and downloading it through a CDN:

    http://res.cloudinary.com/demo/image/upload/w_150,h_100,c_fill/sample.jpg

![Sample 150x100](https://res.cloudinary.com/demo/image/upload/w_150,h_100,c_fill/sample.jpg "Sample 150x100")

Converting to a 150x100 PNG with rounded corners of 20 pixels:

    http://res.cloudinary.com/demo/image/upload/w_150,h_100,c_fill,r_20/sample.png

![Sample 150x150 Rounded PNG](https://res.cloudinary.com/demo/image/upload/w_150,h_100,c_fill,r_20/sample.png "Sample 150x150 Rounded PNG")

For plenty more transformation options, see our [image transformations documentation](http://cloudinary.com/documentation/image_transformations).

Generating a 120x90 thumbnail based on automatic face detection of the Facebook profile picture of Bill Clinton:

    http://res.cloudinary.com/demo/image/facebook/c_thumb,g_face,h_90,w_120/billclinton.jpg

![Facebook 90x120](https://res.cloudinary.com/demo/image/facebook/c_thumb,g_face,h_90,w_120/billclinton.jpg "Facebook 90x200")

For more details, see our documentation for embedding [Facebook](http://cloudinary.com/documentation/facebook_profile_pictures) and [Twitter](http://cloudinary.com/documentation/twitter_profile_pictures) profile pictures.


## Usage

### Configuration

Each request for building a URL of a remote cloud resource must have the `cloud_name` parameter set.
Each request to our secure APIs (e.g., image uploads, eager sprite generation) must have the `api_key` and `api_secret` parameters set. See [API, URLs and access identifiers](http://cloudinary.com/documentation/api_and_access_identifiers) for more details.

Setting the `cloud_name`, `api_key` and `api_secret` parameters can be done either directly in each call to a Cloudinary method or by globally setting using the CLOUDINARY_URL variable.

The following example creates a `CLCloudinary` object initializd with a `CLOUDINARY_URL` varaible.   

```Objective-C
#import "Cloudinary/Cloudinary.h"

CLCloudinary *cloudinary = [[CLCloudinary alloc] initWithUrl: @"cloudinary://123456789012345:abcdeghijklmnopqrstuvwxyz12@n07t21i7"];
```

You can also set any configuration parameter programatically:

```Objective-C
CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
[cloudinary.config setValue:@"n07t21i7" forKey:@"cloud_name"];
[cloudinary.config setValue:@"123456789012345" forKey:@"api_key"];
[cloudinary.config setValue:@"abcdeghijklmnopqrstuvwxyz12" forKey:@"api_secret"];
```

:warning: The API includes operations that require authentication using the `api_secret`. However because it is not possible to secure the `api_secret` in applications running on client devices (such as a mobile app) **it is recommended not to include `api_secret` in such applications.**

### Embedding and transforming images

Any image uploaded to Cloudinary can be transformed and embedded using powerful view helper methods:

The following example generates a URL on an uploaded `sample` image:

```Objective-C
NSString *url = [cloudinary url:@"sample.jpg"];

// http://res.cloudinary.com/n07t21i7/image/upload/sample.jpg
```
The following example generates an image URL of an uploaded `sample` image while transforming it to fill a 100x150 rectangle:

```Objective-C
CLTransformation *transformation = [CLTransformation transformation];
[transformation setWidthWithInt: 100];
[transformation setHeightWithInt: 150];
[transformation setCrop: @"fill"];

NSString *url = [cloudinary url:@"sample.jpg" options:@{@"transformation": transformation}];

// http://res.cloudinary.com/n07t21i7/image/upload/c_fill,h_150,w_100/sample.jpg
```

Another example, embedding a smaller version of an uploaded image while generating a 90x90 face detection based thumbnail. This time using a dictionary of parameters:

```Objective-C
CLTransformation *transformation = [CLTransformation transformation];
[transformation setParams: @{@"width": @90, @"height": @90, @"crop": @"thumb", @"gravity": @"face"}];

NSString *url = [cloudinary url:@"sample.jpg" options:@{@"transformation": transformation}];

// http://res.cloudinary.com/n07t21i7/image/upload/c_thumb,g_face,h_90,w_90/sample.jpg
```

You can provide either a Facebook name or a numeric ID of a Facebook profile or a fan page.  

Embedding a Facebook profile to match your graphic design is very simple:

```Objective-C
CLTransformation *transformation = [CLTransformation transformation];
[transformation setWidthWithInt: 90];
[transformation setHeightWithInt: 130];
[transformation setCrop: @"fill"];
[transformation setGravity: @"north_west"];

NSString *url = [cloudinary url:@"billclinton.jpg" options:@{@"transformation": transformation, @"type": @"facebook"}];

// http://res.cloudinary.com/n07t21i7/image/facebook/c_fill,g_north_west,h_130,w_90/billclinton.jpg
```

See [our documentation](http://cloudinary.com/documentation/image_transformations) for more information about displaying and transforming images.

*:information_source: Until version 1.0.11 there was an issue in `setWidthWithFloat` (and similar methods) that caused round floats to be serialized as integers (e.g. `setWidthWithFloat(2.0)` produced `"w_2"`) this was  fixed in version 1.0.12.*


### Safe mobile uploading  

iOS applications might prefer to avoid keeping the sensitive `api_secret` on the mobile device. It is recommended to generate the upload authentication signature on the server side.
This way the `api_secret` is stored only on the much safer server-side.

Cloudinary's iOS SDK allows providing server-generated signature and any additional parameters that were generated on the server side (instead of signing using `api_secret` locally).

The following example initializes CLCloudinary without any authentication parameters:

```Objective-C
CLCloudinary *mobileCloudinary = [[CLCloudinary alloc] init];

[mobileCloudinary.config setValue:@"n07t21i7" forKey:@"cloud_name"];
```

You can use any Cloudinary libraries (Ruby on Rails, PHP, Python & Django, Java, Perl, .Net, etc.) on your server to generating the upload signature. The following JSON in an example of a response of an upload authorization request to your server:  

```Objective-C
{
  "signature": "sgjfdoigfjdgfdogidf9g87df98gfdb8f7d6gfdg7gfd8",
  "public_id": "abdbasdasda76asd7sa789",
  "timestamp": 1346925631,
  "api_key": "123456789012345",
}
```

The following code uploads an image to Cloudinary with the parameters generated safely on the server side (e.g., from a JSON as in the example above). Note that the `imageData` parameter can either be the actual image data or a path of a local image file.

```Objective-C
CLUploader* mobileUploader = [[CLUploader alloc] init:mobileCloudinary delegate:self];
NSDictionary* uploadResponse = [mobileUploader upload:imageData options:signedRequest];
```

The `signedPreloadedImage` can be used to create a serialized format of the upload result that can be validated by the server.

```Objective-C
NSString *signedIdentifier = [cloudinary signedPreloadedImage:uploadResponse];

// image/upload/v1234567/dfhjghjkdisudgfds7iyf.jpg#298hg20j2eoalgh3ekl
```

You might want to reference uploaded Cloudinary images and raw files using an identifier string of the following format:

    {resource_type}/{type}/v{version}/{public_id}.{format}

Cloudinary URL can be directly generated from an idenfier in either formats mentioned above:

```Objective-C
NSString *imageIdentifier = @"image/upload/v1234567/dfhjghjkdisudgfds7iyf.jpg";
NSString *url = [cloudinary url:imageIdentifier];

// http://res.cloudinary.com/n07t21i7/image/upload/v1234567/dfhjghjkdisudgfds7iyf.jpg
```

Same can work for raw file uploads:

```Objective-C
NSString *rawIdentifier = @"raw/upload/v1234567/cguysfdsfuydsfyuds31.doc";
NSString *url = [cloudinary url:rawIdentifier];

// http://res.cloudinary.com/n07t21i7/raw/upload/v1234567/cguysfdsfuydsfyuds31.doc
```

### Upload

:warning: It is recommended not to include `api_secret` in mobile applications. See [Safe mobile uploading](#safe-mobile-uploading) below for an alternative method.

Assuming you have your Cloudinary configuration parameters defined (`cloud_name`, `api_key`, `api_secret`), uploading to Cloudinary is very simple.

First you need to implement the `CLUploaderDelegate` protocol for receiving successful and failed upload callbacks as well as upload progress notification. For example:

```Objective-C
#import "ViewController.h"
#import "Cloudinary/Cloudinary.h"

@interface ViewController () <CLUploaderDelegate>
@end

@implementation ViewController

...

- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
    NSString* publicId = [result valueForKey:@"public_id"];
    NSLog(@"Upload success. Public ID=%@, Full result=%@", publicId, result);
}

- (void) uploaderError:(NSString*)result code:(int) code context:(id)context {
    NSLog(@"Upload error: %@, %d", result, code);
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
    NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
}

@end
```

The following example uploads a local PNG to the cloud. The path of the image is given to the upload method.

```Objective-C
CLCloudinary *cloudinary = [[CLCloudinary alloc] initWithUrl: @"cloudinary://123456789012345:abcdeghijklmnopqrstuvwxyz12@n07t21i7"];

CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];

[uploader upload:imageFilePath options:@{}];
```

Here is a sample log printing of the result dictionary received by the `uploaderSuccess` callback:

    {
        format = png;
        height = 51;
        "public_id" = nmnbdil0cjbuxjmxmzgt;
        "resource_type" = image;
        "secure_url" = "https://.../n07t21i7/image/upload/v1351796439/nmnbdil0cjbuxjmxmzgt.png";
        signature = 3a09d19f85ea029d7862fe1f58ff3a25164c6270;
        url = "http://.../n07t21i7/image/upload/v1351796439/nmnbdil0cjbuxjmxmzgt.png";
        version = 1351796439;
        width = 241;
    }

The uploaded image is assigned a randomly generated public ID. The image is immediately available for download through a CDN:

```Objective-C
[cloudinary url:@"nmnbdil0cjbuxjmxmzgt.png"]

// http://res.cloudinary.com/n07t21i7/image/upload/nmnbdil0cjbuxjmxmzgt.png
```

You can also specify your own public ID. In the following example the actual data of the image is given to the upload method:

```Objective-C
NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath];
[uploader upload:imageData options:@{@"public_id": @"ios_image_1"}];
```
The following example uploads an image based on a given remote URL:

```Objective-C
[uploader upload:@"http://cloudinary.com/images/logo.png" options:@{}];
```
In order to upload a raw file, set the `resource_type` parameter to `raw`:

```Objective-C
CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
[uploader upload:[self file] options:@{@"resource_type": @"raw"}];
```

Alternatively, you can set the `resource_type` parameter to `auto`, as demonstrated in this [blog post](http://cloudinary.com/blog/using_cloudinary_to_manage_all_your_website_s_assets_in_the_cloud).

Instead of implementing the `CLUploaderDelegate` you can provide block parameters for receiving uploading progress and completion events. The following example uploaded a local image while providing `withCompletion` & `andProgress` blocks:

```Objective-C
[uploader upload:imageFilePath options:@{} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
    if (successResult) {
        NSString* publicId = [successResult valueForKey:@"public_id"];
        NSLog(@"Block upload success. Public ID=%@, Full result=%@", publicId, successResult);
    } else {
        NSLog(@"Block upload error: %@, %d", errorResult, code);

    }
} andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
    NSLog(@"Block upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
}];
```

*:information_source: A dedicated `CLUploader` instance must be used for each file uploading.*

Synchronous upload is supported and is required for using the upload API from within an `NSOperation`. Simply set the `sync` option to `@YES`.

```Objective-C
[uploader upload:imageFilePath options:@{@"sync": @YES}];
```
See [our documentation](http://cloudinary.com/documentation/upload_images) for plenty more options of direct uploading to the cloud.


### Safe mobile uploading  

iOS applications might prefer to avoid keeping the sensitive `api_secret` on the mobile device. It is recommended to generate the upload authentication signature on the server side.
This way the `api_secret` is stored only on the much safer server-side.

Cloudinary's iOS SDK allows providing server-generated signature and any additional parameters that were generated on the server side (instead of signing using `api_secret` locally).

The following example initializes CLCloudinary without any authentication parameters:

```Objective-C
CLCloudinary *mobileCloudinary = [[CLCloudinary alloc] init];

[mobileCloudinary.config setValue:@"n07t21i7" forKey:@"cloud_name"];
```

You can use any Cloudinary libraries (Ruby on Rails, PHP, Python & Django, Java, Perl, .Net, etc.) on your server to generating the upload signature. The following JSON in an example of a response of an upload authorization request to your server:  

```Objective-C
{
  "signature": "sgjfdoigfjdgfdogidf9g87df98gfdb8f7d6gfdg7gfd8",
  "public_id": "abdbasdasda76asd7sa789",
  "timestamp": 1346925631,
  "api_key": "123456789012345",
}
```

The following code uploads an image to Cloudinary with the parameters generated safely on the server side (e.g., from a JSON as in the example above). Note that the `imageData` parameter can either be the actual image data or a path of a local image file.

```Objective-C
CLUploader* mobileUploader = [[CLUploader alloc] init:mobileCloudinary delegate:self];
NSDictionary* uploadResponse = [mobileUploader upload:imageData options:signedRequest];
```

The `signedPreloadedImage` can be used to create a serialized format of the upload result that can be validated by the server.

```Objective-C
NSString *signedIdentifier = [cloudinary signedPreloadedImage:uploadResponse];

// image/upload/v1234567/dfhjghjkdisudgfds7iyf.jpg#298hg20j2eoalgh3ekl
```

You might want to reference uploaded Cloudinary images and raw files using an identifier string of the following format:

    {resource_type}/{type}/v{version}/{public_id}.{format}

Cloudinary URL can be directly generated from an idenfier in either formats mentioned above:

```Objective-C
NSString *imageIdentifier = @"image/upload/v1234567/dfhjghjkdisudgfds7iyf.jpg";
NSString *url = [cloudinary url:imageIdentifier];

// http://res.cloudinary.com/n07t21i7/image/upload/v1234567/dfhjghjkdisudgfds7iyf.jpg
```

Same can work for raw file uploads:

```Objective-C
NSString *rawIdentifier = @"raw/upload/v1234567/cguysfdsfuydsfyuds31.doc";
NSString *url = [cloudinary url:rawIdentifier];

// http://res.cloudinary.com/n07t21i7/raw/upload/v1234567/cguysfdsfuydsfyuds31.doc
```
## Additional resources ##########################################################

Additional resources are available at:

* [Website](http://cloudinary.com)
* [Features overview](http://cloudinary.com/features)
* [Documentation](http://cloudinary.com/documentation)
* [Image transformations documentation](http://cloudinary.com/documentation/image_transformations)
* [Upload API documentation](http://cloudinary.com/documentation/upload_images)

## Support

You can [open an issue through GitHub](https://github.com/cloudinary/cloudinary_ios/issues).

Contact us at [info@cloudinary.com](mailto:info@cloudinary.com)

Or via Twitter: [@cloudinary](https://twitter.com/cloudinary)

## License #######################################################################

Released under the MIT license.
