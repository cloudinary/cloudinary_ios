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
    var cloudinary: CLDCloudinary?
    
    // MARK: - Lifcycle
    
    override func setUp() {
        super.setUp()
        let config = CLDConfiguration.initWithEnvParams() ?? CLDConfiguration(cloudinaryUrl: "cloudinary://a:b@test123")!
        cloudinary = CLDCloudinary(configuration: config, sessionConfiguration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        super.tearDown()
        cloudinary = nil
    }
    
    // MARK: - Resources
    
    enum TestResourceType {
        case logo, borderCollie, docx, dog, pdf
        
        var fileName: String {
            return String(describing: self)
        }
        
        var resourceExtension: String {
            switch self {
            case .logo:
                return "png"
            case .borderCollie:
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

