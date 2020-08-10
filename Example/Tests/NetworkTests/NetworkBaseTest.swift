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

class NetworkBaseTest: XCTestCase {
    let timeout: TimeInterval = 30.0
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
            config = CLDConfiguration.initWithEnvParams() ?? CLDConfiguration(cloudinaryUrl: "cloudinary://a:b@test123")!
        }
        
        let configInsufficientTimeout = CLDConfiguration (cloudName: config.cloudName, apiKey: config.apiKey, apiSecret: config.apiSecret, privateCdn: config.privateCdn, secure: config.secure, cdnSubdomain: config.cdnSubdomain, secureCdnSubdomain: config.secureCdnSubdomain, secureDistribution: config.secureDistribution, cname: config.cname, uploadPrefix: config.uploadPrefix, timeout: 0.01)
        
        let configSufficientTimeout = CLDConfiguration (cloudName: config.cloudName, apiKey: config.apiKey, apiSecret: config.apiSecret, privateCdn: config.privateCdn, secure: config.secure, cdnSubdomain: config.cdnSubdomain, secureCdnSubdomain: config.secureCdnSubdomain, secureDistribution: config.secureDistribution, cname: config.cname, uploadPrefix: config.uploadPrefix, timeout: 30000)
        
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
        case docx
        case dog
        case pdf
        case textImage

        var fileName: String {
            return String(describing: self)
        }
        
        var resourceExtension: String {
            switch self {
            case .logo:
                return "png"
            case .borderCollie: fallthrough
            case .textImage   : fallthrough
            case .borderCollieCropped:
                return "jpg"
            case .docx:
                return "docx"
            case .dog:
                return "mp4"
            case .pdf:
                return "pdf"
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
}

