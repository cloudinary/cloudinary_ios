//
//  UploaderTests.swift
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
@testable import Cloudinary

class UploaderTests: NetworkBaseTest {

    // MARK: - Tests

    func testUploadImageData() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let data = TestResourceType.borderCollie.data

        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setColors(true)
        cloudinary!.createUploader().signedUpload(data: data, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }

    func testUploadRespectTimeoutFromConfiguration() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectedResult = "-1001"
        let expectation = self.expectation(description: "upload should fail")
        let data = TestResourceType.borderCollie.data

        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setColors(true)
        cloudinaryInsufficientTimeout!.createUploader().signedUpload(data: data, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        var actualResult = String()

        if let error = error {
            actualResult = String((error as NSError).code)
        }

        XCTAssertNotNil(error, "error should not be nil")
        XCTAssertNil(result, "response should be nil")
        XCTAssertEqual(actualResult, expectedResult, "error should occur due to timeout")
    }

    func testUploadRespectTimeoutFromParameters() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectedResult = "-1001"
        let expectation = self.expectation(description: "upload should fail")
        let data = TestResourceType.borderCollie.data

        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setColors(true)
        params.setTimeout(from: cloudinaryInsufficientTimeout!.config)
        cloudinaryInsufficientTimeout!.createUploader().signedUpload(data: data, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        var actualResult = String()

        if let error = error {
            actualResult = String((error as NSError).code)
        }

        XCTAssertNotNil(error, "error should not be nil")
        XCTAssertNil(result, "response should be nil")
        XCTAssertEqual(actualResult, expectedResult, "error should occur due to timeout")
    }
    
    func testUploadPNGImageData() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let data = TestResourceType.logo.data
        
        // Load the image into memory to decompress it, this will give us the real size of the image.
        let imageSize = UIImage(data: data)?.pngData()?.count
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setResourceType(.image)
        let chain = CLDImagePreprocessChain().setEncoder(CLDPreprocessHelpers.customImageEncoder(format: EncodingFormat.PNG, quality: 100))
        
        cloudinary!.createUploader().signedUpload(data: data, params: params, preprocessChain: chain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertEqual(imageSize, Int(result!.length!))
    }
    
    func testUploadPNGImageDataFromMemory() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let pngImageDataLoadedToMemory = UIImage(data: TestResourceType.logo.data)!.pngData()!
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setResourceType(.image)
        let chain = CLDImagePreprocessChain().setEncoder(CLDPreprocessHelpers.customImageEncoder(format: EncodingFormat.PNG, quality: 100))
        
        cloudinary!.createUploader().signedUpload(data: pngImageDataLoadedToMemory, params: params, preprocessChain: chain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertEqual(pngImageDataLoadedToMemory.count, Int(result!.length!))
    }
    
    func testUploadPNGImageFile() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let url = TestResourceType.logo.url

        // Load the image into memory to decompress it, this will give us the real size of the image.
        let imageSize = UIImage(contentsOfFile: url.relativePath)?.pngData()?.count
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setResourceType(.image)
        let chain = CLDImagePreprocessChain().setEncoder(CLDPreprocessHelpers.customImageEncoder(format: EncodingFormat.PNG, quality: 100))
        
        cloudinary!.createUploader().signedUpload(url: url, params: params, preprocessChain: chain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertEqual(imageSize, Int(result!.length!))
    }
    
    func testUploadPNGImageFileWithPreprocess() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let file = TestResourceType.logo.url
        var result: CLDUploadResult?
        var error: NSError?

