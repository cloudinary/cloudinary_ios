//
//  UIImageViewTests.swift
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

class UIImageViewTests: UIBaseTest {
        
    // MARK: - Tests
    
    func testImageDownloadedAndSetFromURL() {
        
        let expectation = self.expectation(description: "should succeed downloading and setting image.")
        
        var imageDownloadedAndSet = false
        let imageView = TestImageView { (image) in
            if image != nil {
                imageDownloadedAndSet = true
            }
            expectation.fulfill()
        }
        
        imageView.cldSetImage(url, cloudinary: cloudinary!)
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertTrue(imageDownloadedAndSet)
        
    }
    
    func testResponsiveImageDownloadedAndSetFromURL() {
        let expectation = self.expectation(description: "Upload should succeed")
        
        var publicId: String?
        uploadFile().response({ (result, error) in
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }
        
        let dpr = UIScreen.main.scale
        
        // Test auto_fill
        // **************
        var params = CLDResponsiveParams.autoFill().setStepSize(50).setMaxDimension(350).setMinDimension(100)
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 145, viewHeight: 172, expectedImageWidth: 150 * dpr, expectedImageHeight: 200 * dpr, label: "fill, step size rounding")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 210, viewHeight: 142, expectedImageWidth: 250 * dpr, expectedImageHeight: 150 * dpr, label: "fill, step size rounding")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 100, viewHeight: 100, expectedImageWidth: 100 * dpr, expectedImageHeight: 100 * dpr, label: "fill, step size rounding, equal to min")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 10, viewHeight: 10, expectedImageWidth: 100 * dpr, expectedImageHeight: 100 * dpr, label: "fill, step size rounding, below minimum")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 10000, viewHeight: 10000, expectedImageWidth: 350 * dpr, expectedImageHeight: 350 * dpr, label: "fill, step size rounding, above maximum")
        
        // Test fit
        // ********
        params = CLDResponsiveParams.fit().setStepSize(50).setMaxDimension(350).setMinDimension(100)
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 100, viewHeight: 300, expectedImageWidth: 100 * dpr, expectedImageHeight: 100 * dpr, label: "fit, step size rounding, equal to min")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 210, viewHeight: 190, expectedImageWidth: 200 * dpr, expectedImageHeight: 200 * dpr, label: "fit, step size rounding")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 300, viewHeight: 100, expectedImageWidth: 100 * dpr, expectedImageHeight: 100 * dpr, label: "fit, step size rounding, equal to min")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 1, viewHeight: 1000, expectedImageWidth: 100 * dpr, expectedImageHeight: 100 * dpr, label: "fit, step size rounding, below min")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 1000, viewHeight: 1, expectedImageWidth: 100 * dpr, expectedImageHeight: 100 * dpr, label: "fit, step size rounding, below min")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 200, viewHeight: 10000, expectedImageWidth: 200 * dpr, expectedImageHeight: 200 * dpr, label: "fit, step size rounding, above max")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 20000, viewHeight: 200, expectedImageWidth: 200 * dpr, expectedImageHeight: 200 * dpr, label: "fit, step size rounding, above max")
        validateResponsiveGeneration(publicId: pubId, params: params, viewWidth: 200, viewHeight: 200, expectedImageWidth: 200 * dpr, expectedImageHeight: 200 * dpr, label: "fit, step size rounding, equal to step size")
    }
    
    func testImageDownloadedAndSetFromPublicID() {
        
        var expectation = self.expectation(description: "Upload should succeed")
        
        var publicId: String?
        uploadFile().response({ (result, error) in
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }
        
        expectation = self.expectation(description: "should succeed downloading and setting image.")
        
        var imageDownloadedAndSet = false
        let imageView = TestImageView { (image) in
            if image != nil {
                imageDownloadedAndSet = true
            }
            expectation.fulfill()
        }
        
        imageView.cldSetImage(publicId: pubId, cloudinary: cloudinary!)
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertTrue(imageDownloadedAndSet)
        
    }
    
    // MARK: - Helpers
    
    private class TestImageView: CLDUIImageView {
        
        var imageSetListener: ((UIImage?) -> ())?
        
        override var image: UIImage? {
            didSet {
                imageSetListener?(image)
            }
        }
        
        init(imageSetListener: ((UIImage?) -> ())? = nil) {
            super.init(frame: CGRect.zero)
            self.imageSetListener = imageSetListener
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }        
    }
    
    private func validateResponsiveGeneration(publicId: String, params: CLDResponsiveParams, viewWidth: Int, viewHeight: Int, expectedImageWidth: CGFloat, expectedImageHeight: CGFloat, label: String) {
        let expectation = self.expectation(description: "Should succeed fetching image with correct dimensions for \(label)")

        var imageDownloadedAndSet = false
        let imageView = TestImageView { (image) in
            if image != nil && image!.size.width == expectedImageWidth && image!.size.height == expectedImageHeight {
                imageDownloadedAndSet = true
            }
            expectation.fulfill()
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        imageView.layoutMargins.bottom = 0
        imageView.layoutMargins.top = 0
        imageView.layoutMargins.left = 0
        imageView.layoutMargins.right = 0
        imageView.layoutSubviews()
        imageView.cldSetImage(publicId: publicId, cloudinary: cloudinary!, responsiveParams: params)

        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertTrue(imageDownloadedAndSet)
    }
}
