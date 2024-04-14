5.0.0 / 2024-04-14
==================

Breaking Changes
----------------
* Remove CLDURLCache in favor of native URLCache
* Remove ImageCache
* Old cache saved to the disk will be purged

New functionality
-----------------
* Add URLCache support for `CLDUIImageVIew`


4.7.0 / 2024-03-25
==================

Other Changes
-------------
  * Fix privacy manifest
  * Fix `CLDVideoPlayer`


4.6.0 / 2024-03-12
==================

New functionality
-----------------
* Add support for `media_metadata`

Other Changes
-------------
* Fix video analytics

4.5.0 / 2024-02-18
==================

Other Changes
-------------
  * Add privacy manifest

4.4.0 / 2024-01-15
==================

Other Changes
-------------
  * Update analytics token

4.3.0 / 2023-12-25
==================

Other Changes
-------------
  * Add video player analytics

4.2.0 / 2023-10-12
==================

Other Changes
-------------
  * Update analytics token

4.1.1 / 2023-09-18
==================

Other Changes
-------------
  * Fix analytics import


4.1.0 / 2023-08-06
==================

New functionality
-----------------
  * Add video player widget

4.0.1 / 2023-06-12
==================

Other changes
-------------
  * Fix analytics token prefix

4.0.0 / 2023-05-22
==================

New functionality
-----------------
  * Turn on `CLDURLCache` on by default
  
Other changes
-------------
  * Make upload request respect timeout

3.4.0 / 2023-03-12
==================

New functionality
-----------------
  * Add URLCache support for images
  * Add tests for explicit and rename
  
Other changes
-------------
  * Fix warning using `URLCredentialStorage`

3.3.0 / 2022-06-12
==================

New functionality
-----------------
  * Add support for folder decoupling
  * Add support for `startOffset` and `endOffset` as expression
  * Allow to disable b-frames
  * Send tags as an array
  * Add support for `originalFilename` upload parameter

Other changes
-------------
  * Fix expression normalisation

3.2.1 / 2022-01-11
==================
  * Fix `Carthage`

3.2.0 / 2022-01-10
==================

New functionality
-----------------
  * Add support for `apiKey` argument in Upload API
  * Add support for `preview` effect
  
Other changes
-------------
  * Update travis job to support multiple iOS versions
  * Add test for preview effect with duration parameter
  * Recover `Cloudinary.xcodeproj` file
  * Fix `ImageView` size in preview widget `CollectionView`
  * Improve network error handling
  * Add `PNG` image upload unit tests

3.1.0 / 2021-12-03
==================

New functionality
-----------------
* Add support for `backgroundRemoval` upload parameter

Other changes
-------------
  * Fix `Carthage`

3.0.3 / 2021-11-14
==================

  * Fix error handling in `fetchImage`

3.0.2 / 2021-11-02
==================

  * Improve error handling in `fetchImage`

3.0.1 / 2021-08-31
=============

  * Fix deprecation warnings

3.0.0 / 2021-04-26
=============

