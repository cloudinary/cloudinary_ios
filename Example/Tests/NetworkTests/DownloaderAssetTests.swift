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
    
    var sut: CLDDownloader!
    
    override func setUp() {
        super.setUp()
        
        sut = cloudinary!.createDownloader()
    }
    
    override func tearDown() {
        
        sut.downloadCoordinator.urlCache.removeAllCachedResponses()
        sut = nil
        super.tearDown()
    }
    
    static var skipableTests = [
        ("test_downloadAsset_pdfImage_shouldDownloadAndCacheAsset", test_downloadAsset_pdfImage_shouldDownloadAndCacheAsset),
    ]
        
    override func shouldSkipTest() -> Bool {
        
        if super.shouldSkipTest() {
            return true
        }
        if ProcessInfo.processInfo.arguments.contains("TEST_PDF") {
            return false
        }
        if let privateName = testRun?.test.name {
            if !DownloaderAssetTests.skipableTests.filter({
                return privateName.contains($0.0)
            }).isEmpty {
                return true
            }
        }
        return false
    }
    
    // MARK - cache asset
    func test_downloadAsset_video_shouldDownloadAndCacheAsset() {
        assetCacheTest(shouldCache: true, testResource: .dog2, resourceType: .video)
    }
    func test_downloadAsset_pdfImage_shouldDownloadAndCacheAsset() {
        assetCacheTest(shouldCache: true, testResource: .pdf, resourceType: .image)
    }
    func test_downloadAsset_pdfRaw_shouldDownloadAndCacheAsset() {
        assetCacheTest(shouldCache: true, testResource: .pdf, resourceType: .raw)
    }
    func test_downloadAsset_docx_shouldDownloadAndCacheAsset() {
        assetCacheTest(shouldCache: true, testResource: .docx, resourceType: .raw)
    }
    
    // MARK - download without cache
    func test_downloadAsset_image_shouldDownloadWithoutCaching() {
        // images are excluded from asset cache use "fetchImage" instead of "fetchAsset".
        assetCacheTest(shouldCache: false,testResource: .borderCollie, resourceType: .image)
    }
    func test_downloadAsset_video_shouldDownloadWithoutCaching() {
        assetCacheTest(shouldCache: false, testResource: .dog2, resourceType: .video)
    }
}

extension DownloaderAssetTests {
    
    func assetCacheTest(shouldCache: Bool, testResource: TestResourceType, resourceType: CLDUrlResourceType) {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        if !shouldCache {
            cloudinary!.cacheAssetMaxMemoryTotalCost = 20
            cloudinary!.cacheAssetMaxDiskCapacity    = 20
        }
        
        // Given
        let resource: TestResourceType = testResource
        var publicId: String?
        var expectation = self.expectation(description: "Upload should succeed")
        
        let params = CLDUploadRequestParams()
        params.setResourceType(resourceType)
        
        // When
        uploadFile(resource, params: params).response({ (result, error) in
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: longTimeout, handler: nil)
        
        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }
        
        expectation = self.expectation(description: "Download should succeed")
        
        var response: Data?
        
        /// download asset by publicId
        let url = cloudinary!.createUrl().setResourceType(resourceType).generate(pubId)
        sut.fetchAsset(url!).responseAsset { (responseData, err) in
            response = responseData
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertEqual(response, resource.data, "uploaded data should be equal to downloaded data")
        
        if shouldCache {
            XCTAssertNotNil(try sut.downloadCoordinator.urlCache.warehouse.entry(forKey: url!), "response should be cached")
        }
        else {
            XCTAssertThrowsError(try sut.downloadCoordinator.urlCache.warehouse.entry(forKey: url!), "response should not be cached")
        }
    }
}