        let preprocessChain = CLDImagePreprocessChain()
            .addStep(CLDPreprocessHelpers.limit(width: 50, height: 50))
            .setEncoder(CLDPreprocessHelpers.customImageEncoder(format: EncodingFormat.PNG, quality: 100))
        let params = CLDUploadRequestParams()
        params.setColors(true)
        cloudinary!.createUploader().signedUpload(url: file, params: params, preprocessChain: preprocessChain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result!.width, "width should not be nil")
        XCTAssertNotNil(result!.height, "height should not be nil")
        // The image "logo" is not a square, setting maximum width and height to 50 will match its aspect ratio but still should be less then or equal to 50.
        XCTAssertTrue(result!.width! <= 50, "Width must be less then 50")
        XCTAssertTrue(result!.height! <= 50, "Height must be less then 50")
    }

    func testUploadImageFile() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let file = TestResourceType.borderCollie.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setColors(true)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }

    func testUploadFolderDecoupling() throws {

        try XCTSkipUnless(skipFolderDecouplingTest(), "prevents redundant call to Cloudinary PAID Folder Decoupling service. to allow Folder Decoupling service testing - set to true")

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed and return the params sent")
        let file = TestResourceType.borderCollie.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()

        params.setPublicIdPrefix("public_id_prefix")
        params.setAssetFolder("asset_folder")
        params.setDisplayName("display_name")
        params.setUseFilenameAsDisplayName(true)
        params.setFolder("folder/test")

        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result?.assetFolder, "result should not be nil")
        XCTAssertNotNil(result?.displayName, "result should not be nil")

        XCTAssertNil(error, "error should be nil")
    }

    func testUploadImageFileWithPreprocess() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let file = TestResourceType.borderCollie.url
        var result: CLDUploadResult?
        var error: NSError?

        let preprocessChain = CLDImagePreprocessChain().addStep(CLDPreprocessHelpers.limit(width: 500, height: 500))
        let params = CLDUploadRequestParams()
        params.setColors(true)
        cloudinary!.createUploader().signedUpload(url: file, params: params, preprocessChain: preprocessChain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertEqual(result?.width, 500)
        XCTAssertEqual(result?.height, 500)
    }

    func testUploadWithPreprocessValidator() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should fail")
        let file = TestResourceType.logo.url
        var result: CLDUploadResult?
        var error: NSError?

        let preprocessChain = CLDImagePreprocessChain().addStep(CLDPreprocessHelpers.dimensionsValidator(minWidth: 500, maxWidth: 1500, minHeight: 500, maxHeight: 1500))
        let params = CLDUploadRequestParams()
        params.setColors(true)
        cloudinary!.createUploader().signedUpload(url: file, params: params, preprocessChain: preprocessChain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNil(result, "result should be nil")
        XCTAssertNotNil(error, "error should not be nil")
    }

    func testUploadLargeErrors() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        var expectation = self.expectation(description: "Chunk size under 5MB should fail")
        let file = TestResourceType.dog.url
        var requestError: NSError?

        let params = CLDUploadRequestParams()
        params.setResourceType(CLDUrlResourceType.video)
        // chunk size is too small:
        cloudinary!.createUploader().signedUploadLarge(url: file, params: params, chunkSize: 3 * 1024 * 1024, progress: nil).response({ (resultRes, errorRes) in
            requestError = errorRes
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)

        expectation = self.expectation(description: "Uploading non-existing file should fail")
        cloudinary!.createUploader().signedUploadLarge(url: URL(fileURLWithPath: "non/existing/file"), params: params, chunkSize: 10 * 1024 * 1024, progress: nil).response({ (resultRes, errorRes) in
            requestError = errorRes
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(requestError, "Error should not be nil")
    }

    func testUploadLarge() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload large should succeed")
        let file = TestResourceType.dog.url
        let filename = TestResourceType.dog.fileName
        var requestResult: CLDUploadResult?
        var requestError: NSError?

        let params = CLDUploadRequestParams()
        params.setResourceType(CLDUrlResourceType.video)
        params.setUseFilename(true)
        

        cloudinary!.createUploader().signedUploadLarge(url: file, params: params, chunkSize: 5 * 1024 * 1024).response({ (result, error) in
            requestResult = result
            requestError = error
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(requestResult, "result should not be nil")
        XCTAssertNil(requestError, "error should be nil")
        XCTAssertTrue(isUsedFilename(filename: filename, publicId: requestResult?.publicId))
    }

    func testUploadVideoData() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let data = TestResourceType.dog.data

        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams().setColors(true)
        params.setResourceType(.video)
        cloudinary!.createUploader().signedUpload(data: data, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: 60.0, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }

    func testUploadAccessControlParams() {

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

        let aclToken = CLDAccessControlRule.token()
        let start = formatter.date(from: "2019-02-22 16:20:57 +0200")!
        let end = formatter.date(from: "2019-03-22 00:00:00 +0200")!
        let acl = CLDAccessControlRule.anonymous(start: start, end: end)

        let aclString = "{\"access_type\":\"anonymous\",\"start\":\"2019-02-22 16:20:57 +0200\",\"end\":\"2019-03-22 00:00 +0200\"}"

        var params = CLDUploadRequestParams().setAccessControl([aclToken])
        XCTAssertEqual(params.accessControl, "[{\"access_type\":\"token\"}]")

        params = CLDUploadRequestParams().setAccessControl([acl])
        XCTAssertEqual(params.accessControl!, "[{\"start\":\"2019-02-22T14:20:57Z\",\"end\":\"2019-03-21T22:00:00Z\",\"access_type\":\"anonymous\"}]")

        params = CLDUploadRequestParams().setAccessControl(aclString)
        XCTAssertEqual(params.accessControl!, aclString)
    }

    func testUploadWithAccessControl() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let start = formatter.date(from: "2019-02-22 16:20:57 +0200")!
        let end = formatter.date(from: "2019-03-22 00:00:00 +0200")!

        let anonStartEnd = CLDAccessControlRule.anonymous(start: start, end: end)
        let anonStart = CLDAccessControlRule.anonymous(start: start)
        let anonEnd = CLDAccessControlRule.anonymous(end: end)
        let token = CLDAccessControlRule.token()

        uploadAndCompare(accessControl: [anonStartEnd])
        uploadAndCompare(accessControl: [anonStart])
        uploadAndCompare(accessControl: [anonEnd])
        uploadAndCompare(accessControl: [token])
        uploadAndCompare(accessControl: [anonStart, token])
        uploadAndCompare(accessControl: [anonStartEnd, token])
        uploadAndCompare(accessControl: [token, anonEnd])
    }

    fileprivate func uploadAndCompare(accessControl: [CLDAccessControlRule]) {
        let file = TestResourceType.borderCollie.url

        var result: CLDUploadResult?
        var error: NSError?

        let expectation = self.expectation(description: "Upload should succeed")

        let params = CLDUploadRequestParams().setAccessControl(accessControl)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: 30.0, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")

        let returnedAcl = (result?.accessControl)!

        for index in 0..<returnedAcl.count {
            XCTAssertTrue(returnedAcl[index] == accessControl[index], "Returned access control should be equal to the requested access control")
        }
    }

    func testUploadVideoFile() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let file = TestResourceType.dog.url

        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams().setColors(true)
        params.setResourceType(.video)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: 60.0, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }

    func testUploadImageDataUsingSignature() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let data = TestResourceType.borderCollie.data

        var result: CLDUploadResult?
        var error: NSError?


        let timestamp = Int(Date().timeIntervalSince1970)
        let signature = cloudinarySignParamsUsingSecret(["timestamp": String(describing: timestamp)], cloudinaryApiSecret: cloudinary!.config.apiSecret!)

        let params = CLDUploadRequestParams()
        params.setSignature(CLDSignature(signature: signature, timestamp: NSNumber(value: timestamp)))
        cloudinary!.createUploader().signedUpload(data: data, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }

    func testUnsignedUploadImageFile() {

        let prefix = cloudinary!.config.apiSecret != nil ? "\(cloudinary!.config.apiKey!):\(cloudinary!.config.apiSecret!)" : cloudinary!.config.apiKey!
        let uploadPresetUrl = "https://\(prefix)@api.cloudinary.com/v1_1/\(cloudinary!.config.cloudName!)/upload_presets"
        let presetName = "ios_unsigned_upload"

        var options = [String: AnyObject]()
        options["api_key"] = cloudinary?.config.apiKey as AnyObject
        options["cloud_name"] = cloudinary?.config.cloudName as AnyObject

        let config = CLDConfiguration(options: options)
        let cloudinaryNoSecret = CLDCloudinary(configuration: config!, sessionConfiguration: URLSessionConfiguration.default)

        XCTAssertNil(cloudinaryNoSecret.config.apiSecret, "api secret should not be set to test unsigned upload")

        createUploadPresetIfNeeded(uploadPresetUrl, presetName: presetName)

        let expectation = self.expectation(description: "Upload should succeed")
        let file = TestResourceType.borderCollie.url

        var result: CLDUploadResult?
        var error: NSError?

        cloudinaryNoSecret.createUploader().upload(url: file, uploadPreset: presetName, params: CLDUploadRequestParams()).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            expectation.fulfill()
        })
        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")

        if let
           pubId = result?.publicId,
           let version = result?.version,
           let sig = result?.signature {
            let toSign = ["public_id": pubId, "version": version]
            let expectedSignature = cloudinarySignParamsUsingSecret(toSign, cloudinaryApiSecret: (cloudinary!.config.apiSecret)!)
            XCTAssertEqual(sig, expectedSignature)
        } else {
            XCTFail("Need to receive public_id, version and signature in the response")
        }
    }


    func testUploadRemoteUrl() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")

        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        cloudinary!.createUploader().signedUpload(url: URL(string: "http://cloudinary.com/images/old_logo.png")!, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")

    }
    
    func testUploadLargeRemoteUrl() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        let expectation = self.expectation(description: "Upload should succeed")
        
        var result: CLDUploadResult?
        var error: NSError?
        
        let params = CLDUploadRequestParams()
        cloudinary!.createUploader().signedUploadLarge(url: URL(string: "http://cloudinary.com/images/old_logo.png")!, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        
    }


    func testUseFilename() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let filename = resource.fileName
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setUseFilename(true)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertTrue(isUsedFilename(filename: filename, publicId: result?.publicId))
    }
    
    func isUsedFilename(filename: String, publicId: String?)-> Bool {
        var matches = 0
        if let publicId = publicId {
            let regex = try! NSRegularExpression(pattern: "\(filename)_[a-z0-9]{6}", options: NSRegularExpression.Options(rawValue: 0))
            matches = regex.numberOfMatches(in: publicId, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, publicId.count))
        }
        
        return matches == 1
    }

    func testUniqueFilename() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let filename = resource.fileName
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setUseFilename(true).setUniqueFilename(false)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")

        XCTAssertEqual(result?.publicId ?? "", filename)
    }

    func testUploadAsync() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams().setAsync(true)

        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")

        let status = result?.resultJson["status"] as? String
        XCTAssertEqual(status, "pending")
    }
    
    func testUploadLargeWithSignature(){
        let expectation = self.expectation(description: "Signed upload large should succeed")
        let timestamp = Int(Date().timeIntervalSince1970)
        let signature = cloudinarySignParamsUsingSecret(["timestamp" : String(describing: timestamp)], cloudinaryApiSecret: (cloudinary?.config.apiSecret)!)
        
        let params = CLDUploadRequestParams().setResourceType(CLDUrlResourceType.video).setSignature(CLDSignature(signature: signature, timestamp: NSNumber(value: timestamp)))
        let resource: TestResourceType = .dog
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        cloudinaryNoSecret.createUploader().signedUploadLarge(url: file, params: params as! CLDUploadRequestParams, chunkSize: 6 * 1024 * 1024)
            .response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }

    func testEager() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        let trans = CLDEagerTransformation().setCrop(.crop).setWidth(2.0).setFormat("png")
        let trans2 = CLDEagerTransformation().setCrop(.crop).setWidth(2.0).setFormat("gif")
        params.setEager([trans, trans2])

        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertTrue((result?.eager?[0].url?.hasSuffix("png")) ?? false)
        XCTAssertTrue((result?.eager?[1].url?.hasSuffix("gif")) ?? false)
    }

    func testHeaders() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setHeaders(["Link": "1"])
        params.setContext(["caption": "My Logo"])
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }

    func testFaceCoordinates() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        let coordinate = CLDCoordinate(rect: CGRect(x: 10, y: 10, width: 100, height: 15000))
        params.setFaceCoordinates([coordinate])
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        let resultCoords = (result!.coordinates!.faces as! NSArray)[0] as! NSArray
        XCTAssertEqual(resultCoords[0] as! Float, 10)
        XCTAssertEqual(resultCoords[1] as! Float, 10)
        XCTAssertEqual(resultCoords[2] as! Float, 100)
        XCTAssertEqual(resultCoords[3] as! Float, Float(result!.height!))
    }

    func testCustomCoordinates() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        let coordinate = CLDCoordinate(rect: CGRect(x: 10, y: 10, width: 100, height: 100))
        params.setCustomCoordinates([coordinate])
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }

    func testResponsiveBreakpoints() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?
        
        let params = CLDUploadRequestParams()
        let breakpoints = CLDResponsiveBreakpoints(createDerived: true).setBytesStep(1000).setFormat("webp").setTransformations(CLDTransformation().setAngle(10))
        params.setResponsiveBreakpoints([breakpoints])
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(result?.responsiveBreakpoints?[0].breakpoints?[0].url, "responsive breakpoints url cannot be nil")
        XCTAssertTrue(result!.responsiveBreakpoints![0].breakpoints![0].url!.hasSuffix("webp"), "responsive breakpoints url has to end with the right format (webp)")
        XCTAssertNotNil(result?.responsiveBreakpoints?[0].transformation)
        XCTAssertTrue(result!.responsiveBreakpoints![0].transformation!.contains("a_10"))
    }
    
    func testContext() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        var expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        let customContext = ["caption": "some cäption", "alt": "alternativè"]
        params.setContext(customContext)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            if let error = error {
                print(error)
            }
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        if let context = result!.context {
            if let custom = context["custom"] {
                XCTAssertTrue(NSDictionary(dictionary: custom).isEqual(to: customContext))
            } else {
                XCTFail("Context should have a 'custom' key")
            }
        } else {
            XCTFail("Result should include a 'context' key")
        }

        expectation = self.expectation(description: "Explicit should succeed")
        let differentContext = ["caption": "different = caption", "alt2": "alt|alternative alternative"]

        let exParams: CLDExplicitRequestParams? = CLDExplicitRequestParams().setType(.upload).setContext(differentContext)
        cloudinary!.createManagementApi().explicit(result!.publicId!, type: .upload, params: exParams).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        if let context = result!.context {
            if let custom = context["custom"] {
                XCTAssertTrue(NSDictionary(dictionary: custom).isEqual(to: differentContext))
            } else {
                XCTFail("Context should have a 'custom' key")
            }
        } else {
            XCTFail("Result should include a 'context' key")
        }
    }
    
    func testQualityAnalysis() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?
        
        let params = CLDUploadRequestParams()
        params.setQualityAnalysis(true)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        
        XCTAssertNotNil(result?.qualityAnalysisResult, "quality analysis field in upload result should not be nil")
    }
    
    func test_upload_NoApiKeyFail() {
        
        // Given
        XCTAssertNotNil(cloudinary!.config.apiKey, "Must set api key for this test")
        
        let expectation = self.expectation(description: "Upload should fail for not specifing an api key in config and not passing it as argument")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let configWithEmptyApiKey = CLDConfiguration(cloudName: cloudinary!.config.cloudName,
                                                     apiKey: "",
                                                     apiSecret: cloudinary!.config.apiSecret,
                                                     secure: true)
        let cloudinaryWithNoKey = CLDCloudinary(configuration: configWithEmptyApiKey, sessionConfiguration: .default)

        // When
        cloudinaryWithNoKey.createUploader().signedUpload(url: file, params: CLDUploadRequestParams()).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        // Expect
        XCTAssertNil(result, "result should be nil")
        XCTAssertNotNil(error, "error should not be nil")
        
        XCTAssertEqual(400, error!.code)
        XCTAssertEqual("Missing required parameter - api_key", error!.userInfo["message"] as! String, "Api key should be unassigned")
    }
    
    func test_upload_ApiKeyAsArgument() {
        
        // Given
        
        XCTAssertNotNil(cloudinary!.config.apiKey, "Must set api key for this test")

        let expectation = self.expectation(description: "Upload should succeed with the key passed as an argument")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let cloudName = cloudinary!.config.cloudName!
        let apiKey    = ""
        let apiSecret = cloudinary!.config.apiSecret
        
        XCTAssertNotNil(cloudName, "cloudName Should not be nil")
        XCTAssertNotNil(apiSecret, "apiSecret Should not be nil")
        
        let configWithEmptyApiKey = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: apiSecret, secure: true)
        let cloudinaryWithNoKey = CLDCloudinary(configuration: configWithEmptyApiKey, sessionConfiguration: .default)
        
        XCTAssertEqual(cloudinaryWithNoKey.config.apiKey, "", "Should be empty")
        
        // When
        let params = CLDUploadRequestParams()
        params.setApiKey(cloudinary!.config.apiKey!)
        
        cloudinaryWithNoKey.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        // Expect
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }
    
    func test_upload_ApiKeyWithConfig() {
        
        // Given
        
        XCTAssertNotNil(cloudinary!.config.apiKey, "Must set api key for this test")

        let expectation = self.expectation(description: "Upload should succeed with the key in config")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        // When

        cloudinary!.createUploader().signedUpload(url: file, params: CLDUploadRequestParams()).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        // Expect
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }
    

    
    // MARK: - eval
    func test_eval_JavaScriptAddTag_shouldAddTag() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        let tagInput = "blurry"
        let input = "upload_options.tags = '\(tagInput)'"
        
        var result: CLDUploadResult?
        var error: NSError?
        
        let params = CLDUploadRequestParams()
        params.setEval(input)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        
        if let tags = result?.tags {
            XCTAssertTrue(tags.contains(tagInput), "eval field in this scenario should add tag via javascript code, then in the upload result the tag should appear")
        }
        else {
            XCTFail("eval field in this scenario should add tag via javascript code, then in the upload result the tag should appear")
        }
    }
    func test_eval_JavaScriptAddTagWithCondition_shouldAddTag() {
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        let tagInput = "blurry"
        let input = "if (resource_info.quality_analysis.focus > 0.5) { upload_options.tags = '\(tagInput)' }"
        
        var result: CLDUploadResult?
        var error: NSError?
        
        let params = CLDUploadRequestParams()
        params.setEval(input)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        
        if let tags = result?.tags {
            XCTAssertTrue(tags.contains(tagInput), "eval field in this scenario should add tag via javascript code, then in the upload result the tag should appear")
        }
        else {
            XCTFail("eval field in this scenario should add tag via javascript code, then in the upload result the tag should appear")
        }
    }

    func testManualModeration() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setModeration(.manual)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")

        if let moderationArr = result?.moderation as? NSArray {
            if let mod = moderationArr.firstObject as? NSDictionary,
               let status = mod["status"] as? String,
               let kind = mod["kind"] as? String {
                XCTAssertEqual(status, "pending")
                XCTAssertEqual(kind, "manual")
            } else {
                XCTFail("Moderation dictionary should hold its status and kind.")
            }
        } else {
            XCTFail("Manual moderation response should be a dictionary holding a moderation dictionary.")
        }

    }
    
    func testBackgroundRemoval() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setBackgroundRemoval("illegal")
        params.setResourceType(.image)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNil(result, "result should be nil")
        XCTAssertNotNil(error, "error should not be nil")

        if let userInfo = error?.userInfo, let errMessage = userInfo["message"] as? String {
            XCTAssertNotNil(errMessage.range(of: "Background removal is invalid"))
            XCTAssertEqual(userInfo["statusCode"] as? Int, 400)
        } else {
            XCTFail("Error should hold a message in its user info.")
        }
    }
    
    func testFilenameOverride() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed and uploaded filename should change to 'overridden'")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setFilenameOverride("overridden")
        params.setUseFilename(true)
        params.setResourceType(.image)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        
        if let originalFilename = result?.originalFilename {
            XCTAssertEqual(originalFilename, "overridden", "Filename mismatch, replaced name should be 'overridden'")
        } else {
            XCTFail("Upload param 'original_filename' is missing")
        }
    }

    func testRawConversion() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .docx
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setRawConvert("illegal")
        params.setResourceType(.raw)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNil(result, "result should be nil")
        XCTAssertNotNil(error, "error should not be nil")

        if let userInfo = error?.userInfo, let errMessage = userInfo["message"] as? String {
            XCTAssertNotNil(errMessage.range(of: "Raw convert is invalid"))
            XCTAssertEqual(userInfo["statusCode"] as? Int, 400)
        } else {
            XCTFail("Error should hold a message in its user info.")
        }
    }

    func testCategorization() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setCategorization("illegal")
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNil(result, "result should be nil")
        XCTAssertNotNil(error, "error should not be nil")

        if let userInfo = error?.userInfo, let errMessage = userInfo["message"] as? String {
            XCTAssertNotNil(errMessage.range(of: "Categorization item illegal is not valid"))
            XCTAssertEqual(userInfo["statusCode"] as? Int, 400)
        } else {
            XCTFail("Error should hold a message in its user info.")
        }
    }
    
    func testDetection() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?

        let params = CLDUploadRequestParams()
        params.setDetection("illegal")
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        XCTAssertNil(result, "result should be nil")
        XCTAssertNotNil(error, "error should not be nil")

        if let errMessage = error?.userInfo["message"] as? String {
            XCTAssertNotNil(errMessage.range(of: "Detection invalid"))
        } else {
            XCTFail("Error should hold a message in its user info.")
        }
    }
    
    func testCldIsRemoteUrl(){
        let remoteUrls = [
            "ftp://ftp.cloudinary.com/images/old_logo.png",
            "http://cloudinary.com/images/old_logo.png",
            "https://cloudinary.com/images/old_logo.png",
            "s3://s3-us-west-2.amazonaws.com/cloudinary/images/old_logo.png",
            "gs://cloudinary/images/old_logo.png",
            "data:image/gif;charset=utf-8;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7",
            "data:image/gif;param1=value1;param2=value2;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7",
            "data:image/svg+xml;charset=utf-8;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPg",
            "data:image/gif;charset=utf8;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"
        ]
        
        remoteUrls.forEach({XCTAssertTrue($0.cldIsRemoteUrl())})
        
        let notRemoteUrls = [
            "not a remote url",
            "http/almost",
            ""
        ]
        
        notRemoteUrls.forEach({XCTAssertFalse($0.cldIsRemoteUrl())})
    }
    
    func testQualityOverride(){
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        let result = uploadResource()
        
        validateQualityOverride(publicId: result.publicId!, quality: "80", shouldSucceed: true)
        validateQualityOverride(publicId: result.publicId!, quality: "80:420", shouldSucceed: true)
        validateQualityOverride(publicId: result.publicId!, quality: "80:421", shouldSucceed: false)
        validateQualityOverride(publicId: result.publicId!, quality: "auto:best", shouldSucceed: true)
        validateQualityOverride(publicId: result.publicId!, quality: "auto:advanced", shouldSucceed: false)
        validateQualityOverride(publicId: result.publicId!, quality: "none", shouldSucceed: true)
    }

    //MARK: - Helpers

    func uploadResource() -> CLDUploadResult {
        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?
        
        
        cloudinary!.createUploader().signedUpload(url: file, params: CLDUploadRequestParams())
            .response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            if let error = error {
                print(error)
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertNotNil(result, "result should not be nil")
        
        return result!
    }
    
    func validateQualityOverride(publicId: String, quality: String, shouldSucceed: Bool){

        let qualityOverrideExpectation = self.expectation(description: "Explicit call with quality override should succeed")
        var result: CLDUploadResult?
        var error: NSError?
        
        let params = CLDExplicitRequestParams().setQualityOverride(quality)
        cloudinary!.createManagementApi().explicit(publicId, type: "upload", params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            if let error = error {
                print(error)
            }
            qualityOverrideExpectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        let notNil = shouldSucceed ? result : error
        XCTAssertNotNil(notNil, "quality \(quality) should \(shouldSucceed ? "succeed" : "fail")")
    }
    
    func createUploadPresetIfNeeded(_ uploadPresetUrl: String, presetName: String) {
        let semaphore = DispatchSemaphore(value: 0)
        if let url = URL(string: "\(uploadPresetUrl)/\(presetName)") {
            let session = URLSession.shared
            session.dataTask(with: url, completionHandler: { (returnData, response, error) -> () in
                if let returnData = returnData {
                    if let strData = String(data: returnData, encoding: String.Encoding.utf8) {
                        if strData.range(of: "Can't find upload preset named") != nil {
                            if let url = URL(string: uploadPresetUrl) {
                                var request = URLRequest(url: url)
                                request.httpMethod = "POST"
                                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                                let params = "name=\(presetName)&unsigned=true&tags=ios_sdk_test"
                                let httpData = params.data(using: String.Encoding.utf8)
                                request.httpBody = httpData
                                session.dataTask(with: request, completionHandler: { (returnData, response, error) -> () in
                                    if let returnData = returnData,
                                       let strData = String(data: returnData, encoding: String.Encoding.utf8) {
                                        print(strData)
                                    }
                                    semaphore.signal()
                                }).resume()
                            } else {
                                XCTFail("preset request failed")
                                semaphore.signal()
                            }
                        } else {
                            semaphore.signal()
                        }
                    } else {
                        XCTFail("preset request failed")
                        semaphore.signal()
                    }
                } else {
                    XCTFail("preset request failed")
                    semaphore.signal()
                }
            }).resume()
        } else {
            XCTFail("preset request failed")
            semaphore.signal()
        }

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }

    let environmentFolderDecoupling = "CLD_FOLDER_DECOUPLING"

    func skipFolderDecouplingTest() -> Bool {
        guard let _ = ProcessInfo.processInfo.environment[environmentFolderDecoupling] else {
            return false
        }
        return true
    }

}

