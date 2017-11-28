![Cloudinary: Image And Video Management In The Cloud](https://res.cloudinary.com/cloudinary/image/asset/dpr_2.0/logo-e0df892053afd966cc0bfe047ba93ca4.png)
==================

Cloudinary iOS SDK
==================

Cloudinary is a cloud service that offers a solution to an application's entire image management pipeline.

## Features

* Easily upload images and videos to the cloud.
* Automatically perform smart image resizing, cropping and conversion without installing complex software.
* Integrate Facebook or Twitter profile images in a snap, in any dimension and style to match your website’s graphics requirements.
* Media resources are seamlessly delivered through a fast CDN.

and much much more...

Cloudinary offers comprehensive APIs and administration capabilities and is easy to integrate with any web application, existing or new.

Cloudinary provides URL and HTTP based APIs that can be easily integrated with any Web development framework.

For iOS, Cloudinary provides an SDK for simplifying the integration even further.

[Complete Documentation](https://cloudinary.com/documentation/)

## Requirements

- iOS 8.0+

## Integration

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. 
To install CocoaPods:

```bash
$ sudo gem install cocoapods
```
If you don't have a `Podfile` in your project yet, add it by running the command:
```bash
$ pod init
```

Add the Cloudinary SDK to your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
  pod 'Cloudinary', '~> 2.0'
end
```

Then, run the command:

```bash
$ pod install
```

### Working with the Cloudinary iOS SDK Manually

If you prefer not use a dependency manager, you can add Cloudinary manually by adding it as a submodule to your project:

Open Terminal and navigate to your project's top level directory.

If your project is not initialized as a git repository, run the command:

```bash
$ git init
```

To add cloudinary as a git submodule, run the command:

```bash
$ git submodule add https://github.com/cloudinary/cloudinary_ios.git
```

#### Embedded Framework

1. Drag `Cloudinary.xcodeproj` into the Project Navigator of your application's Xcode project. It should appear under your application's blue project icon.
2. Select `Cloudinary.xcodeproj` and make sure the deployment target matches that of your application target.
3. Select your application project. Under 'TARGETS' select your application, open the 'General' tab, click on the `+` button under the 'Embedded Binaries' and Select 'Cloudinary.framework'.

#### Dependencies

The Cloudinary iOS SDK depends on [Alamofire](https://github.com/Alamofire/Alamofire). If you add Cloudinary manually you will need to [add Alamofire manually to your project](https://github.com/Alamofire/Alamofire/tree/4.5.1#manually). Make sure to checkout the correct version after adding the submodule ([as explained here](#submodule)).

### Build Framework

Here's the steps to get the framework project to build, in case you want to work on the project itself.

After cloning the repository, you will need to add Alamofire v4.5.1, there are several ways to do so:

##### Submodule

1. Open Terminal, navigate to Cloudinary's cloned repository folder, then add Alamofire as a git submodule by running the command:

```bash
$ git submodule add https://github.com/Alamofire/Alamofire.git
```

2. Checkout the desired Alamofire version:
```bash
$ cd Alamofire/
```

```bash
$ git checkout 4.5.1
```

###### Add library

1. Open the new Alamofire folder and drag `Alamofire.xcodeproj` into the Project Navigator of Cloudinary's Xcode project.
2. Select the Cloudinary project, and under 'TARGETS' select Cloudinary. Then open the 'General' tab, click on the `+` button under the 'Linked Frameworks and Libraries' and Select 'Alamofire.framework'.

##### Download source

You can download Alamofire v4.5.1 from [here](https://github.com/Alamofire/Alamofire/archive/4.5.1.zip). Then follow the instruction in [Add library](#add_library)

## Usage

### Configuration

To use the API, you will need a CLDCloudinary instance, which is initialized with an instance of CLDConfiguration.

The CLDConfiguration must have its `cloudName` and `apiKey` properties set. Other properties are optional, but secure API requests must be signed using the `apiSecret` param (or alternatively by using [Safe Mobile Requests](#safe-mobile-requests)). 

See [API, URLs and access identifiers](https://cloudinary.com/documentation/api_and_access_identifiers) for more details.

There are several ways to initialize CLDConfiguration. You can simply call its constructor with the desired params:
```swift
let config = CLDConfiguration(cloudName: "CLOUD_NAME", apiKey: "API_KEY")
```

Another way is by passing a URL of the form: cloudinary://API_KEY:API_SECRET@CLOUD_NAME
```swift
let config = CLDConfiguration(cloudinaryUrl: "cloudinary://<API_KEY>:<API_SECRET>@<CLOUD_NAME>")
```

You can also add the same URL as an environment parameters under `CLOUDINARY_URL`, then initialize CLDConfiguration using its static initializer
```swift
let config = CLDConfiguration.initWithEnvParams()
```

Now you can create a CLDCloudinary instance to work with
```swift
let cloudinary = CLDCloudinary(configuration: config)
```

### Safe Mobile Requests

You should avoid keeping the sensitive `apiSecret` on the mobile device. Instead, it is recommended to generate the upload authentication signature on the server side.

Cloudinary's iOS SDK allows providing a server-generated signature and any additional parameters that were generated on the server side (instead of signing using the `apiSecret` locally).

You can use any Cloudinary libraries (Ruby on Rails, PHP, Python & Django, Java, Perl, .Net, etc.)
 on your server to generate the upload signature. The following JSON in an example response of an upload
  authorization request to your server:  

```Objective-C
{
  "signature": "sgjfdoigfjdgfdogidf9g87df98gfdb8f7d6gfdg7gfd8",
  "public_id": "abdbasdasda76asd7sa789",
  "timestamp": 1346925631,
  "api_key": "123456789012345",
}
```

After generating the signature on your server, create a `CLDSignature` instance and pass it to the desired secure request, in this case, to upload a file:
```swift
let config = CLDConfiguration(cloudName: "CLOUD_NAME", apiKey: "API_KEY", apiSecret: nil)
let cloudinary = CLDCloudinary(configuration: config)
let signature = CLDSignature(signature: signature, timestamp: timestamp)
let params = CLDUploadRequestParams()
params.setSignature(signature)
cloudinary.createUploader().upload(file: fileURL, params: params, completionHandler: { (response, error) in
            // Handle respone
        })
```

### URL generation

The following example generates a URL on an uploaded `sample` image:
```swift
cloudinary.createUrl().generate("sample.jpg")

// http://res.cloudinary.com/CLOUD_NAME/image/upload/sample.jpg
```

The following example generates an image URL of an uploaded `sample` image while transforming it to fill a 100x150 rectangle:

```swift
let transformation = CLDTransformation().setWidth(100).setHeight(150).setCrop(.Crop)
cloudinary.createUrl().setTransformation(transformation).generate("sample.jpg")

// http://res.cloudinary.com/CLOUD_NAME/image/upload/c_fill,h_150,w_100/sample.jpg
```

Another example, embedding a smaller version of an uploaded image while generating a 90x90 face detection based thumbnail:

```swift
let transformation = CLDTransformation().setWidth(90).setHeight(90).setCrop(.Thumb).setGravity(.Face)
cloudinary.createUrl().setTransformation(transformation).generate("sample.jpg")

// http://res.cloudinary.com/CLOUD_NAME/image/upload/c_thumb,g_face,h_90,w_90/sample.jpg
```

You can provide either a Facebook name or a numeric ID of a Facebook profile or a fan page.  

Embedding a Facebook profile to match your graphic design is very simple:

```swift
let url = cloudinary.createUrl().setTransformation(CLDTransformation().setWidth(90).setHeight(130).setGravity(.Face).setCrop(.Fill)).setType(.Facebook).generate("billclinton.jpg")

// http://res.cloudinary.com/CLOUD_NAME/image/facebook/c_fill,g_face,h_130,w_90/billclinton.jpg
```

You can also chain transformations together:

```swift
let transformation = CLDTransformation().setWidth(100).setHeight(150).chain().setCrop(.Fit)
let url = cloudinary.createUrl().setTransformation().generate("sample.jpg")

// http://res.cloudinary.com/CLOUD_NAME/image/facebook/h_150,w_100/c_fit/sample.jpg
```

See [our documentation](https://cloudinary.com/documentation/image_transformations) for more information about displaying and transforming images.

### Upload

Uploading to your cloud is very straightforward.

In the following example the file located at `fileUrl` is uploaded to your cloud:

```swift
cloudinary.createUploader().upload(file: fileUrl)
```

`fileUrl` can point to either a local or a remote file.

You can also upload data:

```swift
cloudinary.createUploader().upload(data: data)
```

The uploaded image is assigned a randomly generated public ID, which is returned as part of the response.

You can pass  an instance of `CLDUploadRequestParams` for extra parameters you'd want to pass as part of the upload request. For example, you can specify your own public ID instead of a randomly generated one.
                                                                                                                             
For a full list of available upload parameters, see [the Upload API Reference](https://cloudinary.com/documentation/image_upload_api_reference#upload) documentation.

You can also pass a `progress` closure that is called periodically during the data transfer, and a `completionHandler` closure to be called once the request has finished, holding either the response object or the error.


In the following example, we apply an incoming transformation as part of the upload request, the transformation is applied before saving the image in the cloud.
We also specify a public ID and pass closures for the upload progress and completion handler.
```swift
let params = CLDUploadRequestParams()
params.setTransformation(CLDTransformation().setGravity(.NorthWest))
params.setPublicId("my_public_id")
let request = cloudinary.createUploader().upload(file: fileUrl, params: params, progress: { (bytes, totalBytes, totalBytesExpected) in
    // Handle progress
    }) { (response, error) in
        // Handle response
}
```

Every upload request returns a CLDUploadRequest instance, allowing options such as cancelling, suspending or resuming it.

### Download

The SDK provides some convenient methods for downloading files from your cloud:

```swift
cloudinary.createDownloader().fetchImage(url)
```

You can also pass a `progress` closure that is called periodically during the data transfer, and a `completionHandler` closure to be called once the request has finished, holding either the fetched UIImage or an error.

```swift
let request = cloudinary.createDownloader().fetchImage(url, progress: { (bytes, totalBytes, totalBytesExpected) in
            // Handle progress
            }) { (responseImage, error) in
                // Handle response
        }
```

Every download request returns an instance implementing CLDFetchImageRequest, allowing options such as cancelling, suspending or resuming it.

The downloaded image is cached both to the memory and the disk (customizable). The disk cache size is limited and can be changed.

### Other APIs

Management APIs are available as well, via CLDManagementApi
```swift
cloudinary.createManagementApi()
```

See out [documentation](https://cloudinary.com/documentation/image_upload_api_reference) for further details.

## Additional resources

Additional resources are available at:

* [Website](https://cloudinary.com)
* [Interactive demo](https://demo.cloudinary.com/default)
* [Features overview](https://cloudinary.com/features)
* [Documentation](https://cloudinary.com/documentation)
* [Knowledge Base](https://support.cloudinary.com/hc/en-us)
* [Image transformations documentation](https://cloudinary.com/documentation/image_transformations)
* [Upload API documentation](https://cloudinary.com/documentation/upload_images)

## Support

You can [open an issue through GitHub](https://github.com/cloudinary/cloudinary_ios/issues).

Contact us at [https://cloudinary.com/contact](https://cloudinary.com/contact).

Stay tuned for updates, tips and tutorials: [Blog](https://cloudinary.com/blog), [Twitter](https://twitter.com/cloudinary), [Facebook](https://www.facebook.com/Cloudinary).

## License

Cloudinary is released under the MIT license. See LICENSE for details.
