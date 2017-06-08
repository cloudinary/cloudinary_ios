
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
