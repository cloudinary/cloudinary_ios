//
//  NetworkBaseTest.swift
//
//  Copyright (c) 2016 Cloudinary (http://cloudinary.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import XCTest
import Cloudinary
import AVKit

class NetworkBaseTest: BaseTestCase {
    
    let longTimeout: TimeInterval = 60.0
    
    var cloudinary: CLDCloudinary?
    var cloudinaryInsufficientTimeout: CLDCloudinary?
    var cloudinarySufficientTimeout: CLDCloudinary?
    var cloudinaryNoSecret: CLDCloudinary!
    var cloudinarySecured:CLDCloudinary!
    
    // MARK: - Lifcycle
    
    override func setUp() {
        super.setUp()
        let config: CLDConfiguration

        if let url = Bundle(for: type(of: self)).infoDictionary?["cldCloudinaryUrl"] as? String, url.count > 0 {
            config = CLDConfiguration(cloudinaryUrl: url)!
        } else {
            config = CLDConfiguration.initWithEnvParams() ?? CLDConfiguration(cloudinaryUrl: "cloudinary://a:b@test123?analytics=false")!
            config.analytics = false
        }
        
        let configInsufficientTimeout = CLDConfiguration (cloudName: config.cloudName, apiKey: config.apiKey, apiSecret: config.apiSecret, privateCdn: config.privateCdn, secure: config.secure, cdnSubdomain: config.cdnSubdomain, secureCdnSubdomain: config.secureCdnSubdomain, secureDistribution: config.secureDistribution, cname: config.cname, uploadPrefix: config.uploadPrefix, timeout: 0.01)
        
        let configSufficientTimeout = CLDConfiguration (cloudName: config.cloudName, apiKey: config.apiKey, apiSecret: config.apiSecret, privateCdn: config.privateCdn, secure: config.secure, cdnSubdomain: config.cdnSubdomain, secureCdnSubdomain: config.secureCdnSubdomain, secureDistribution: config.secureDistribution, cname: config.cname, uploadPrefix: config.uploadPrefix, timeout: 30000, analytics: false)
        
        let configNoSecret = CLDConfiguration (cloudName: config.cloudName, apiKey: config.apiKey, apiSecret: nil, privateCdn: config.privateCdn, secure: config.secure, cdnSubdomain: config.cdnSubdomain, secureCdnSubdomain: config.secureCdnSubdomain, secureDistribution: config.secureDistribution, cname: config.cname, uploadPrefix: config.uploadPrefix)

        let configSecured = CLDConfiguration (cloudName: config.cloudName, apiKey: config.apiKey, apiSecret: config.apiSecret, privateCdn: config.privateCdn, secure: true, cdnSubdomain: config.cdnSubdomain, secureCdnSubdomain: config.secureCdnSubdomain, secureDistribution: config.secureDistribution, cname: config.cname, uploadPrefix: config.uploadPrefix)
        
        cloudinary = CLDCloudinary(configuration: config, sessionConfiguration: .default)
        
        cloudinaryInsufficientTimeout = CLDCloudinary(configuration: configInsufficientTimeout, sessionConfiguration: .default)
        cloudinarySufficientTimeout = CLDCloudinary(configuration: configSufficientTimeout, sessionConfiguration: .default)

        cloudinaryNoSecret = CLDCloudinary(configuration: configNoSecret, sessionConfiguration: .default)
        cloudinarySecured = CLDCloudinary(configuration: configSecured)
    }
    
    override func tearDown() {
        super.tearDown()
        cloudinary = nil
        cloudinaryInsufficientTimeout = nil
        cloudinarySufficientTimeout = nil
        cloudinaryNoSecret = nil
        cloudinarySecured = nil
    }
    
    // MARK: - Resources
    
    enum TestResourceType {
        case logo
        case borderCollie
        case borderCollieCropped
        case borderCollieRotatedPng
        case borderCollieRotatedJpg
        case docx
        case dog
        case dog2
        case pdf
        case textImage

        var fileName: String {
            switch self {
        
            case .borderCollieRotatedPng:
                if #available(iOS 12.0, *) {
                    return "borderCollieRotatedPng"
                } else {
                    return "borderCollieRotatedPngUnderIOS12"
                }
                
            case .borderCollieRotatedJpg:
                if #available(iOS 12.0, *) {
                    return "borderCollieRotatedJpg"
                } else {
                    return "borderCollieRotatedJpgUnderIOS12"
                }
                
