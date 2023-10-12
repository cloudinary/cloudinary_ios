Cloudinary iOS SDK
=========================
[![Build Status](https://api.travis-ci.com/cloudinary/cloudinary_ios.svg?branch=master)](https://app.travis-ci.com/github/cloudinary/cloudinary_ios)
## About
The Cloudinary iOS SDK allows you to quickly and easily integrate your application with Cloudinary.
Effortlessly optimize and transform your cloud's assets.

### Additional documentation
This Readme provides basic installation and usage information.
For the complete documentation, see the [iOS SDK Guide](https://cloudinary.com/documentation/ios_integration).

## Table of Contents
- [Key Features](#key-features)
- [Version Support](#Version-Support)
- [Installation](#installation)
- [Usage](#usage)
    - [Setup](#Setup)
    - [Transform and Optimize Assets](#Transform-and-Optimize-Assets)
    - [File Upload](#File-Upload)
    - [File Download](#File-Download)

## Key Features
- [Transform](https://cloudinary.com/documentation/ios_video_manipulation#video_transformation_examples) and [optimize](https://cloudinary.com/documentation/ios_image_manipulation#image_optimizations) assets.

## Version Support
| SDK Version    | iOS 9+    |   iOS 8   |
|----------------|-----------|-----------|
| 2.0.0 - 2.10.1 | V         | V         |
| 3.0.0 - 4.2.0  | V         | X         |

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. 
To install CocoaPods:

```bash
sudo gem install cocoapods
```
If you don't have a `Podfile` in your project yet, add it by running the command:
```bash
pod init
```

Add the Cloudinary SDK to your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
  pod 'Cloudinary', '~> 4.0'
end
```

Then, run the command:

```bash
pod install
```

### Carthage

Create `Cartfile`
```bash
touch Cartfile
```

Open `Cartfile` and enter the following line

```bash
github "cloudinary/cloudinary_ios" ~> 4.0
```

Then, run the command:

```bash
carthage update --use-xcframeworks
```
A `Cartfile.resolved` file and a `Carthage` directory will appear in the same directory where your `.xcodeproj` or `.xcworkspace` is.
Drag the built `.xcframework` bundles from `Carthage/Build` into the `Frameworks and Libraries` section of your application’s Xcode project.

### Swift Package Manager
* File > Add Packages... >
* Add https://github.com/cloudinary/cloudinary_ios.git
* Select "Up to Next Major" with "4.0.0"

### Working with the Cloudinary iOS SDK Manually

If you prefer not use a dependency manager, you can add Cloudinary manually by adding it as a submodule to your project:

Open Terminal and navigate to your project's top level directory.

If your project is not initialized as a git repository, run the command:

```bash
git init
```

To add cloudinary as a git submodule, run the command:

```bash
git submodule add https://github.com/cloudinary/cloudinary_ios.git
```

#### Embedded Framework

1. Drag `Cloudinary.xcodeproj` into the Project Navigator of your application's Xcode project. It should appear under your application's blue project icon.
2. Select `Cloudinary.xcodeproj` and make sure the deployment target matches that of your application target.
3. Select your application project. Under 'TARGETS' select your application, open the 'General' tab, click on the `+` button under the 'Embedded Binaries' and Select 'Cloudinary.framework'.

## Usage 
### Setup
To use the API, you will need a CLDCloudinary instance, which is initialized with an instance of CLDConfiguration.

The CLDConfiguration must have its `cloudName` and `apiKey` properties set. Other properties are optional. 

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

### Transform and Optimize Assets
The following example generates a URL on an uploaded `sample` image:
```swift
cloudinary.createUrl().generate("sample.jpg")

// http://res.cloudinary.com/CLOUD_NAME/image/upload/sample.jpg
```

The following example generates an image URL of an uploaded `sample` image while transforming it to fill a 100x150 rectangle:

```swift
let transformation = CLDTransformation().setWidth(100).setHeight(150).setCrop(.crop)
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

### File Upload

##### 1. Signed upload

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

##### 2. Unsigned uploads using [Upload Presets.](https://cloudinary.com/documentation/ios_image_and_video_upload#unsigned_upload)
You can create an upload preset in your Cloudinary account console, defining rules that limit the formats, transformations, dimensions and more.
Once the preset is defined, it's name is supplied when calling upload. An upload call will only succeed if the preset name is used and the resource is within the preset's pre-defined limits.

The following example uploads a local resource, assuming a preset named 'sample_preset' already exists in the account:
```swift
let request = cloudinary.createUploader().upload(url: file, uploadPreset: "sample_preset", params: CLDUploadRequestParams()).response({
    (response, error) in
    // Handle response
})
```

Every upload request returns a CLDUploadRequest instance, allowing options such as cancelling, suspending or resuming it.

### File Download

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

Every download request returns an instance implementing CLDNetworkDataRequest, allowing options such as cancelling, suspending or resuming it.

The downloaded image is cached both to the memory and the disk (customizable). The disk cache size is limited and can be changed.

## Contributions
See [contributing guidelines](/CONTRIBUTING.md).

## Get Help
If you run into an issue or have a question, you can either:
- [Open a Github issue](https://github.com/cloudinary/cloudinary_ios/issues) (for issues related to the SDK)
- [Open a support ticket](https://cloudinary.com/contact) (for issues related to your account)

## About Cloudinary
Cloudinary is a powerful media API for websites and mobile apps alike, Cloudinary enables developers to efficiently manage, transform, optimize, and deliver images and videos through multiple CDNs. Ultimately, viewers enjoy responsive and personalized visual-media experiences—irrespective of the viewing device.

## Additional Resources
- [Cloudinary Transformation and REST API References](https://cloudinary.com/documentation/cloudinary_references): Comprehensive references, including syntax and examples for all SDKs.
- [MediaJams.dev](https://mediajams.dev/): Bite-size use-case tutorials written by and for Cloudinary Developers
- [DevJams](https://www.youtube.com/playlist?list=PL8dVGjLA2oMr09amgERARsZyrOz_sPvqw): Cloudinary developer podcasts on YouTube.
- [Cloudinary Academy](https://training.cloudinary.com/): Free self-paced courses, instructor-led virtual courses, and on-site courses.
- [Code Explorers and Feature Demos](https://cloudinary.com/documentation/code_explorers_demos_index): A one-stop shop for all code explorers, Postman collections, and feature demos found in the docs.
- [Cloudinary Roadmap](https://cloudinary.com/roadmap): Your chance to follow, vote, or suggest what Cloudinary should develop next.
- [Cloudinary Facebook Community](https://www.facebook.com/groups/CloudinaryCommunity): Learn from and offer help to other Cloudinary developers.
- [Cloudinary Account Registration](https://cloudinary.com/users/register/free): Free Cloudinary account registration.
- [Cloudinary Website](https://cloudinary.com)

## Licence
Released under the MIT license.
