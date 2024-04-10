//
//  DownloaderTests.swift
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

import XCTest
import Cloudinary
@testable import Cloudinary

class DownloaderTests: NetworkBaseTest {

    // MARK: - Tests
    func test_downloadImage_shouldReturnNetworkErrorCode() {
        var expectation = self.expectation(description: "Should get 404 error")
        var error: NSError?
        let firstMockUrl = "https://demo-res.cloudinary.com/image/upload/c_fill,dpr_3.0,f_heic,g_auto,h_100,q_auto,w_100/v1/some_invalid_url"
        let secondMockUrl = "https://httpbin.org/status/404"

        cloudinarySecured.createDownloader().fetchImage(firstMockUrl).responseImage({ (_, errorRes) in
            error = errorRes
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)
        verify404ErrorCode(in: error)

        expectation = self.expectation(description: "Should get 404 error")
        cloudinarySecured.createDownloader().fetchImage(secondMockUrl).responseImage({ (_, errorRes) in
            error = errorRes
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)
        verify404ErrorCode(in: error)
    }

    private func verify404ErrorCode(in error: Error?) {
        XCTAssertNotNil(error, "should get an error")
        XCTAssertNotNil((error! as NSError).userInfo["statusCode"], "should get a statusCode in user info")

        let statusCode = (error! as NSError).userInfo["statusCode"] as! Int
        XCTAssertTrue(statusCode == 404, "Mock error should be 404 in this test")
        let httpStatusCode = HTTPStatusCode(rawValue: statusCode)
        XCTAssertNotNil(httpStatusCode, "should get a case")
        XCTAssertTrue(httpStatusCode?.rawValue == 404)
    }

    func test_downloadImage_shouldDownloadImage() {
        XCTAssertNotNil(cloudinarySecured.config.apiSecret, "Must set api secret for this test")

        var expectation = self.expectation(description: "Upload should succeed")

        var publicId: String?
        uploadFile().response({ (result, error) in
            XCTAssertNil(error)
            publicId = result?.publicId
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }

        expectation = self.expectation(description: "test_downloadImage_shouldDownloadImage Download should succeed")

        var response: UIImage?
        var error: NSError?

        let url = cloudinarySecured!.createUrl().generate(pubId)
        cloudinarySecured.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            response = responseImage
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(response, "response should not be nil")
        XCTAssertNil(error, "error should be nil")
    }
    func test_downloadImageWithCache_shouldCacheAndRemoveImage() {
        cloudinarySecured.enableUrlCache = true
        downloadImageWithCache_shouldCacheImage(cloudinaryObject: cloudinarySecured)
    }
    func test_downloadImageWithoutCache_shouldCacheImage() {
        downloadImageWithoutCache_shouldNotCacheImage(cloudinaryObject: cloudinarySecured)
    }

    func test_downloadImageWithCache_emptyInit_shouldCacheImage() {

        // Given
        let config: CLDConfiguration
        if let url  = Bundle(for: type(of: self)).infoDictionary?["cldCloudinaryUrl"] as? String, url.count > 0 {
            config  = CLDConfiguration(cloudinaryUrl: url)!
        } else {
            config  = CLDConfiguration.initWithEnvParams() ?? CLDConfiguration(cloudinaryUrl: "cloudinary://a:b@test123")!
        }

        // When
        let tempSut = CLDCloudinary(configuration: config, networkAdapter: nil, downloadAdapter: nil, sessionConfiguration: nil, downloadSessionConfiguration: nil)
        tempSut.enableUrlCache = true

        downloadImageWithCache_shouldCacheImage(cloudinaryObject: tempSut)
    }
    func test_downloadImageWithoutCache_emptyInit_shouldCacheImage() {

        // Given
        let config: CLDConfiguration
        if let url  = Bundle(for: type(of: self)).infoDictionary?["cldCloudinaryUrl"] as? String, url.count > 0 {
            config  = CLDConfiguration(cloudinaryUrl: url)!
        } else {
            config  = CLDConfiguration.initWithEnvParams() ?? CLDConfiguration(cloudinaryUrl: "cloudinary://a:b@test123")!
        }

        // When
        let tempSut = CLDCloudinary(configuration: config, networkAdapter: nil, downloadAdapter: nil, sessionConfiguration: nil, downloadSessionConfiguration: nil)

        downloadImageWithoutCache_shouldNotCacheImage(cloudinaryObject: tempSut)
    }
}

extension DownloaderTests {

    // MARK: - cache by cloudinary
    func downloadImageWithCache_shouldCacheImage(cloudinaryObject: CLDCloudinary) {

        XCTAssertNotNil(cloudinaryObject.config.apiSecret, "Must set api secret for this test")

        // When
        var expectation = self.expectation(description: "Upload should succeed")

        /// upload file to get publicId
        var publicId: String?
        uploadFile().response({ (result, error) in
            XCTAssertNil(error)
            publicId = result?.publicId
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }

        expectation = self.expectation(description: "Download 1 should succeed")

        var response: UIImage?
        /// download image by publicId - first time, no cache yet
        let url = cloudinaryObject.createUrl().generate(pubId)
        cloudinaryObject.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            response = responseImage
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        expectation = self.expectation(description: "Download 2 should succeed")

        var responseCached: UIImage?
        /// download image by publicId - should get from cache so responses should be equal
        cloudinaryObject.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            responseCached = responseImage

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertEqual(response?.pngData()?.count, responseCached?.pngData()?.count, "Images should be equal because it is the image we cached")

        expectation = self.expectation(description: "Download 3 should succeed")

        /// remove from cache and re-download - image should be different
//        cloudinaryObject.removeFromCache(key: url!)
        cloudinaryObject.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            responseCached = responseImage

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotEqual(response, responseCached, "Images should be differet because image was removed from cache")
    }
    func downloadImageWithoutCache_shouldNotCacheImage(cloudinaryObject: CLDCloudinary) {

        XCTAssertNotNil(cloudinaryObject.config.apiSecret, "Must set api secret for this test")

        // Given
        var publicId: String?
        var response: UIImage?
        var error: NSError?
        var responseCached: UIImage?

        cloudinaryObject.cacheMaxMemoryTotalCost = 20
        cloudinaryObject.cacheMaxDiskCapacity    = 20

        // When
        var expectation = self.expectation(description: "Upload should succeed")

        /// upload file to get publicId
        uploadFile().response({ (result, error) in
            XCTAssertNil(error)
            publicId = result?.publicId
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }

        expectation = self.expectation(description: "downloadImageWithoutCache_shouldNotCacheImage Download 1 should succeed")

        let url = cloudinaryObject.createUrl().generate(pubId)

        /// download image that will not get cached due to low capacity
        cloudinaryObject.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            response = responseImage
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        expectation = self.expectation(description: "downloadImageWithoutCache_shouldNotCacheImage Download 2 should succeed")

        /// download again (should not get the image from cache due to low capacity)
        cloudinaryObject.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            responseCached = responseImage
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotEqual(response, responseCached, "Images should be not same because the size of the cache is too small")
        XCTAssertNotNil(response, "response should not be nil")
        XCTAssertNil(error, "error should be nil")
    }
}
