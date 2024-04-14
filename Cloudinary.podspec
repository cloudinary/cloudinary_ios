#
# Be sure to run `pod lib lint Cloudinary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'Cloudinary'
    s.version          = '5.0.0'
    s.summary          = "Cloudinary is a cloud service that offers a solution to a web application's entire image management pipeline."
    
    s.description      = <<-DESC
    Easily upload images to the cloud. Automatically perform smart image resizing, cropping and conversion without installing any complex software.
    Integrate Facebook or Twitter profile image extraction in a snap, in any dimension and style to match your website’s graphics requirements.
    Images are seamlessly delivered through a fast CDN, and much much more.
    Cloudinary offers comprehensive APIs and administration capabilities and is easy to integrate with any web application, existing or new.
    Cloudinary provides URL and HTTP based APIs that can be easily integrated with any Web development framework.
    DESC
    
    s.homepage         = 'http://cloudinary.com'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { "Cloudinary" => "info@cloudinary.com" }
    s.source           = { :git => "https://github.com/cloudinary/cloudinary_ios.git", :tag => s.version.to_s }
    
    s.swift_version         = '5.0'
    s.ios.deployment_target = '9.0'
    s.frameworks            = 'UIKit', 'Foundation'
    
    s.default_subspec  = 'ios'
    
    s.subspec 'ios' do |spec|
        
        spec.platform              = :ios
        spec.source_files          = 'Cloudinary/Classes/**/*.{swift,h}'
        spec.resource_bundles      = { 'Cloudinary' => ['Cloudinary/Classes/Core/Network/PrivacyInfo.xcprivacy'] }

    end
end
