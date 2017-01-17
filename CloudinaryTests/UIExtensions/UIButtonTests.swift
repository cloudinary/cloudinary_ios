//
//  UIButtonTests.swift
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

class UIButtonTests: UIBaseTest {
    
    
    // MARK: - Tests
    
    func testImageDownloadedAndSetFromURL() {
        
        let expectation = self.expectation(description: "should succeed downloading and setting image.")
        
        var imageDownloadedAndSet = false
        let btn = TestButton { (image) in
            if image != nil {
                imageDownloadedAndSet = true
            }
            expectation.fulfill()
        }
        
        btn.cldSetImage(url, forState: .normal, cloudinary: cloudinary!)
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertTrue(imageDownloadedAndSet)
        
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
        let btn = TestButton { (image) in
            if image != nil {
                imageDownloadedAndSet = true
            }
            expectation.fulfill()
        }
        
        btn.cldSetImage(publicId: pubId, cloudinary: cloudinary!, forState: .normal)
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertTrue(imageDownloadedAndSet)
        
    }
    
    func testBackgroundImageDownloadedAndSetFromURL() {
        
        let expectation = self.expectation(description: "should succeed downloading and setting image.")
        
        var imageDownloadedAndSet = false
        let btn = TestButton { (image) in
            if image != nil {
                imageDownloadedAndSet = true
            }
            expectation.fulfill()
        }
                
        btn.cld_setBackgroundImage(url, forState: .normal, cloudinary: cloudinary!)
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertTrue(imageDownloadedAndSet)
        
    }
    
    func testBackgroundImageDownloadedAndSetFromPublicID() {
        
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
        let btn = TestButton { (image) in
            if image != nil {
                imageDownloadedAndSet = true
            }
            expectation.fulfill()
        }
        
        btn.cld_setBackgroundImage(publicId: pubId, cloudinary: cloudinary!, forState: .normal)
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertTrue(imageDownloadedAndSet)
        
    }
    
    // MARK: - Helpers
    
    fileprivate class TestButton: UIButton {
        
        var imageSetListener: ((UIImage?) -> ())?
        
        init(imageSetListener: ((UIImage?) -> ())? = nil) {
            super.init(frame: CGRect.zero)
            self.imageSetListener = imageSetListener            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        fileprivate override func setImage(_ image: UIImage?, for state: UIControlState) {
            super.setImage(image, for: state)
            imageSetListener?(image)
        }
        
        fileprivate override func setBackgroundImage(_ image: UIImage?, for state: UIControlState) {
            super.setBackgroundImage(image, for: state)
            imageSetListener?(image)
        }
    }
}
