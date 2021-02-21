//
//  DownloaderAssetTests.swift
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

import XCTest
import Cloudinary
@testable import Cloudinary

// MARK: - assets
class DownloaderAssetTests: NetworkBaseTest {
    
    func test_downloadAsset_asset_shouldDownloadAssetAsData() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        // Given
        var expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        var publicId: String?
        
        // When
        /// upload file to get publicId
        cloudinary!.createUploader().signedUpload(data: resource.data, params: nil).response({ (result, error) in
            XCTAssertNil(error)
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }
        
        expectation = self.expectation(description: "test_downloadAsset_asset_shouldDownloadAssetAsData Download asset should succeed")
        
        var response: Data?
        /// download asset by publicId - first time, no cache yet
        let url = cloudinary!.createUrl().generate(pubId)
        cloudinary!.createDownloader().fetchAsset(url!).responseAsset { (responseData, err) in
            response = responseData
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertEqual(response,resource.data, "uploaded data should be equal to downloaded data")
    }
    func test_downloadAsset_pdf_shouldDownloadAssetAsData() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        // Given
        let resource: TestResourceType = .pdf
        var publicId: String?
        var expectation = self.expectation(description: "Upload should succeed")
        
        // When
        uploadFile(.pdf).response({ (result, error) in
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }
        
        expectation = self.expectation(description: "test_downloadAsset_pdf_shouldDownloadAssetAsData Download pdf should succeed")
        
        var response: Data?
        /// download asset by publicId
        let url = cloudinary!.createUrl().generate(pubId)
        cloudinary!.createDownloader().fetchAsset(url!).responseAsset { (responseData, err) in
            response = responseData
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertEqual(response, resource.data, "uploaded data should be equal to downloaded data")
    }
    func test_downloadAsset_video_shouldDownloadAssetAsData() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        // Given
        let resource: TestResourceType = .dog
        var publicId: String?
        var expectation = self.expectation(description: "Upload should succeed")
        
        let params = CLDUploadRequestParams()
        params.setResourceType(.video)
        
        // When
        uploadFile(.dog, params: params).response({ (result, error) in
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: longTimeout, handler: nil)
        
        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }
        
        expectation = self.expectation(description: "test_downloadAsset_video_shouldDownloadAssetAsData Download should succeed")
        
        var response: Data?
        
        /// download asset by publicId
        let url = cloudinary!.createUrl().setResourceType(.video).generate(pubId)
        
        cloudinary!.createDownloader().fetchAsset(url!).responseAsset { (responseData, err) in
            response = responseData
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertEqual(response, resource.data, "uploaded data should be equal to downloaded data")
    }
}

// MARK: - cache
extension DownloaderAssetTests {
    
    func test_downloadAsset_cache_shouldGetAssetFromCache() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        // When
        var expectation = self.expectation(description: "Upload should succeed")
        
        /// upload file to get publicId
        var publicId: String?
        uploadFile(.pdf).response({ (result, error) in
            XCTAssertNil(error)
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }
        
        expectation = self.expectation(description: "test_downloadAsset_cache_shouldGetAssetFromCache Download should succeed")
        
        var response: Data?
        /// download asset by publicId - first time, no cache yet
        let url = cloudinary!.createUrl().generate(pubId)
        let downloader = cloudinary!.createDownloader()
        downloader.fetchAsset(url!).responseAsset { (dataResponse, errResponse) in
            response = dataResponse
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(response, "response should be valid")
        XCTAssertNotNil(try downloader.downloadCoordinator.urlCache.warehouse.entry(forKey: url!), "response should be cached")
    }
    
    func test_downloadAsset_noCache_shouldGetAssetFromCache() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        cloudinary!.cacheAssetMaxMemoryTotalCost = 20
        cloudinary!.cacheAssetMaxDiskCapacity    = 20
        
        // When
        var expectation = self.expectation(description: "Upload should succeed")
        
        /// upload file to get publicId
        var publicId: String?
        uploadFile(.pdf).response({ (result, error) in
            XCTAssertNil(error)
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }
        
        expectation = self.expectation(description: "test_downloadAsset_noCache_shouldGetAssetFromCache Download should succeed")
        
        var response: Data?
        /// download asset by publicId - first time, no cache yet
        let url = cloudinary!.createUrl().generate(pubId)
        let downloader = cloudinary!.createDownloader()
        downloader.fetchAsset(url!).responseAsset { (dataResponse, errResponse) in
            response = dataResponse
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(response, "response should be valid")
        XCTAssertThrowsError(try downloader.downloadCoordinator.urlCache.warehouse.entry(forKey: url!), "response should not be cached due to low capacity, so when we try to get the cached object, error will be thrown")
    }
}