            default:
                return String(describing: self)
            }
        }
        
        var resourceExtension: String {
            
            switch self {
            case .logo                       : fallthrough
            case .borderCollieRotatedPng     :
                return "png"
                
            case .textImage                  : fallthrough
            case .borderCollie               : fallthrough
            case .borderCollieCropped        : fallthrough
            case .borderCollieRotatedJpg     :
                return "jpg"
                
            case .docx: return "docx"
                
            case .dog : fallthrough
            case .dog2:
                return "mp4"
            
            case .pdf : return "pdf"
            }
        }
        
        var url: URL {
            let bundle = Bundle(for: NetworkBaseTest.self)
            return bundle.url(forResource: fileName, withExtension: resourceExtension)!
        }
        
        var data: Data {
            let data = try! Data(contentsOf: url, options: .uncached)
            return data
        }
    }
    
    // MARK: - Helpers
    @discardableResult
    func uploadFile(_ resource: TestResourceType = .borderCollie, params: CLDUploadRequestParams? = nil) -> CLDUploadRequest {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        return cloudinary!.createUploader().signedUpload(data: resource.data, params: params)
    }
    
    func getImage(_ resource: TestResourceType) -> UIImage {
        if let image = UIImage(contentsOfFile: resource.url.path) {
            return image
        }
        else {
            return UIImage()
        }
    }
    
    func getVideo(_ resource: TestResourceType) -> AVPlayerItem {
        return AVPlayerItem(url: resource.url)
    }
    
    // MARK: - skip addons
    /**
     Override this variable to skip addons tests in order to prevent account related failures and to save addons quota.
     If set     - all tests in this class will be skipped, unless an environment variable "CLD_TEST_ADDONS" is set to the addon type OR set to "all". You can set multiple addons separated by comma.
     If unset - skips nothing.
     nil by default.
     */
    var testingAddonType: AddonType? { nil }
    
    let environmentAddonsKey = "CLD_TEST_ADDONS"
    
    override func shouldSkipTest() -> Bool {
        
        // only skip if testingAddonType is set
        if let testingAddonType  = testingAddonType {
            
            if let testableAddonsList = ProcessInfo.processInfo.environment[environmentAddonsKey] {
                
                let addonContainedInEnvironmentList = testableAddonsList.lowercased().contains(testingAddonType.rawValue)
                let environmentAddonListSetToAll    = testableAddonsList.lowercased() == AddonType.all.rawValue
                
                return !addonContainedInEnvironmentList && !environmentAddonListSetToAll
            }
            
            // environmentAddonsKey is not set but testingAddonType is set - we should skip this tests.
            return true
        }
        
        return false
    }
    
    enum AddonType: String {
        
        case all                       = "all"                       // test all addons
        case lightroom                 = "lightroom"                 // adobe photoshop lightroom (BETA)
        case facialAttributesDetection = "facialattributesdetection" // advanced facial attributes detection
        case rekognition               = "rekognition"               // amazon rekognition AI moderation, amazon rekognition auto tagging, amazon rekognition celebrity detection
        case aspose                    = "aspose"                    // aspose document conversion
        case bgRemoval                 = "bgremoval"                 // cloudinary AI background removal cloudinary AI background removal
        case objectAwareCropping       = "objectawarecropping"       // cloudinary object-aware cropping"
        case google                    = "google"                    // google AI video moderation, google AI video transcription, google auto tagging, google automatic video tagging, google translation
        case imagga                    = "imagga"                    // imagga auto tagging, imagga crop and scale
        case jpegmini                  = "jpegmini"                  // JPEGmini image optimization
        case metaDefender              = "metadefender"              // metaDefender anti-malware protection
        case azure                     = "azure"                     // microsoft azure video indexer
        case neuralArtwork             = "neuralartwork"             // neural artwork style transfer
        case ocr                       = "ocr"                       // OCR text detection and extraction
        case pixelz                    = "pixelz"                    // remove the background
        case url2png                   = "url2png"                   // website screenshots
        case viesus                    = "viesus"                    // automatic image enhancement
        case webpurify                 = "webpurify"                 // webPurify image moderation
    }
}