Breaking changes
-----------------
  * Bump minimum iOS target version to 9.0 (#334)

New functionality
-----------------
  * Add new url cache system (#331)
  * Add operationQueue names (#333)
  * Add support for video assets in upload widget (#322)

Other changes
-------------
  * Fix image assets for tests in multiple OS versions (#329)
  * Add missing imports for SPM (#326)

2.10.1 / 2021-01-20
==================

  * Re-add `Cloudinary.xscheme` to fix carthage support (#324)

2.10.0 / 2021-01-10
==================

New functionality
-----------------
* Add Upload Widget (#320)
* Add support for crop preprocess action (#263)
* Add support for rotation preprocess action (#264)
* Add support for enhanced quality analysis scores
* Add support for user defined variables and conditional expressions (#238)
* Support array of values for radius (#235)
* Add `eval` parameter to the upload Params.
* Add support for accessibility analysis (#260)
* Add option to control url signature algorithm (#256)
* Add support for custom pre-functions (#253)
* Add support for Long signature in URLs (#250)
* Add global timeout support(#251)
* Add OCR support un transformations and Upload APIs.

Other changes
-------------
* Add checks to validate responsive transformation.
* Fix space encoding in a generated URL (#274)
* Change local cache-keys encoding to `sha256`
* Fix OCR parameter usage in `UploadRequestParamsTests` (#262)
* Support urls with mime-type suffix in uploader.
* Update SPM definitions file (#234)

2.9.0 / 2020-04-16
==================
* Remove Alamofire dependency (#229)
* Add Swift Package Manager support.
* Add Carthage support.
* Rearrange workspace (#226)
* Add support for `assist_colorblind` effect. (#227)
* Validate URL scheme (#224)


2.9.0-beta.2 / 2020-04-05
=========================

  * Remove Alamofire dependency (#229)

2.9.0-beta.1 / 2020-03-23
=========================

  * Add Swift Package Manager support.
  * Add Carthage support.
  * Rearrange workspace (#226)
  * Add support for `assist_colorblind` effect. (#227)
  * Validate URL scheme (#224)

2.8.0 / 2019-11-11
==================

  * Add shared scheme (#220)
  * Add support for artistic filters. (#214)
  * Fix chunk upload to keep original file name. (#217)
  * Fix face coordinates test. (#215)

2.7.0 / 2019-04-07
==================

New functionality
-----------------
  * Support swift 5, fix related warnings.
  * Bump Alamofire version to 4.8.2
  * Add support for fetch layer in transformations. (#197)
  * Add support for `quality_analysis` parameter in upload. (#195)
  * Add support for font antialiasing and hinting in text overlays. (#193)
  * Add support for `streaming_profile` param in `CLDTransformation`. (#194)
  * Support excluding the default version from the generated cloudinary-url. (#206)
  * Add quality_override parameter to upload/explicit. (#199)
  
Other changes
-------------
  * Replace crypto kit files with `CommonCrypto` import.
  * Fix memory cache limit not getting initially set in `CLDImageCache` (#201)
  * Fix bas64 string validation in uploader. (#196)

2.6.1 / 2019-01-30
==================

  * Fix project setup and tests for swift 4.2 (#191)

2.6.0 / 2019-01-29
==================

New functionality
-----------------
  * Add support for google storage (`gs://`) urls in uploader. (#184)
  * Add support for `fps` parameter in Transformations. (#182)
  * Add format field to responsive breakpoints in upload params (#152)
  * Add `removeFromCache` to `CLDCloudinary`

Other changes
-------------
  * Bump Alamofire version to 4.8.1
  * Add device and os data to user agent. (#180)
  * Remove duplicate Alamofire reference
  
2.5.0 / 2018-11-05
==================

  * Migrate to Swift 4.2
  * Add support for custom transformation functions
  * Fix duplicate upload callbacks when using preprocessing
  * Bump Alamofire to version to 4.7.3
  * Add String extensions for base64 encoding
  * Add `@discardableResult` annotations for uploadLarge methods

2.4.0 / 2018-06-26
==================

New functionality
-----------------
  * Add support for `async` upload parameter
  * Add support for eager transformation format
  * Add support for automatic quality in transformations. (#150)
  * Add cache max-memory config (#98)
  * Add Keyframe interval transformation parameter (#90)

Other changes
-------------
  * Refactor CLDBaseParam for compatibility with iOS 11.4
  * Remove wrong project config (library search paths)
  * Bump Alamofire version to 4.7.2
  * Fix Alamofire submodule definition
  * Fix signature parameter handling in Management Api. (#161)
  * Fix `faceCenter` and `facesCenter` values in `CLDGravity` (#159)
  * Fix calculation of UIImage memory cache cost

2.3.0 / 2018-03-16
==================

  * Add access control parameter to upload (#142)

2.2.2 / 2018-03-05
==================

  * Add baseline Objective-C test.
  * Use `@objcMembers` where applies, for improved Objective-C compatibility.

2.2.1 / 2018-02-14
==================

   * Fix objective-c compatibility issues with `CLDResponsiveParams` properties.

2.2.0 / 2018-02-01
==================

New functionality
-----------------

  * Add support for responsive image download
  * Add `auto` to `CLDGravity`
    
Other changes
-------------

  * Fix synchronization issue when using `cldSetImage()` on `UIViews` within view collections.

2.1.0 / 2018-01-04
==================

New functionality
-----------------

  * Add image preprocessing and validations
    * Resizing
    * Format and quality settings
    * Support for custom preprocessors and validators
    
Other changes
-------------

  * Remove custom operators
  * Update Alamofire to version 4.6.0

2.0.4 / 2017-12-20
==================

* Fix user-agent sdk version
* Replace CommonCrypto wrapper with CryptoKit based code
* Remove autotagging test (behaviour change)
* Support Swift 4

2.0.3 / 2017-11-23
==================

New functionality
-----------------
  * Add support for chunked upload

Other changes
-------------

  * Update Readme to point to HTTPS URLs of cloudinary.com
  * Fix manual installation repository url.

2.0.2 / 2017-06-08
==================

New functionality
-----------------

  * Support SEO suffix for private images.

Other changes
-------------

  * Escape `|` and `=` characters in context values.
  * Double encode commas and slashes instead of using special UTF-8 values
  * Generate CLDCrypto framework in every build. Fixes #80.
  * Removing extra CLDCrypto path from podspec
  * Update `README.md` Alamo version to 4.1.0
  * Add 3 images in PhotoViewController to demonstrate transformations.
  * Add progress indicator
  * Updated the framework and project deployment target to 8.0, updated podspec deployment target to 8.0
  * Fixed signed upload using CLDSignature - Added unit test to test a signed upload using CLDSignature

2.0.1 / 2017-01-24
==================

  * Fix pod install issue. Fixes #57.
  * Fix shellScript
  * Fix URLs in tests
  * Increment Alamofire to ~>4.1. Fixes #59.
  * Update configuration

2.0.1 / 2017-01-22
==================

  * Fix Framework path in podspec/xcconfig

2.0.0 / 2017-01-18
==================

  * New Swift 3.0 code
