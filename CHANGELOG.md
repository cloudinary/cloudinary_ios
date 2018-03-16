
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
