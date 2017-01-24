//
//  ManagementApiTests.swift
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


class ManagementApiTests: NetworkBaseTest {
    
    // MARK: - Tests
    
    func testRename() {
        
        let expectation = self.expectation(description: "Rename should succeed")
        
        var result: CLDRenameResult?
        var error: Error?
        
        uploadFile().response({ (uploadResult, uploadError) in
            if let publicId = uploadResult?.publicId {
                let toRename = publicId + "__APPENDED STRING"
                self.cloudinary!.createManagementApi().rename(publicId, to: toRename).response({ (resultRes, errorRes) in
                    result = resultRes
                    error = errorRes
                    
                    expectation.fulfill()
                })
            }
            else {
                error = uploadError
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "response should not be nil")
    }
    
    func testRenameWithParams() {
        
        let expectation = self.expectation(description: "Rename should succeed")
        
        var result: CLDRenameResult?
        var error: Error?
        
        uploadFile().response({ (uploadResult, uploadError) in
            if let publicId = uploadResult?.publicId {
                let toRename = publicId + "__APPENDED STRING"
                self.cloudinary!.createManagementApi().rename(publicId, to: toRename, overwrite: true, invalidate: true).response({ (resultRes, errorRes) in
                    result = resultRes
                    error = errorRes
                    
                    expectation.fulfill()
                })
            }
            else {
                error = uploadError
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "response should not be nil")
    }
    
    func testExplicit() {
        
        let expectation = self.expectation(description: "Explicit should succeed")
        
        var result: CLDExplicitResult?
        var error: Error?
        
        var publicId: String = ""
        var version: String = ""
        var eager: [CLDEagerResult] = []
        let trans = CLDTransformation().setCrop(.scale).setWidth(2.0)
        let resource = TestResourceType.borderCollie
        uploadFile(resource).response({ (uploadResult, uploadError) in
            if let pubId = uploadResult?.publicId {
                publicId = pubId
                let params = CLDExplicitRequestParams()
                params.setEager([trans])
                self.cloudinary!.createManagementApi().explicit(publicId, type: .upload, params: params, completionHandler: { (resultRes, errorRes) in
                    result = resultRes
                    error = errorRes
                    
                    version = result?.version ?? ""
                    eager = result?.eager ?? []
                    
                    expectation.fulfill()
                })
            }
            else {
                error = uploadError
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        

        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "response should not be nil")
        let derivedUrl = eager.first?.secureUrl ?? ""
        
        if let url = cloudinary!.createUrl().setFormat(resource.resourceExtension).setVersion(version).setTransformation(trans).generate(publicId){
            XCTAssertEqual(url, derivedUrl)
        } else{
            XCTFail("url should not be nil")
        }
    }
    
    func testTags() {
        
        var expectation = self.expectation(description: "Adding a tag should succeed")
        
        var result: CLDTagResult?
        var error: Error?
        
        var uploadedPublicId: String = ""
        // first upload
        uploadFile().response({ (uploadResult, uploadError) in
            if let pubId = uploadResult?.publicId {
                uploadedPublicId = pubId
                
                // test adding a tag
                self.cloudinary!.createManagementApi().addTag("tag1", publicIds: [uploadedPublicId]).response({ (resultRes, errorRes) in
                    result = resultRes
                    error = errorRes
                    expectation.fulfill()
                })
            }
            else {
                error = uploadError
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "result should not be nil")

        XCTAssertEqual(result?.publicIds?.first ?? "", uploadedPublicId)
        
        
        // Reaplace tag
        result = nil
        error = nil
        expectation = self.expectation(description: "Replacing a tag should succeed")
        let replacedTag = "replaced_tag"
        cloudinary!.createManagementApi().replaceTag(replacedTag, publicIds: [uploadedPublicId]) { (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "result should not be nil")

        XCTAssertEqual(result?.publicIds?.first ?? "", uploadedPublicId)
        
        // Remove tag
        result = nil
        error = nil
        expectation = self.expectation(description: "Removing a tag should succeed")
        cloudinary!.createManagementApi().removeTag(replacedTag, publicIds: [uploadedPublicId]) { (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "result should not be nil")

        XCTAssertEqual(result?.publicIds?.first ?? "", uploadedPublicId)
    }
    
    func testGenerateText() {
        
        let expectation = self.expectation(description: "Generate text should succeed")
        
        var result: CLDTextResult?
        var error: Error?
        let params = CLDTextRequestParams().setFontStyle(.italic).setFontColor("blue").setTextDecoration(.underline)
        cloudinary!.createManagementApi().text("Hello World", params: params) { (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "result should not be nil")
    }
    
    func testGenerateSprite() {
        
        let uploadParams = CLDUploadRequestParams()
        let tag = "sprite_test_tag"
        uploadParams.setTags([tag])
        let expectation1 = self.expectation(description: "Upload first image")
        let expectation2 = self.expectation(description: "Upload second image")
        uploadFile(params: uploadParams).response({ (r, e) in
            expectation1.fulfill()
            }
        )
        uploadFile(params: uploadParams).response({ (r, e) in
            expectation2.fulfill()
            }
        )
        waitForExpectations(timeout: timeout)

        let expectation = self.expectation(description: "Generating sprite should succeed")
        var result: CLDSpriteResult?
        var error: Error?
        let width = 120, height = 25
        let params = CLDSpriteRequestParams().setTransformation(CLDTransformation().setWidth(width).setHeight(height))
        cloudinary!.createManagementApi().generateSprite(tag, params: params) { (resultRes, errorRes) in
                result = resultRes
                error = errorRes
                expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "result should not be nil")

        XCTAssertGreaterThan(result?.imageInfos?.count ?? 0, 1)
        
        guard let imageInfo = result?.imageInfos?.first?.1 else {
            XCTFail("should have at least one image info.")
            return
        }
        
        XCTAssertEqual(imageInfo.height, height)
        XCTAssertEqual(imageInfo.width, width)
    }
    
    func testMulti() {
        
        let uploadParams = CLDUploadRequestParams()
        let tag = "multi_test_tag"
        uploadParams.setTags([tag])
        let expectation1 = self.expectation(description: "Upload first image")
        let expectation2 = self.expectation(description: "Upload second image")

        uploadFile(params: uploadParams).response({ (r, e) in
            expectation1.fulfill()
            }
        )
        uploadFile(params: uploadParams).response({ (r, e) in
            expectation2.fulfill()
            }
        )
        waitForExpectations(timeout: timeout)

        let expectation = self.expectation(description: "Generating multi should succeed")
        var result: CLDMultiResult?
        var error: Error?
        let params = CLDMultiRequestParams().setTransformation(CLDTransformation().setWidth(120).setHeight(25))
        cloudinary!.createManagementApi().multi(tag, params: params) { (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "result should not be nil")

        let multiUrl = result?.url
        XCTAssertNotNil(multiUrl)
        if let multiUrl = multiUrl {
            let gifRange = multiUrl.range(of: ".gif")
            XCTAssertNotNil(gifRange)
            XCTAssertEqual(multiUrl.distance(from: multiUrl.startIndex, to: gifRange!.lowerBound), multiUrl.characters.count - 4)
        }
    }
    
    func testDeleteByToken() {
        
        var expectation = self.expectation(description: "Upload should succeed")
        
        var deleteToken: String?
        let uploadParams = CLDUploadRequestParams()
        uploadParams.setReturnDeleteToken(true)
        uploadFile(params: uploadParams).response({ (result, error) in
            deleteToken = result?.deleteToken
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        guard let token = deleteToken else {
            XCTFail("Delete token should not be nil at this point")
            return
        }
        
        expectation = self.expectation(description: "Delete by token should succeed")
        var result: CLDDeleteResult?
        var error: Error?
        
        // test the params
        let params = CLDDeleteByTokenRequestParams(params: ["token" : token])
        
        cloudinary!.createManagementApi().deleteByToken(token, params: params) { (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "result should not be nil")

        XCTAssertEqual(result?.result ?? "", "ok")
    }

    func testDestroy() {
        
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
        
        expectation = self.expectation(description: "Destroy should succeed")
        var result: CLDDeleteResult?
        var error: Error?
        let params = CLDDestroyRequestParams().setInvalidate(true)
        cloudinary!.createManagementApi().destroy(pubId, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "result should not be nil")

        XCTAssertEqual(result?.result ?? "", "ok")
    }
    
    func testExplode() {
        
        var expectation = self.expectation(description: "Upload should succeed")
        
        var publicId: String?
        uploadFile(.pdf).response({ (result, error) in
            publicId = result?.publicId
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        guard let pubId = publicId else {
            XCTFail("Public ID should not be nil at this point")
            return
        }
        
        expectation = self.expectation(description: "Explode should succeed")
        var result: CLDExplodeResult?
        var error: Error?
        let params = CLDExplodeRequestParams().setType(.upload)
        cloudinary!.createManagementApi().explode(pubId, transformation: CLDTransformation().setWidth(306).setHeight(396).setPage("all"), params: params) { (resultRes: CLDExplodeResult?, errorRes) in
            result = resultRes
            error = errorRes
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result, "result should not be nil")

        XCTAssertEqual(result?.status ?? "", "processing")
    }
    
}
