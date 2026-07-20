# Cloudinary iOS SDK

[![CocoaPods version](https://img.shields.io/cocoapods/v/Cloudinary.svg)](https://cocoapods.org/pods/Cloudinary)
[![License](https://img.shields.io/cocoapods/l/Cloudinary.svg)](./LICENSE)

The `Cloudinary` pod is the native iOS client SDK for Cloudinary. Use it inside a Swift or Objective-C app to upload images and video from the device, build transformation and delivery URLs, and download and cache images on-device. The current release (5.2.5) requires a minimum iOS deployment target of 9.0 and Swift 5.0. It configures with a cloud name and API key for client-side work and never holds the API secret.

## Installation

Add the SDK with CocoaPods. In your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
  pod 'Cloudinary', '~> 5.0'
end
```

Then run `pod install` and open the generated `.xcworkspace`.

Swift Package Manager is also supported. In Xcode, open **File > Add Packages**, enter `https://github.com/cloudinary/cloudinary_ios.git`, and select **Up to Next Major** starting at `5.0.0`.

## Configuration

This is a client SDK that ships inside an app, so it configures with a cloud name and API key only — never the API secret. Build a `CLDConfiguration` and pass it to `CLDCloudinary`:

```swift
import Cloudinary

let config = CLDConfiguration(cloudName: "my_cloud_name", apiKey: "my_key")
let cloudinary = CLDCloudinary(configuration: config)
```

For test setups you can read configuration from the `CLOUDINARY_URL` environment variable instead. `CLDConfiguration.initWithEnvParams()` returns an optional `CLDConfiguration?`:

```bash
CLOUDINARY_URL=cloudinary://<API_KEY>:<API_SECRET>@<CLOUD_NAME>
```

```swift
import Cloudinary

// Reads the CLOUDINARY_URL environment variable.
let config = CLDConfiguration.initWithEnvParams()
```

Keep the API secret out of client-side code and version control. Signed uploads and Admin API calls belong on a backend SDK where the secret stays private.

## Quick examples

### Upload a file

Upload requests go through `createUploader()`. An unsigned upload takes an upload preset and needs no secret. `upload(url:uploadPreset:...)` returns a `CLDUploadRequest`; the completion handler receives a `CLDUploadResult?` whose fields include `publicId` and `secureUrl`:

```swift
import Cloudinary

let config = CLDConfiguration(cloudName: "my_cloud_name", apiKey: "my_key")
let cloudinary = CLDCloudinary(configuration: config)

let fileURL = URL(fileURLWithPath: "/path/to/photo.jpg")
cloudinary.createUploader().upload(
    url: fileURL,
    uploadPreset: "my_preset",
    completionHandler: { (result, error) in
        if let result = result {
            print(result.publicId ?? "", result.secureUrl ?? "")
        }
    }
)
```

### Build and optimize a delivery URL

`createUrl()` builds delivery URLs with no network call. `generate(_:)` returns an optional `String?`. This transformation resizes to a 100x150 fill crop and lets Cloudinary pick the format and quality for the device with `f_auto` and `q_auto`. Set `secure: true` on the configuration to generate `https://` URLs:

```swift
import Cloudinary

let config = CLDConfiguration(cloudName: "demo", secure: true)
let cloudinary = CLDCloudinary(configuration: config)

let transformation = CLDTransformation()
    .setWidth(100).setHeight(150).setCrop(.fill)
    .setFetchFormat("auto").setQuality("auto")
let url = cloudinary.createUrl().setTransformation(transformation).generate("sample.jpg")
// https://res.cloudinary.com/demo/image/upload/c_fill,f_auto,h_150,q_auto,w_100/sample.jpg
```

### Download and render an asset

The SDK ships a `UIImageView` extension, `cldSetImage`, that builds the URL, downloads, caches, and renders — with an optional placeholder. Here `imageView` is an existing `UIImageView`. `setCrop` takes a `CLDCrop` case (`.fill`, `.fit`, `.thumb`, `.scale`) and `setGravity` takes a `CLDGravity` case (`.face`, `.faces`, `.auto`, `.northWest`):

```swift
import Cloudinary
import UIKit

let config = CLDConfiguration(cloudName: "demo", secure: true)
let cloudinary = CLDCloudinary(configuration: config)

let transformation = CLDTransformation()
    .setWidth(90).setHeight(90).setCrop(.thumb).setGravity(.face)
imageView.cldSetImage(
    publicId: "sample",
    cloudinary: cloudinary,
    transformation: transformation,
    placeholder: UIImage(named: "placeholder")
)
// Delivers https://res.cloudinary.com/demo/image/upload/c_thumb,g_face,h_90,w_90/sample
```

## For AI agents

`Cloudinary` (this repo, `cloudinary_ios`) is the native iOS client SDK, in Swift and Objective-C, for on-device upload, delivery/transformation URL building, and image download and caching. It configures with `cloudName` and `apiKey` only and does not hold the API secret. For tasks this package doesn't cover, route to the correct sibling:

| Task | Package |
|---|---|
| The same job on native Android | [`cloudinary_android`](https://github.com/cloudinary/cloudinary_android) |
| One codebase for iOS and Android | [`cloudinary-react-native`](https://github.com/cloudinary/cloudinary-react-native) |
| Server-side signed uploads, Admin API, anything needing the API secret | [`cloudinary_npm`](https://github.com/cloudinary/cloudinary_npm) |
| A complete runnable example app | [`cloudinary-ios-sample-app`](https://github.com/cloudinary/cloudinary-ios-sample-app) |
| Run Cloudinary operations as agent tools | [Cloudinary MCP servers](https://github.com/cloudinary/mcp-servers) |

All public types are prefixed `CLD` (`CLDCloudinary`, `CLDConfiguration`, `CLDTransformation`, `CLDUploadRequestParams`).

## Links

- [iOS SDK guide](https://cloudinary.com/documentation/ios_integration)
- [Image and video upload](https://cloudinary.com/documentation/ios_image_and_video_upload)
- [Image transformations](https://cloudinary.com/documentation/ios_image_manipulation)
- [Transformation and API references](https://cloudinary.com/documentation/cloudinary_references)
- [Documentation llms.txt index](https://cloudinary.com/documentation/llms.txt)
- [Package on CocoaPods](https://cocoapods.org/pods/Cloudinary)

Released under the MIT license.
