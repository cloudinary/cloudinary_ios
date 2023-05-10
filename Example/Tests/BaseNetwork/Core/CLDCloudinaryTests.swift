//
//  CLDCloudinaryTests.swift
//
//  Copyright (c) 2021 Cloudinary (http://cloudinary.com)
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

@testable import Cloudinary
import Foundation
import XCTest

class CLDCloudinaryTests: XCTestCase {

    var sut   : CLDCloudinary!
    var config: CLDConfiguration!
    
    override func setUp() {
        super.setUp()
        
        config = CLDConfiguration(cloudinaryUrl: "cloudinary://a:b@test123")!
        sut    = CLDCloudinary(configuration: config, sessionConfiguration: .default)
    }
    
    override func tearDownWithError() throws {
        sut    = nil
        config = nil
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_config_shouldStoreProperties() {
        
        // Given
        let cloudinaryUrl     = "cloudinary://a:b@test123"
        let tempConfiguration = CLDConfiguration(cloudinaryUrl: cloudinaryUrl)!
        
        // When
        let tempSut           = CLDCloudinary(configuration: tempConfiguration)

        // Then
        XCTAssertNotNil(tempSut, "initialized object should not be nil")
        XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value")
    }
    
    func test_init_configSession_shouldStoreProperties() {
        
        // Given
        let cloudinaryUrl     = "cloudinary://a:b@test123"
        let tempConfiguration = CLDConfiguration(cloudinaryUrl: cloudinaryUrl)!

        // When
        let tempSut           = CLDCloudinary(configuration: tempConfiguration, sessionConfiguration: .default)

        // Then
        XCTAssertNotNil(tempSut, "initialized object should not be nil")
        XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value")
    }
    func test_init_configDownloadSession_shouldStoreProperties() {
        
        // Given
        let cloudinaryUrl     = "cloudinary://a:b@test123"
        let tempConfiguration = CLDConfiguration(cloudinaryUrl: cloudinaryUrl)!

        // When
        let tempSut           = CLDCloudinary(configuration: tempConfiguration, sessionConfiguration: .default, downloadSessionConfiguration: .default)

        // Then
        XCTAssertNotNil(tempSut, "initialized object should not be nil")
        XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value")
    }
    func test_init_configDownloadSessionAdapter_shouldStoreProperties() {
        
        // Given
        let adapter           = CLDDefaultNetworkAdapter()
        let cloudinaryUrl     = "cloudinary://a:b@test123"
        let tempConfiguration = CLDConfiguration(cloudinaryUrl: cloudinaryUrl)!

        // When
        let tempSut           = CLDCloudinary(configuration: tempConfiguration, networkAdapter: adapter, downloadAdapter: nil, sessionConfiguration: .default, downloadSessionConfiguration: .default)

        // Then
        XCTAssertNotNil(tempSut, "initialized object should not be nil")
        XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value")
    }
    func test_init_configDownloadSessionDownloadAdapter_shouldStoreProperties() {
        
        // Given
        let adapter           = CLDDefaultNetworkAdapter()
        let cloudinaryUrl     = "cloudinary://a:b@test123"
        let tempConfiguration = CLDConfiguration(cloudinaryUrl: cloudinaryUrl)!

        // When
        let tempSut           = CLDCloudinary(configuration: tempConfiguration, networkAdapter: adapter, downloadAdapter: adapter, sessionConfiguration: .default, downloadSessionConfiguration: .default)

        // Then
        XCTAssertNotNil(tempSut, "initialized object should not be nil")
        XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value")
    }
    func test_init_configSessionAdapter_shouldStoreProperties() {
        
        // Given
        let adapter           = CLDDefaultNetworkAdapter()
        let cloudinaryUrl     = "cloudinary://a:b@test123"
        let tempConfiguration = CLDConfiguration(cloudinaryUrl: cloudinaryUrl)!

        // When
        let tempSut           = CLDCloudinary(configuration: tempConfiguration, networkAdapter: adapter, sessionConfiguration: .default)
        
        // Then
        XCTAssertNotNil(tempSut, "initialized object should not be nil")
        XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value")
    }
    
    // MARK: - default values
    func test_init_defaultVaues_shouldBeEqualToExpectedValues() {
        
        // Given
        let defaultCachePolicy            : CLDImageCachePolicy = .none
        let defaultUrlCachePolicy         : Bool = true
        let defaultCacheMaxDiskCapacity   : UInt64              = 150 * 1024 * 1024
        let defaultCacheMaxMemoryTotalCost: Int                 = 30 * 1024 * 1024
        
        // Then
        XCTAssertNotNil(sut, "initialized object should not be nil")
        XCTAssertEqual (sut.config, config, "Initilized object should contain expected value")
        XCTAssertEqual (sut.cachePolicy, defaultCachePolicy, "Initilized object should contain expected value")
        XCTAssertEqual(sut.enableUrlCache, defaultUrlCachePolicy)
        XCTAssertEqual (sut.cacheMaxDiskCapacity, defaultCacheMaxDiskCapacity, "Initilized object should contain expected value")
        XCTAssertEqual (sut.cacheMaxMemoryTotalCost, defaultCacheMaxMemoryTotalCost, "Initilized object should contain expected value")
    }
}
