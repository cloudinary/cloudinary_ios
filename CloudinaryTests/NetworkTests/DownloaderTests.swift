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

class DownloaderTests: NetworkBaseTest {
        
    // MARK: - Tests
    
    func testDownloadImage() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
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
        
        expectation = self.expectation(description: "Download should succeed")
        
        var response: UIImage?
        var error: NSError?
        
        let url = cloudinary!.createUrl().generate(pubId)
        cloudinary!.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            response = responseImage
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNotNil(response, "response should not be nil")
        XCTAssertNil(error, "error should be nil")
    }
    
    func testDownloadImageWithCache() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
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
        
        expectation = self.expectation(description: "Download should succeed")
        
        var response: UIImage?
        var error: NSError?
        
        var url = cloudinary!.createUrl().generate(pubId)
        cloudinary!.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            response = responseImage
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        expectation = self.expectation(description: "Download should succeed")
        
        var responseCached: UIImage?
        
        cloudinary!.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            responseCached = responseImage
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertEqual(response, responseCached, "Images should be same because responseCached get from cache")

        expectation = self.expectation(description: "Download should succeed")
        
        // remove from cache and re-download - image should be different:
        cloudinary!.removeFromCache(key: url!)
        cloudinary!.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            responseCached = responseImage
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotEqual(response, responseCached, "Images should be differet because image was removed from cache")


        //Test without cache
        
        cloudinary!.cacheMaxMemoryTotalCost = 20
        cloudinary!.cacheMaxDiskCapacity = 20
        
        expectation = self.expectation(description: "Upload should succeed")
        
        uploadFile().response({ (result, error) in
            XCTAssertNil(error)
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        expectation = self.expectation(description: "Download should succeed")
        
        url = cloudinary!.createUrl().generate(pubId)
        
        cloudinary!.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            response = responseImage
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        expectation = self.expectation(description: "Download should succeed")
        
        cloudinary!.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            responseCached = responseImage
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNotEqual(response, responseCached, "Images should be not same because size of cache very small")
        
        cloudinary!.cacheMaxDiskCapacity = 150 * 1024 * 1024
        
        XCTAssertNotNil(response, "response should not be nil")
        XCTAssertNil(error, "error should be nil")
    }
}
