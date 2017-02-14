Pod::Spec.new do |s|
  s.name         = "Cloudinary"
  s.version      = "2.0.1"
  s.summary      = "Cloudinary is a cloud service that offers a solution to a web application's entire image management pipeline."
  s.description  = <<-DESC
    Easily upload images to the cloud. Automatically perform smart image resizing, cropping and conversion without installing any complex software.
    Integrate Facebook or Twitter profile image extraction in a snap, in any dimension and style to match your website’s graphics requirements.
    Images are seamlessly delivered through a fast CDN, and much much more.
    Cloudinary offers comprehensive APIs and administration capabilities and is easy to integrate with any web application, existing or new.
    Cloudinary provides URL and HTTP based APIs that can be easily integrated with any Web development framework.
  DESC
  s.homepage     = "http://cloudinary.com"
  s.license      = "MIT"
  s.author       = { "Cloudinary" => "info@cloudinary.com" }
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/cloudinary/cloudinary_ios.git", :tag => s.version.to_s }

  s.dependency 'Alamofire', '~> 4.1'

  #
  # Create the dummy CLDCrypto.framework structures
  #
  s.prepare_command = <<-CMD
      swift ./CLDCrypto/GenerateCLDCryptoModule.swift iphonesimulator .
      swift ./CLDCrypto/GenerateCLDCryptoModule.swift iphoneos .
  CMD

  s.framework = "UIKit", "Foundation"
  s.source_files = "Cloudinary/**/*.swift"
  s.exclude_files = "Cloudinary/Frameworks/Alamofire/**/*"
  s.preserve_paths = "Cloudinary/Frameworks/CLDCrypto"
  s.xcconfig ={
    "SWIFT_INCLUDE_PATHS"         => "$(PODS_ROOT)/Cloudinary/Cloudinary/Frameworks/CLDCrypto/$(PLATFORM_NAME) #{File.dirname(__FILE__)}/Cloudinary/Frameworks/CLDCrypto/$(PLATFORM_NAME)",
    "FRAMEWORK_SEARCH_PATHS"      => "$(PODS_ROOT)/Cloudinary/Cloudinary/Frameworks/CLDCrypto/$(PLATFORM_NAME) #{File.dirname(__FILE__)}/Cloudinary/Frameworks/CLDCrypto/$(PLATFORM_NAME)"
  }
#  s.xcconfig = {
#    "SWIFT_INCLUDE_PATHS"         => "#{File.dirname(__FILE__)}/Cloudinary/Frameworks/CLDCrypto/$(PLATFORM_NAME)",
#    "FRAMEWORK_SEARCH_PATHS"      => "#{File.dirname(__FILE__)}/Cloudinary/Frameworks/CLDCrypto/$(PLATFORM_NAME)"
#  }
#  s.xcconfig = {
#    "SWIFT_INCLUDE_PATHS"         => "${PODS_ROOT}/Cloudinary/Frameworks/$(PLATFORM_NAME)",
#    "FRAMEWORK_SEARCH_PATHS"      => "${PODS_ROOT}/Cloudinary/Frameworks/$(PLATFORM_NAME)"
#  }

end
