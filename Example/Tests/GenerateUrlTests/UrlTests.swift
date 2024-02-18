//
//  UrlTests.swift
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

class UrlTests: BaseTestCase {
    let prefix = "https://res.cloudinary.com/test123"

    var sut: CLDCloudinary?

    override func setUp() {
        super.setUp()
        let config = CLDConfiguration(cloudinaryUrl: "cloudinary://a:b@test123?analytics=false")!
        sut = CLDCloudinary(configuration: config)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testParseCloudinaryUrlNoPrivateCdn() {
        let config = CLDConfiguration(cloudinaryUrl: "cloudinary://abc:def@ghi")

        XCTAssertEqual(config?.apiKey, "abc")
        XCTAssertEqual(config?.apiSecret, "def")
        XCTAssertEqual(config?.cloudName, "ghi")
        XCTAssertEqual(config?.privateCdn, false)
    }

    func testParseCloudinaryUrlWithPrivateCdn() {
        let config = CLDConfiguration(cloudinaryUrl: "cloudinary://abc:def@ghi/jkl")

        XCTAssertEqual(config?.apiKey, "abc")
        XCTAssertEqual(config?.apiSecret, "def")
        XCTAssertEqual(config?.cloudName, "ghi")
        XCTAssertEqual(config?.privateCdn, true)
        XCTAssertEqual(config?.secureDistribution, "jkl")
    }

    func testCloudName() {
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/test")
    }
    
   func testCloudinaryUrlValidScheme() {
       let isValid = CLDConfiguration.validateUrl(url: "cloudinary://123456789012345:ALKJdjklLJAjhkKJ45hBK92baj3@test")
       XCTAssertTrue(isValid);
    }
    
    func testCloudinaryUrlInvalidScheme() {
       let isValid = CLDConfiguration.validateUrl(url: "https://123456789012345:ALKJdjklLJAjhkKJ45hBK92baj3@test")
       XCTAssertFalse(isValid);
    }
     
    func testCloudinaryUrlEmptyScheme() {
        let isValid = CLDConfiguration.validateUrl(url: "")
        XCTAssertFalse(isValid);
    }

    func testInitConfiguration(){
        let config = CLDConfiguration(cloudinaryUrl: "https://123456789012345:ALKJdjklLJAjhkKJ45hBK92baj3@test")
        XCTAssertEqual(config, nil)
        
        let config2 = CLDConfiguration(cloudinaryUrl: "cloudinary://123456789012345:ALKJdjklLJAjhkKJ45hBK92baj3@test")
        XCTAssertNotNil(config2)
    }

    func testSecure() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", secure: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/test")
    }

    func testSecureDistribution() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", secure: true, secureDistribution: "something.else.com", analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "https://something.else.com/test123/image/upload/test")
    }

    func testSecureAkamai() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, secure: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "https://test123-res.cloudinary.com/image/upload/test")
    }

    func testSecureNonAkamai() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, secure: true, secureDistribution: "something.cloudfront.net", analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "https://something.cloudfront.net/image/upload/test")
    }

    func testHttpPrivateCdn() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "http://test123-res.cloudinary.com/image/upload/test")
    }

    func testCdnSubDomain() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", cdnSubdomain: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "http://res-2.cloudinary.com/test123/image/upload/test")
    }

    func testSecureCdnSubDomainFalse() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", secure: true, cdnSubdomain: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/test")
    }

    func testSecureCdnSubDomainTrue() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, secure: true, cdnSubdomain: true, secureCdnSubdomain: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "https://test123-res-2.cloudinary.com/image/upload/test")
    }

    func testAnalyticsTrue() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, secure: true, cdnSubdomain: true, secureCdnSubdomain: true, analytics: true)
        config.analyticsObject.setSDKVersion(version: "3.3.0")
        config.analyticsObject.setTechVersion(version: "5.0")
        config.analyticsObject.setOsVersion(version: "17.0")
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "https://test123-res-2.cloudinary.com/image/upload/test?_a=DAEAEvAFBRA0")
    }

    func testFormat() {
        let url = sut?.createUrl().setFormat("jpg").generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/test.jpg")
    }

    func testCrop() {
        let trans = CLDTransformation().setWidth(100).setHeight(101)
        var url = sut?.createUrl().setTransformation(trans).generate("test")

        url = sut?.createUrl().setTransformation(CLDTransformation().setWidth(100).setHeight(101).setCrop(.crop)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_crop,h_101,w_100/test")
    }

    func testVariousOptions() {
        let url = sut?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality("0.4").setPrefix("a")).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/g_center,p_a,q_0.4,r_3,x_1,y_2/test")
        let urlRadius = sut?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius([10,20,"30","$v"]).setGravity(.center).setQuality("0.4").setPrefix("a")).generate("test")
        XCTAssertEqual(urlRadius, "\(prefix)/image/upload/g_center,p_a,q_0.4,r_10:20:30:$v,x_1,y_2/test")
        let urlRadius2 = sut?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius([20,0,"3"]).setGravity(.center).setQuality("0.4").setPrefix("a")).generate("test")
        XCTAssertEqual(urlRadius2, "\(prefix)/image/upload/g_center,p_a,q_0.4,r_20:0:3,x_1,y_2/test")
    }

    func testQuality() {
        let urlAuto = sut?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality(.auto()).setPrefix("a")).generate("test")
        XCTAssertEqual(urlAuto, "\(prefix)/image/upload/g_center,p_a,q_auto,r_3,x_1,y_2/test")

        let urlEco = sut?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality(.auto(.eco)).setPrefix("a")).generate("test")
        XCTAssertEqual(urlEco, "\(prefix)/image/upload/g_center,p_a,q_auto:eco,r_3,x_1,y_2/test")

        let urlFixed = sut?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality(.fixed(50)).setPrefix("a")).generate("test")
        XCTAssertEqual(urlFixed, "\(prefix)/image/upload/g_center,p_a,q_50,r_3,x_1,y_2/test")

        let urlJpegMini = sut?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality(.jpegMini()).setPrefix("a")).generate("test")
        XCTAssertEqual(urlJpegMini, "\(prefix)/image/upload/g_center,p_a,q_jpegmini,r_3,x_1,y_2/test")
    }

    func testTransformationSimple() {
        let url = sut?.createUrl().setTransformation(CLDTransformation().setNamed(["blip"])).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/t_blip/test")
    }

    func testTransformationArray() {
        let url = sut?.createUrl().setTransformation(CLDTransformation().setNamed(["blip", "blop"])).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/t_blip.blop/test")
    }

    func testBaseTransformations() {
        let url = sut?.createUrl().setTransformation(CLDTransformation().setX(100).setY(100).setCrop(.fill).chain().setCrop(.crop).setWidth(100)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_fill,x_100,y_100/c_crop,w_100/test")
    }
    
    func testContextMetadataToUserVariables() {
        let url = sut?.createUrl().setTransformation(CLDTransformation()
                                                        .setVariable(CLDVariable(name: "$xpos", value: "ctx:!x_pos!_to_f"))
                                                        .setVariable(CLDVariable(name: "$ypos", value: "ctx:!y_pos!_to_f"))
                                                        .setCrop("crop")
                                                        .setX("$xpos * w")
                                                        .setY("$ypos * h")).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/$xpos_ctx:!x_pos!_to_f,$ypos_ctx:!y_pos!_to_f,c_crop,x_$xpos_mul_w,y_$ypos_mul_h/test")
    }

    func testBaseTransformationArray() {
        let url = sut?.createUrl().setTransformation(CLDTransformation().setX(100).setY(100).setWidth(200).setCrop(.fill).chain().setRadius(10).chain().setCrop(.crop).setWidth(100)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_fill,w_200,x_100,y_100/r_10/c_crop,w_100/test")
    }
    
    func test_CLDTransformation_setCrop_validUrl() {
        var url : String?
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.fill)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_fill/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.crop)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_crop/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.scale)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_scale/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.fit)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_fit/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.limit)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_limit/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.mFit)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_mfit/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.lFill)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_lfill/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.pad)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_pad/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.lPad)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_lpad/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.mPad)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_mpad/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.thumb)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_thumb/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.imaggaCrop)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_imagga_crop/test")
        
        url = sut?.createUrl().setTransformation(CLDTransformation().setCrop(.imaggaScale)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_imagga_scale/test")
    }

    func testNoEmptyTransformation() {
        let url = sut?.createUrl().setTransformation(CLDTransformation().setX(100).setY(100).setCrop(.fill).chain()).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_fill,x_100,y_100/test")
    }

    func testType() {
        let url = sut?.createUrl().setType(.facebook).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/facebook/test")
    }

    func testResourceType() {
        let url = sut?.createUrl().setResourceType(.raw).generate("test")
        XCTAssertEqual(url, "\(prefix)/raw/upload/test")
    }

    func testFetch() {
        let url = sut?.createUrl().setType(.fetch).generate("http://blah.com/hello?a=b")
        XCTAssertEqual(url, "\(prefix)/image/fetch/http://blah.com/hello%3Fa%3Db")
    }

    func testCname() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", cname: "hello.com", analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "http://hello.com/test123/image/upload/test")
    }

    func testCnameSubdomain() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", cdnSubdomain: true, cname: "hello.com", analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().generate("test")
        XCTAssertEqual(url, "http://a2.hello.com/test123/image/upload/test")
    }

    func testUrlSuffixShared() {
        XCTAssertNil(sut?.createUrl().setSuffix("hello").generate("test"))
    }

    func testUrlSuffixNonUpload() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        sut = CLDCloudinary(configuration: config)
        XCTAssertNil(sut?.createUrl().setType(.facebook).setSuffix("hello").generate("test"))
    }

    func testUrlSuffixDisallowedChars() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        sut = CLDCloudinary(configuration: config)
        XCTAssertNil(sut?.createUrl().setSuffix("hello/world").generate("test"))
        XCTAssertNil(sut?.createUrl().setSuffix("hello.world").generate("test"))
    }

    func testUrlSuffixPrivateCdn() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        XCTAssertEqual(sut?.createUrl().setSuffix("hello").generate("test"), "http://test123-res.cloudinary.com/images/test/hello")
        XCTAssertEqual(sut?.createUrl().setSuffix("hello").setTransformation(CLDTransformation().setAngle(0)).generate("test"), "http://test123-res.cloudinary.com/images/a_0/test/hello")
    }

    func testUrlSuffixFormat() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        XCTAssertEqual(sut?.createUrl().setSuffix("hello").setFormat("jpg").generate("test"), "http://test123-res.cloudinary.com/images/test/hello.jpg")
    }

    func testUrlSuffixSign() {
        var url1 = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
        var sig1 = url1?.components(separatedBy: "--")[1]

        var config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        sut = CLDCloudinary(configuration: config)
        var url2 = sut?.createUrl().setSuffix("hello").setFormat("jpg").generate("test", signUrl: true)
        var sig2 = url2?.components(separatedBy: "--")[1]

        XCTAssertEqual(sig1, sig2)

        url1 = sut?.createUrl().setFormat("jpg").setTransformation(CLDTransformation().setAngle(0)).generate("test", signUrl: true)
        sig1 = url1?.components(separatedBy: "--")[1]

        config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        sut = CLDCloudinary(configuration: config)
        url2 = sut?.createUrl().setSuffix("hello").setFormat("jpg").setTransformation(CLDTransformation().setAngle(0)).generate("test", signUrl: true)
        sig2 = url2?.components(separatedBy: "--")[1]

        XCTAssertEqual(sig1, sig2)
    }

    func testUrlSuffixRaw() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        XCTAssertEqual(sut?.createUrl().setSuffix("hello").setResourceType(.raw).generate("test"), "http://test123-res.cloudinary.com/files/test/hello")
    }

    func testUrlSuffixPrivate() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        XCTAssertEqual(sut?.createUrl().setSuffix("hello").setResourceType(.image).setType(.private).generate("test"), "http://test123-res.cloudinary.com/private_images/test/hello")
    }
    
    // MARK: - long url signature
    func test_longUrlSign_emptyApiSecret_shouldCreateExpectedSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "", privateCdn: true, longUrlSignature: true)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "DUB-5kBqEhbyNmZ0oan_cTYdW-9HAh-O"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 32, "encrypted component should not be longer than 32 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for longUrlSignature and call for signUrl = true, should encrypt the ApiSecret with SHA256_base64")
    }
    func test_longUrlSign_normalApiSecret_shouldCreateExpectedSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true, longUrlSignature: true)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "UHH8qJ2eIEoPHdVQP08BMEN9f4YUDavr"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 32, "encrypted component should not be longer than 32 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for longUrlSignature and call for signUrl = true, should encrypt the ApiSecret with SHA256_base64")
    }
    func test_longUrlSign_longApiSecret_shouldCreateExpectedSigning() {
        
        // Given
        let longString = "abcdefghijklmnopqrstuvwxyz1abcdefghijklmnopqrstuvwxyz2abcdefghijklmnopqrstuvwxyz3abcdefghijklmnopqrstuvwxyz4abcdefghijklmnopqrstuvwxyz5abcdefghijklmnopqrstuvwxyz6"
        let config = CLDConfiguration(cloudName: "test123", apiSecret: longString, privateCdn: true, longUrlSignature: true)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "7k8KYHY20iQ6sNTJIWb05ti7bYo1HG3R"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 32, "encrypted component should not be longer than 32 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for longUrlSignature and call for signUrl = true, should encrypt the ApiSecret with SHA256_base64")
    }
    func test_longUrlSign_specialApiSecret_shouldCreateExpectedSigning() {
        
        // Given
        let longString = "🔭!@#$%^&*()_+±§?><`~"
        let config = CLDConfiguration(cloudName: "test123", apiSecret: longString, privateCdn: true, longUrlSignature: true)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "g12ptQdGPID3Un4aOxZSuiEithIdT2Wm"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 32, "encrypted component should not be longer than 32 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for longUrlSignature and call for signUrl = true, should encrypt the ApiSecret with SHA256_base64")
    }
    func test_longUrlSign_unset_shouldCreateExpectedSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "FhXe8ZZ3"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 8, "short encrypted component should not be longer than 8 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for longUrlSignature = false and call for signUrl = true, should encrypt the ApiSecret with SHA1_base64")
    }
    func test_longUrlSign_signUrlFalse_shouldNotUseSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true, longUrlSignature: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: false)
         
        let expectedResult = "http://test123-res.cloudinary.com/image/upload/test.jpg"
        
        // When
        let actualResult = url!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for longUrlSignature = true and call for signUrl = false, should not encrypt and add the ApiSecret to the url")
    }
    func test_longUrlSign_unset_shouldCreateExpectedUrl() {
        
        // Given
        let url = sut?.createUrl().generate("sample.jpg", signUrl: true)
         
        let expectedResult = "https://res.cloudinary.com/test123/image/upload/s--v2fTPYTu--/sample.jpg"
        
        // When
        let actualResult = url!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for longUrlSignature = false and signUrl = true, should create a url with SHA1 encrypted apiSecret")
    }
    func test_longUrlSign_true_shouldCreateExpectedUrl() {
        
        // Given
        let longUrlSignatureQuery = ("?analytics=false&\(CLDConfiguration.ConfigParam.LongUrlSignature.description)=true")
        let urlCredentials        = "cloudinary://a:b@test123"
        let fullUrl               = urlCredentials + longUrlSignatureQuery
        
        let config = CLDConfiguration(cloudinaryUrl: fullUrl)
        sut = CLDCloudinary(configuration: config!)
        let url = sut?.createUrl().generate("sample.jpg", signUrl: true)
         
        let expectedResult = "https://res.cloudinary.com/test123/image/upload/s--2hbrSMPOjj5BJ4xV7SgFbRDevFaQNUFf--/sample.jpg"
        
        // When
        let actualResult = url!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for longUrlSignature = true and signUrl = true, should create a url with SHA256 encrypted apiSecret")
    }

    // MARK: - signature algorithm
    func test_signatureAlgorithm_emptyApiSecret_shouldCreateExpectedSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "", privateCdn: true, signatureAlgorithm: .sha256)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "DUB-5kBq"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 8, "encrypted component should not be longer than 8 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = true, should ecrypte with SHA256_base64")
    }
    func test_signatureAlgorithm_normalApiSecret_shouldCreateExpectedSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true, signatureAlgorithm: .sha256)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "UHH8qJ2e"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 8, "encrypted component should not be longer than 8 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = true, should ecrypte with SHA256_base64")
    }
    func test_signatureAlgorithm_longApiSecret_shouldCreateExpectedSigning() {
        
        // Given
        let longString = "abcdefghijklmnopqrstuvwxyz1abcdefghijklmnopqrstuvwxyz2abcdefghijklmnopqrstuvwxyz3abcdefghijklmnopqrstuvwxyz4abcdefghijklmnopqrstuvwxyz5abcdefghijklmnopqrstuvwxyz6"
        let config = CLDConfiguration(cloudName: "test123", apiSecret: longString, privateCdn: true, signatureAlgorithm: .sha256)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "7k8KYHY2"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 8, "encrypted component should not be longer than 8 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = true, should ecrypte with SHA256_base64")
    }
    func test_signatureAlgorithm_specialApiSecret_shouldCreateExpectedSigning() {
        
        // Given
        let longString = "🔭!@#$%^&*()_+±§?><`~"
        let config = CLDConfiguration(cloudName: "test123", apiSecret: longString, privateCdn: true, signatureAlgorithm: .sha256)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "g12ptQdG"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 8, "encrypted component should not be longer than 8 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = true, should ecrypte with SHA256_base64")
    }
    func test_signatureAlgorithm_unset_shouldCreateExpectedSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "FhXe8ZZ3"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 8, "encrypted component should not be longer than 8 charecters")
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration without signatureAlgorithm and call for signUrl = true, should ecrypte with the default SHA1_base64")
    }
    func test_signatureAlgorithm_signUrlFalse_shouldCreateFullUrlWithoutSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true, signatureAlgorithm: .sha256, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: false)
         
        let expectedResult = "http://test123-res.cloudinary.com/image/upload/test.jpg"
        
        // When
        let actualResult = url!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = false, should not encrypt nor add the ApiSecret to the url")
    }
    func test_signatureAlgorithm_unset_shouldCreateExpectedFullUrl() {
        
        // Given
        let url = sut?.createUrl().generate("sample.jpg", signUrl: true)
         
        let expectedResult = "https://res.cloudinary.com/test123/image/upload/s--v2fTPYTu--/sample.jpg"
        
        // When
        let actualResult = url!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for default signatureAlgorithm and signUrl = true, should create a url with SHA1 encrypted apiSecret")
    }
    func test_signatureAlgorithm_sha256_shouldCreateExpectedFullUrl() {
        
        // Given
        let signatureAlgorithmQuery = ("?analytics=false&\(CLDConfiguration.ConfigParam.SignatureAlgorithm.description)=sha256")
        let urlCredentials          = "cloudinary://a:b@test123"
        let fullUrl                 = urlCredentials + signatureAlgorithmQuery
        
        let config = CLDConfiguration(cloudinaryUrl: fullUrl)
        sut = CLDCloudinary(configuration: config!)
        let url = sut?.createUrl().generate("sample.jpg", signUrl: true)
         
        let expectedResult = "https://res.cloudinary.com/test123/image/upload/s--2hbrSMPO--/sample.jpg"
        
        // When
        let actualResult = url!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and signUrl = true, should create a url with SHA256 encrypted apiSecret")
    }
    
    // MARK: - signing combinations
    func test_signingCombinations_signTrueLongTrueAlgorithmSha1_shouldUse32CharsEcryptedSha256() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true, longUrlSignature: true, signatureAlgorithm: .sha1)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "UHH8qJ2eIEoPHdVQP08BMEN9f4YUDavr"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 32, "encrypted component should not be longer than 32 charecters")
        XCTAssertEqual(actualResult, expectedResult, "longUrlSignature should override signing algorithm and force sha256 with 32 charecters")
    }
    func test_signingCombinations_signTrueLongTrueAlgorithmSha256_shouldUse32CharsEcryptedSha256() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true, longUrlSignature: true, signatureAlgorithm: .sha1)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: true)
         
        let expectedResult = "UHH8qJ2eIEoPHdVQP08BMEN9f4YUDavr"
        
        // When
        let actualResult = url!.components(separatedBy: "--")[1]
        
        // Then
        XCTAssertNotNil(actualResult, "encrypted component should not be nil")
        XCTAssertTrue(actualResult.count <= 32, "encrypted component should not be longer than 32 charecters")
        XCTAssertEqual(actualResult, expectedResult, "longUrlSignature should override signing algorithm and force sha256 with 32 charecters")
    }
    func test_signingCombinations_signFalseLongTrueAlgorithmSha1_shouldNotUseSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true, longUrlSignature: true, signatureAlgorithm: .sha1, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: false)
         
        let expectedResult = "http://test123-res.cloudinary.com/image/upload/test.jpg"
        
        // When
        let actualResult = url!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and longUrlSignature = true and call for signUrl = false, should not encrypt nor add the ApiSecret to the url")
    }
    func test_signingCombinations_signFalseLongTrueAlgorithmSha256_shouldUseSigning() {
        
        // Given
        let config = CLDConfiguration(cloudName: "test123", apiKey: "apiKey", apiSecret: "apiSecret", privateCdn: true, longUrlSignature: true, signatureAlgorithm: .sha256, analytics: false)
        sut = CLDCloudinary(configuration: config)
        let url = sut?.createUrl().setFormat("jpg").generate("test", signUrl: false)
         
        let expectedResult = "http://test123-res.cloudinary.com/image/upload/test.jpg"
        
        // When
        let actualResult = url!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and longUrlSignature = true and call for signUrl = false, should not encrypt nor add the ApiSecret to the url")
    }
    
    // MARK: - root path
    func testUseRootPathShared() {
        XCTAssertEqual(sut?.createUrl().setUseRootPath(true).generate("test"), "\(prefix)/test")
        XCTAssertEqual(sut?.createUrl().setUseRootPath(true).setTransformation(CLDTransformation().setAngle(0)).generate("test"), "\(prefix)/a_0/test")
    }

    func testUseRootPathNonImageUpload() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        sut = CLDCloudinary(configuration: config)
        XCTAssertNil(sut?.createUrl().setUseRootPath(true).setType(.facebook).generate("test"))
        XCTAssertNil(sut?.createUrl().setUseRootPath(true).setResourceType(.raw).generate("test"))
    }

    func testUseRootPathPrivateCdn() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        XCTAssertEqual(sut?.createUrl().setUseRootPath(true).generate("test"), "http://test123-res.cloudinary.com/test")
        XCTAssertEqual(sut?.createUrl().setUseRootPath(true).setTransformation(CLDTransformation().setAngle(0)).generate("test"), "http://test123-res.cloudinary.com/a_0/test")
    }

    func testUseRootPathUrlSuffixPrivateCdn() {

        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, analytics: false)
        sut = CLDCloudinary(configuration: config)
        XCTAssertEqual(sut?.createUrl().setUseRootPath(true).setSuffix("hello").generate("test"), "http://test123-res.cloudinary.com/test/hello")
    }

    func testHttpEscape() {

        XCTAssertEqual(sut?.createUrl().setType("youtube").generate("http://www.youtube.com/watch?v=d9NF2edxy-M"), "\(prefix)/image/youtube/http://www.youtube.com/watch%3Fv%3Dd9NF2edxy-M")
    }

    func testDoubleSlash() {

        XCTAssertEqual(sut?.createUrl().setType("youtube").generate("http://cloudinary.com//images//logo.png"), "\(prefix)/image/youtube/http://cloudinary.com/images/logo.png")
    }

    func testBackground() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setBackground("red")).generate("test"), "\(prefix)/image/upload/b_red/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setBackground("#112233")).generate("test"), "\(prefix)/image/upload/b_rgb:112233/test")
    }

    func testKeyframeInterval() {
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval(interval: 10)).generate("test"), "\(prefix)/image/upload/ki_10.0/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval(interval: 0.05)).generate("test"), "\(prefix)/image/upload/ki_0.05/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval(interval: 3.45)).generate("test"), "\(prefix)/image/upload/ki_3.45/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval(interval: 300)).generate("test"), "\(prefix)/image/upload/ki_300.0/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval("10")).generate("test"), "\(prefix)/image/upload/ki_10/test")
    }

    func testDefaultImage() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setDefaultImage("default")).generate("test"), "\(prefix)/image/upload/d_default/test")
    }

    func testAngle() {
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setAngle(12)).generate("test"), "\(prefix)/image/upload/a_12/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setAngle(["exif", "12"])).generate("test"), "\(prefix)/image/upload/a_exif.12/test")
    }

    func testOverlay() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlay("text:hello")).generate("test"), "\(prefix)/image/upload/l_text:hello/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlay("text:hello").setWidth(100).setHeight(100)).generate("test"), "\(prefix)/image/upload/h_100,l_text:hello,w_100/test")
    }

    func testUnderlay() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setUnderlay("text:hello")).generate("test"), "\(prefix)/image/upload/u_text:hello/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setUnderlay("text:hello").setWidth(100).setHeight(100)).generate("test"), "\(prefix)/image/upload/h_100,u_text:hello,w_100/test")
    }

    func testFetchFormat() {

        XCTAssertEqual(sut?.createUrl().setType(.fetch).setFormat("jpg").generate("http://cloudinary.com/images/logo.png"), "\(prefix)/image/fetch/f_jpg/http://cloudinary.com/images/logo.png")
    }

    func testEffect() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.sepia)).generate("test"), "\(prefix)/image/upload/e_sepia/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.hue)).generate("test"), "\(prefix)/image/upload/e_hue/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.red)).generate("test"), "\(prefix)/image/upload/e_red/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.green)).generate("test"), "\(prefix)/image/upload/e_green/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.blue)).generate("test"), "\(prefix)/image/upload/e_blue/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.negate)).generate("test"), "\(prefix)/image/upload/e_negate/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.brightness)).generate("test"), "\(prefix)/image/upload/e_brightness/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.sepia)).generate("test"), "\(prefix)/image/upload/e_sepia/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.grayscale)).generate("test"), "\(prefix)/image/upload/e_grayscale/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.blackwhite)).generate("test"), "\(prefix)/image/upload/e_blackwhite/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.saturation)).generate("test"), "\(prefix)/image/upload/e_saturation/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.colorize)).generate("test"), "\(prefix)/image/upload/e_colorize/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.contrast)).generate("test"), "\(prefix)/image/upload/e_contrast/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.autoContrast)).generate("test"), "\(prefix)/image/upload/e_auto_contrast/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.vibrance)).generate("test"), "\(prefix)/image/upload/e_vibrance/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.autoColor)).generate("test"), "\(prefix)/image/upload/e_auto_color/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.improve)).generate("test"), "\(prefix)/image/upload/e_improve/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.autoBrightness)).generate("test"), "\(prefix)/image/upload/e_auto_brightness/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.fillLight)).generate("test"), "\(prefix)/image/upload/e_fill_light/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.viesusCorrect)).generate("test"), "\(prefix)/image/upload/e_viesus_correct/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.gamma)).generate("test"), "\(prefix)/image/upload/e_gamma/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.screen)).generate("test"), "\(prefix)/image/upload/e_screen/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.multiply)).generate("test"), "\(prefix)/image/upload/e_multiply/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.overlay)).generate("test"), "\(prefix)/image/upload/e_overlay/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.makeTransparent)).generate("test"), "\(prefix)/image/upload/e_make_transparent/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.trim)).generate("test"), "\(prefix)/image/upload/e_trim/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.shadow)).generate("test"), "\(prefix)/image/upload/e_shadow/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.distort)).generate("test"), "\(prefix)/image/upload/e_distort/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.shear)).generate("test"), "\(prefix)/image/upload/e_shear/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.displace)).generate("test"), "\(prefix)/image/upload/e_displace/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.oilPaint)).generate("test"), "\(prefix)/image/upload/e_oil_paint/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.redeye)).generate("test"), "\(prefix)/image/upload/e_redeye/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.advRedeye)).generate("test"), "\(prefix)/image/upload/e_adv_redeye/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.vignette)).generate("test"), "\(prefix)/image/upload/e_vignette/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.gradientFade)).generate("test"), "\(prefix)/image/upload/e_gradient_fade/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.pixelate)).generate("test"), "\(prefix)/image/upload/e_pixelate/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.pixelateRegion)).generate("test"), "\(prefix)/image/upload/e_pixelate_region/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.pixelateFaces)).generate("test"), "\(prefix)/image/upload/e_pixelate_faces/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.blur)).generate("test"), "\(prefix)/image/upload/e_blur/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.blurRegion)).generate("test"), "\(prefix)/image/upload/e_blur_region/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.blurFaces)).generate("test"), "\(prefix)/image/upload/e_blur_faces/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.sharpen)).generate("test"), "\(prefix)/image/upload/e_sharpen/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.unsharpMask)).generate("test"), "\(prefix)/image/upload/e_unsharp_mask/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.orderedDither)).generate("test"), "\(prefix)/image/upload/e_ordered_dither/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.art)).generate("test"), "\(prefix)/image/upload/e_art/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.assistColorblind)).generate("test"), "\(prefix)/image/upload/e_assist_colorblind/test")
        XCTAssertEqual(sut?.createUrl().setResourceType(.video).setTransformation(CLDTransformation().setEffect(.preview)).generate("test"), "\(prefix)/video/upload/e_preview/test")
        XCTAssertEqual(sut?.createUrl().setResourceType(.video).setTransformation(CLDTransformation().setEffect(.preview, param: "duration_2")).generate("test"), "\(prefix)/video/upload/e_preview:duration_2/test")
    }

    func testEffectWithParam() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.sepia, param: "10")).generate("test"), "\(prefix)/image/upload/e_sepia:10/test")
    }
    
    func testArtisticEffect(){
        
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.alDente)).generate("test"), "\(prefix)/image/upload/e_art:al_dente/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.athena)).generate("test"), "\(prefix)/image/upload/e_art:athena/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.audrey)).generate("test"), "\(prefix)/image/upload/e_art:audrey/test")
        
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.aurora)).generate("test"), "\(prefix)/image/upload/e_art:aurora/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.daguerre)).generate("test"), "\(prefix)/image/upload/e_art:daguerre/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.eucalyptus)).generate("test"), "\(prefix)/image/upload/e_art:eucalyptus/test")
        
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.fes)).generate("test"), "\(prefix)/image/upload/e_art:fes/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.frost)).generate("test"), "\(prefix)/image/upload/e_art:frost/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.hairspray)).generate("test"), "\(prefix)/image/upload/e_art:hairspray/test")
        
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.hokusai)).generate("test"), "\(prefix)/image/upload/e_art:hokusai/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.incognito)).generate("test"), "\(prefix)/image/upload/e_art:incognito/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.linen)).generate("test"), "\(prefix)/image/upload/e_art:linen/test")
        
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.peacock)).generate("test"), "\(prefix)/image/upload/e_art:peacock/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.primavera)).generate("test"), "\(prefix)/image/upload/e_art:primavera/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.quartz)).generate("test"), "\(prefix)/image/upload/e_art:quartz/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.redRock)).generate("test"), "\(prefix)/image/upload/e_art:red_rock/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.refresh)).generate("test"), "\(prefix)/image/upload/e_art:refresh/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.sizzle)).generate("test"), "\(prefix)/image/upload/e_art:sizzle/test")
        
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.sonnet)).generate("test"), "\(prefix)/image/upload/e_art:sonnet/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.ukulele)).generate("test"), "\(prefix)/image/upload/e_art:ukulele/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setEffect(.zorro)).generate("test"), "\(prefix)/image/upload/e_art:zorro/test")
    }

    func testDensity() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setDensity(150)).generate("test"), "\(prefix)/image/upload/dn_150/test")
    }

    func testPage() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setPage(5)).generate("test"), "\(prefix)/image/upload/pg_5/test")
    }

    func testBorder() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setBorder(5, color: "black")).generate("test"), "\(prefix)/image/upload/bo_5px_solid_black/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setBorder(5, color: "#ffaabbdd")).generate("test"), "\(prefix)/image/upload/bo_5px_solid_rgb:ffaabbdd/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setBorder("1px_solid_blue")).generate("test"), "\(prefix)/image/upload/bo_1px_solid_blue/test")
    }

    func testFlags() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setFlags(["abc"])).generate("test"), "\(prefix)/image/upload/fl_abc/test")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setFlags(["abc", "def"])).generate("test"), "\(prefix)/image/upload/fl_abc.def/test")
    }

    func testDprFloat() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setDpr(2.0)).generate("test"), "\(prefix)/image/upload/dpr_2.0/test")
    }

    func testDprAuto() {
        let url = sut?.createUrl().setTransformation(CLDTransformation().setDprAuto()).generate("test")
        var dprValue = ""
        if let finalUrl = url, let range = finalUrl.range(of: "dpr_") {
            let startIndex = range.upperBound
            dprValue = String(finalUrl[startIndex..<(finalUrl.index(startIndex, offsetBy: 1))])
        }

        if !dprValue.isEmpty {
            XCTAssert(Int(dprValue) != nil, "DPR value should be transformed to Int value")
        } else {
            XCTFail("should find DPR Value")
        }
    }

    func testAspectRatio() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setAspectRatio(2.0)).generate("test"), "\(prefix)/image/upload/ar_2.0/test")
    }

    func testSignature() {
        let sig = cloudinarySignParamsUsingSecret(["a": "b", "c": "d", "e": ""], cloudinaryApiSecret: "abcd")
        XCTAssertEqual(sig, "ef1f04e0c1af08208a3dd28483107bc7f4a61209")
    }

    func testFolders() {

        XCTAssertEqual(sut?.createUrl().generate("folder/test"), "\(prefix)/image/upload/v1/folder/test")
        XCTAssertEqual(sut?.createUrl().setVersion("123").generate("folder/test"), "\(prefix)/image/upload/v123/folder/test")
    }
    
    func testFoldersWithForceVersion(){
        // should not add version if the user turned off forceVersion
        var result = sut?.createUrl().setForceVersion(false).generate("folder/test")
        XCTAssertEqual("\(prefix)/image/upload/folder/test", result)
        
        // should still show explicit version if passed by the user
        result = sut?.createUrl().setForceVersion(false).setVersion("1234").generate("folder/test")
        XCTAssertEqual("\(prefix)/image/upload/v1234/folder/test", result)
        
        // should add version if no value specified for forceVersion:
        result = sut?.createUrl().generate("folder/test")
        XCTAssertEqual("\(prefix)/image/upload/v1/folder/test", result)
        
        // should add version if forceVersion is true
        result = sut?.createUrl().setForceVersion(true).generate("folder/test");
        XCTAssertEqual("\(prefix)/image/upload/v1/folder/test", result)
        
        // should not use v1 if explicit version is passed
        result = sut?.createUrl().setForceVersion(true).setVersion("1234").generate("folder/test");
        XCTAssertEqual("\(prefix)/image/upload/v1234/folder/test", result)
    }

    func testFoldersWithVersion() {

        XCTAssertEqual(sut?.createUrl().generate("v1234/test"), "\(prefix)/image/upload/v1234/test")
    }

    func testShorten() {

        XCTAssertEqual(sut?.createUrl().setShortenUrl(true).generate("test"), "\(prefix)/iu/test")
    }

    func testSignUrls() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setWidth(10).setHeight(20).setCrop(.crop)).setVersion("1234").generate("image.jpg", signUrl: true), "\(prefix)/image/upload/s--Ai4Znfl3--/c_crop,h_20,w_10/v1234/image.jpg")
    }

    func testEscapePublicId() {

        let tests = ["a b": "a%20b", "a+b": "a%2Bb", "a%20b": "a%20b", "a-b": "a-b", "a??b": "a%3F%3Fb"]
        for key in tests.keys {
            XCTAssertEqual(sut?.createUrl().generate(key), "\(prefix)/image/upload/\(tests[key]!)")
        }
    }

    func testPreloadedImage() {

        XCTAssertEqual(sut?.createUrl().generate("raw/private/v1234567/document.docx"), "\(prefix)/raw/private/v1234567/document.docx")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setWidth(1.1).setCrop(.scale)).generate("image/private/v1234567/img.jpg"), "\(prefix)/image/private/c_scale,w_1.1/v1234567/img.jpg")
    }

    func testGravity() {
        testGravityUrl(CLDTransformation.CLDGravity.center, "c_crop,g_center,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.auto, "c_crop,g_auto,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.face, "c_crop,g_face,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.faceCenter, "c_crop,g_face:center,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.faces, "c_crop,g_faces,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.facesCenter, "c_crop,g_faces:center,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.advFace, "c_crop,g_adv_face,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.advFaces, "c_crop,g_adv_faces,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.advEyes, "c_crop,g_adv_eyes,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.north, "c_crop,g_north,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.northWest, "c_crop,g_north_west,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.northEast, "c_crop,g_north_east,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.south, "c_crop,g_south,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.southWest, "c_crop,g_south_west,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.southEast, "c_crop,g_south_east,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.west, "c_crop,g_west,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.east, "c_crop,g_east,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.xyCenter, "c_crop,g_xy_center,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.custom, "c_crop,g_custom,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.customFace, "c_crop,g_custom:face,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.customFaces, "c_crop,g_custom:faces,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.customAdvFace, "c_crop,g_custom:adv_face,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.customAdvFaces, "c_crop,g_custom:adv_faces,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.autoOcrText, "c_crop,g_auto:ocr_text,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.ocrText, "c_crop,g_ocr_text,w_100")
        testGravityUrl(CLDTransformation.CLDGravity.ocrTextAdvOcr, "c_crop,g_ocr_text:adv_ocr,w_100")
    }

    fileprivate func testGravityUrl(_ gravity: CLDTransformation.CLDGravity, _ expected: String) {
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setWidth(100).setCrop(CLDTransformation.CLDCrop.crop).setGravity(gravity)).generate("public_id"),
                "\(prefix)/image/upload/\(expected)/public_id","Creating url with gravity enum should return expected result")
    }

    func testVideoCodec() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoCodec("auto")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vc_auto/video_id")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoCodecAndProfileAndLevel("h264", videoProfile: "basic", level: "3.1")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vc_h264:basic:3.1/video_id")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoCodecAndProfileAndLevel("h264", videoProfile: "basic", level: nil)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vc_h264:basic/video_id")
    }

    func testVideoCodecBFrameTrueOrNil() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoCodecAndProfileAndLevelAndBFrames("h264", videoProfile: "basic", level: "3.1", bframes: true)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vc_h264:basic:3.1/video_id")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoCodecAndProfileAndLevelAndBFrames("h264", videoProfile: "basic", level: "3.1", bframes: nil)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vc_h264:basic:3.1/video_id")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoCodecAndProfileAndLevelAndBFrames("h264", videoProfile: "basic", level: "3.1")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vc_h264:basic:3.1/video_id")
    }

    func testVideoCodecBFrameFalse() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoCodecAndProfileAndLevelAndBFrames("h264", videoProfile: "basic", level: "3.1", bframes: false)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vc_h264:basic:3.1:bframes_no/video_id")
    }

    func testAudioCodec() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setAudioCodec("acc")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/ac_acc/video_id")
    }

    func testBitRate() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setBitRate("1m")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/br_1m/video_id")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setBitRate(2048)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/br_2048/video_id")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setBitRate(kb: 44)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/br_44k/video_id")
    }

    func testAudioFrequency() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setAudioFrequency("44100")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/af_44100/video_id")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setAudioFrequency(44100)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/af_44100/video_id")
    }

    func testVideoSampling() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoSampling("20")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vs_20/video_id")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoSampling(frames: 20)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vs_20/video_id")
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setVideoSampling(delay: 2.3)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vs_2.3s/video_id")
    }

    func testOverlayOptions() {

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "logo"))).generate("test"), "\(prefix)/image/upload/l_logo/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "logo").setType(.private))).generate("test"), "\(prefix)/image/upload/l_private:logo/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "logo").setFormat(format: "png"))).generate("test"), "\(prefix)/image/upload/l_logo.png/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "folder/logo"))).generate("test"), "\(prefix)/image/upload/l_folder:logo/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "cat").setResourceType(.video))).generate("test"), "\(prefix)/image/upload/l_video:cat/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDTextLayer().setText(text: "Hello/World").setFontFamily(fontFamily: "Arial").setFontSize(18))).generate("test"), "\(prefix)/image/upload/l_text:Arial_18:Hello%252FWorld/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDTextLayer().setText(text: "Hello World, Nice to meet you?").setFontFamily(fontFamily: "Arial").setFontSize(18))).generate("test"), "\(prefix)/image/upload/l_text:Arial_18:Hello%20World%252C%20Nice%20to%20meet%20you%3F/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDTextLayer().setText(text: "Hello World, Nice to meet you?").setFontFamily(fontFamily: "Arial").setFontSize(18).setFontStyle(.italic).setFontWeight(.bold).setLetterSpacing(4))).generate("test"), "\(prefix)/image/upload/l_text:Arial_18_bold_italic_letter_spacing_4:Hello%20World%252C%20Nice%20to%20meet%20you%3F/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDSubtitlesLayer().setPublicId(publicId: "sample_sub_en.srt"))).generate("test"), "\(prefix)/image/upload/l_subtitles:sample_sub_en.srt/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDSubtitlesLayer().setFontFamily(fontFamily: "Arial").setFontSize(40).setPublicId(publicId: "sample_sub_he.srt"))).generate("test"), "\(prefix)/image/upload/l_subtitles:Arial_40:sample_sub_he.srt/test")
        
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDSubtitlesLayer().setFontFamily(fontFamily:"Arial").setFontSize(40).setFontAntialiasing(CLDTextLayer.CLDFontAntialiasing.FAST)
            .setFontHinting(CLDTextLayer.CLDFontHinting.MEDIUM).setPublicId(publicId: "sample_sub_he.srt"))).generate("test"), "\(prefix)/image/upload/l_subtitles:Arial_40_antialias_fast_hinting_medium:sample_sub_he.srt/test")

        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDSubtitlesLayer().setFontFamily(fontFamily:"Arial").setFontSize(40).setFontAntialiasing("fast")
            .setFontHinting("medium").setPublicId(publicId: "sample_sub_he.srt"))).generate("test"), "\(prefix)/image/upload/l_subtitles:Arial_40_antialias_fast_hinting_medium:sample_sub_he.srt/test")
        
        XCTAssertEqual(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDFetchLayer(url: "https://res.cloudinary.com/demo/image/upload/sample"))).generate("test"),
                       "\(prefix)/image/upload/l_fetch:aHR0cHM6Ly9yZXMuY2xvdWRpbmFyeS5jb20vZGVtby9pbWFnZS91cGxvYWQvc2FtcGxl/test")
    }

    func testOverlayErrors() {
        XCTAssertNil(sut?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDTextLayer().setText(text: "text").setFontStyle(.italic))).generate("test"))

        XCTAssertNil(sut?.createUrl().setTransformation(CLDTransformation().setUnderlayWithLayer(CLDLayer().setResourceType(.video))).generate("test"))
    }
    // MARK: - fsp
    func testFps(){
        XCTAssertEqual(CLDTransformation().setFps("24-29.97").asString() ,"fps_24-29.97")
        XCTAssertEqual(CLDTransformation().setFps(24).asString() ,"fps_24")
        XCTAssertEqual(CLDTransformation().setFps(24.5).asString() ,"fps_24.5")
        XCTAssertEqual(CLDTransformation().setFps("24").asString() ,"fps_24")
        XCTAssertEqual(CLDTransformation().setFps("-24").asString() ,"fps_-24")
        XCTAssertEqual(CLDTransformation().setFps(.range (start: 24, end: 29.97)).asString() ,"fps_24-29.97")
        XCTAssertEqual(CLDTransformation().setFps(.range (start: "24", end: "29.97")).asString() ,"fps_24-29.97")
        XCTAssertEqual(CLDTransformation().setFps(.range (start: 24)).asString() ,"fps_24-")
        XCTAssertEqual(CLDTransformation().setFps(.range (end: 29.97)).asString() ,"fps_-29.97")
        XCTAssertEqual(CLDTransformation().setFps(.range (start: "24")).asString() ,"fps_24-")
        XCTAssertEqual(CLDTransformation().setFps(.range (end: "29.97")).asString() ,"fps_-29.97")
    }
    
    func testEagerWithStreamingProfile(){
        XCTAssertEqual(CLDEagerTransformation().setFormat("m3u8").setStreamingProfile("full_hd").asString(), "sp_full_hd/m3u8")
    }
    
    func testInitialHeightWidth() {
        XCTAssertEqual(CLDTransformation().setWidth("iw").setHeight("ih").setCrop(.crop).asString() ,"c_crop,h_ih,w_iw")
    }
    
    func testOffset(){
        XCTAssertEqual(CLDTransformation().setStartOffset("auto").asString(), "so_auto")
    }
    
    // MARK: - named spaces removal
    func test_replaceSpaces_named_shouldCreateExpectedUrl() {
        
        // Given
        let input = "name"
        
        let expectedResult = "https://res.cloudinary.com/test123/image/upload/h_101,t_name,w_100/test"
        
        // When
        let transformation = CLDTransformation().setWidth(100).setHeight(101).setNamed(input)
        let actualResult   = sut?.createUrl().setTransformation(transformation).generate("test")
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "creating url with named in transformation should return the expected result")
    }
    func test_replaceSpaces_namedWithSpaces_shouldReplaceSpaces() {
        
        // Given
        let input = "name with spaces"
        
        let expectedResult = "https://res.cloudinary.com/test123/image/upload/h_101,t_name%20with%20spaces,w_100/test"
        
        // When
        let transformation = CLDTransformation().setWidth(100).setHeight(101).setNamed(input)
        let actualResult   = sut?.createUrl().setTransformation(transformation).generate("test")
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "creating url with named in transformation should return the expected result")
    }
    func test_replaceSpaces_namedArray_shouldCreateExpectedUrl() {
        
        // Given
        let input1 = "name1"
        let input2 = "name2"
        
        let expectedResult = "https://res.cloudinary.com/test123/image/upload/h_101,t_name1.name2,w_100/test"
        
        // When
        let transformation = CLDTransformation().setWidth(100).setHeight(101).setNamed([input1, input2])
        let actualResult   = sut?.createUrl().setTransformation(transformation).generate("test")
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "creating url with named in transformation should return the expected result")
    }
    func test_replaceSpaces_namedArrayWithSpaces_shouldReplaceSpaces() {
        
        // Given
        let input1 = "named with spaces 1"
        let input2 = "named with spaces 2"
        
        let expectedResult = "https://res.cloudinary.com/test123/image/upload/h_101,t_named%20with%20spaces%201.named%20with%20spaces%202,w_100/test"
        
        // When
        let transformation = CLDTransformation().setWidth(100).setHeight(101).setNamed([input1, input2])
        let actualResult   = sut?.createUrl().setTransformation(transformation).generate("test")
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "creating url with named in transformation should return the expected result")
    }
}


