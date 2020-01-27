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

class UrlTests: XCTestCase {
    let prefix = "https://res.cloudinary.com/test123"

    var cloudinary: CLDCloudinary?

    override func setUp() {
        super.setUp()
        let config = CLDConfiguration(cloudinaryUrl: "cloudinary://a:b@test123")!
        cloudinary = CLDCloudinary(configuration: config)
    }

    override func tearDown() {
        super.tearDown()
        cloudinary = nil
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
        let url = cloudinary?.createUrl().generate("test")
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
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", secure: true)
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/test")
    }

    func testSecureDistribution() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", secure: true, secureDistribution: "something.else.com")
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "https://something.else.com/test123/image/upload/test")
    }

    func testSecureAkamai() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, secure: true)
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "https://test123-res.cloudinary.com/image/upload/test")
    }

    func testSecureNonAkamai() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, secure: true, secureDistribution: "something.cloudfront.net")
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "https://something.cloudfront.net/image/upload/test")
    }

    func testHttpPrivateCdn() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "http://test123-res.cloudinary.com/image/upload/test")
    }

    func testCdnSubDomain() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", cdnSubdomain: true)
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "http://res-2.cloudinary.com/test123/image/upload/test")
    }

    func testSecureCdnSubDomainFalse() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", secure: true, cdnSubdomain: true)
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/test")
    }

    func testSecureCdnSubDomainTrue() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true, secure: true, cdnSubdomain: true, secureCdnSubdomain: true)
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "https://test123-res-2.cloudinary.com/image/upload/test")
    }

    func testFormat() {
        let url = cloudinary?.createUrl().setFormat("jpg").generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/test.jpg")
    }

    func testCrop() {
        let trans = CLDTransformation().setWidth(100).setHeight(101)
        var url = cloudinary?.createUrl().setTransformation(trans).generate("test")

        url = cloudinary?.createUrl().setTransformation(CLDTransformation().setWidth(100).setHeight(101).setCrop(.crop)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_crop,h_101,w_100/test")
    }

    func testVariousOptions() {
        let url = cloudinary?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality("0.4").setPrefix("a")).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/g_center,p_a,q_0.4,r_3,x_1,y_2/test")
    }

    func testQuality() {
        let urlAuto = cloudinary?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality(.auto()).setPrefix("a")).generate("test")
        XCTAssertEqual(urlAuto, "\(prefix)/image/upload/g_center,p_a,q_auto,r_3,x_1,y_2/test")

        let urlEco = cloudinary?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality(.auto(.eco)).setPrefix("a")).generate("test")
        XCTAssertEqual(urlEco, "\(prefix)/image/upload/g_center,p_a,q_auto:eco,r_3,x_1,y_2/test")

        let urlFixed = cloudinary?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality(.fixed(50)).setPrefix("a")).generate("test")
        XCTAssertEqual(urlFixed, "\(prefix)/image/upload/g_center,p_a,q_50,r_3,x_1,y_2/test")

        let urlJpegMini = cloudinary?.createUrl().setTransformation(CLDTransformation().setX(1).setY(2).setRadius(3).setGravity(.center).setQuality(.jpegMini()).setPrefix("a")).generate("test")
        XCTAssertEqual(urlJpegMini, "\(prefix)/image/upload/g_center,p_a,q_jpegmini,r_3,x_1,y_2/test")
    }

    func testTransformationSimple() {
        let url = cloudinary?.createUrl().setTransformation(CLDTransformation().setNamed(["blip"])).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/t_blip/test")
    }

    func testTransformationArray() {
        let url = cloudinary?.createUrl().setTransformation(CLDTransformation().setNamed(["blip", "blop"])).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/t_blip.blop/test")
    }

    func testBaseTransformations() {
        let url = cloudinary?.createUrl().setTransformation(CLDTransformation().setX(100).setY(100).setCrop(.fill).chain().setCrop(.crop).setWidth(100)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_fill,x_100,y_100/c_crop,w_100/test")
    }

    func testBaseTransformationArray() {
        let url = cloudinary?.createUrl().setTransformation(CLDTransformation().setX(100).setY(100).setWidth(200).setCrop(.fill).chain().setRadius(10).chain().setCrop(.crop).setWidth(100)).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_fill,w_200,x_100,y_100/r_10/c_crop,w_100/test")
    }

    func testNoEmptyTransformation() {
        let url = cloudinary?.createUrl().setTransformation(CLDTransformation().setX(100).setY(100).setCrop(.fill).chain()).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/upload/c_fill,x_100,y_100/test")
    }

    func testType() {
        let url = cloudinary?.createUrl().setType(.facebook).generate("test")
        XCTAssertEqual(url, "\(prefix)/image/facebook/test")
    }

    func testResourceType() {
        let url = cloudinary?.createUrl().setResourceType(.raw).generate("test")
        XCTAssertEqual(url, "\(prefix)/raw/upload/test")
    }

    func testFetch() {
        let url = cloudinary?.createUrl().setType(.fetch).generate("http://blah.com/hello?a=b")
        XCTAssertEqual(url, "\(prefix)/image/fetch/http://blah.com/hello%3Fa%3Db")
    }

    func testCname() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", cname: "hello.com")
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "http://hello.com/test123/image/upload/test")
    }

    func testCnameSubdomain() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", cdnSubdomain: true, cname: "hello.com")
        cloudinary = CLDCloudinary(configuration: config)
        let url = cloudinary?.createUrl().generate("test")
        XCTAssertEqual(url, "http://a2.hello.com/test123/image/upload/test")
    }

    func testUrlSuffixShared() {
        XCTAssertNil(cloudinary?.createUrl().setSuffix("hello").generate("test"))
    }

    func testUrlSuffixNonUpload() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        XCTAssertNil(cloudinary?.createUrl().setType(.facebook).setSuffix("hello").generate("test"))
    }

    func testUrlSuffixDisallowedChars() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        XCTAssertNil(cloudinary?.createUrl().setSuffix("hello/world").generate("test"))
        XCTAssertNil(cloudinary?.createUrl().setSuffix("hello.world").generate("test"))
    }

    func testUrlSuffixPrivateCdn() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        XCTAssertEqual(cloudinary?.createUrl().setSuffix("hello").generate("test"), "http://test123-res.cloudinary.com/images/test/hello")
        XCTAssertEqual(cloudinary?.createUrl().setSuffix("hello").setTransformation(CLDTransformation().setAngle(0)).generate("test"), "http://test123-res.cloudinary.com/images/a_0/test/hello")
    }

    func testUrlSuffixFormat() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        XCTAssertEqual(cloudinary?.createUrl().setSuffix("hello").setFormat("jpg").generate("test"), "http://test123-res.cloudinary.com/images/test/hello.jpg")
    }

    func testUrlSuffixSign() {
        var url1 = cloudinary?.createUrl().setFormat("jpg").generate("test", signUrl: true)
        var sig1 = url1?.components(separatedBy: "--")[1]

        var config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        var url2 = cloudinary?.createUrl().setSuffix("hello").setFormat("jpg").generate("test", signUrl: true)
        var sig2 = url2?.components(separatedBy: "--")[1]

        XCTAssertEqual(sig1, sig2)

        url1 = cloudinary?.createUrl().setFormat("jpg").setTransformation(CLDTransformation().setAngle(0)).generate("test", signUrl: true)
        sig1 = url1?.components(separatedBy: "--")[1]

        config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        url2 = cloudinary?.createUrl().setSuffix("hello").setFormat("jpg").setTransformation(CLDTransformation().setAngle(0)).generate("test", signUrl: true)
        sig2 = url2?.components(separatedBy: "--")[1]

        XCTAssertEqual(sig1, sig2)
    }

    func testUrlSuffixRaw() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        XCTAssertEqual(cloudinary?.createUrl().setSuffix("hello").setResourceType(.raw).generate("test"), "http://test123-res.cloudinary.com/files/test/hello")
    }

    func testUrlSuffixPrivate() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        XCTAssertEqual(cloudinary?.createUrl().setSuffix("hello").setResourceType(.image).setType(.private).generate("test"), "http://test123-res.cloudinary.com/private_images/test/hello")
    }

    func testUseRootPathShared() {
        XCTAssertEqual(cloudinary?.createUrl().setUseRootPath(true).generate("test"), "\(prefix)/test")
        XCTAssertEqual(cloudinary?.createUrl().setUseRootPath(true).setTransformation(CLDTransformation().setAngle(0)).generate("test"), "\(prefix)/a_0/test")
    }

    func testUseRootPathNonImageUpload() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        XCTAssertNil(cloudinary?.createUrl().setUseRootPath(true).setType(.facebook).generate("test"))
        XCTAssertNil(cloudinary?.createUrl().setUseRootPath(true).setResourceType(.raw).generate("test"))
    }

    func testUseRootPathPrivateCdn() {
        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        XCTAssertEqual(cloudinary?.createUrl().setUseRootPath(true).generate("test"), "http://test123-res.cloudinary.com/test")
        XCTAssertEqual(cloudinary?.createUrl().setUseRootPath(true).setTransformation(CLDTransformation().setAngle(0)).generate("test"), "http://test123-res.cloudinary.com/a_0/test")
    }

    func testUseRootPathUrlSuffixPrivateCdn() {

        let config = CLDConfiguration(cloudName: "test123", apiKey: "a", apiSecret: "b", privateCdn: true)
        cloudinary = CLDCloudinary(configuration: config)
        XCTAssertEqual(cloudinary?.createUrl().setUseRootPath(true).setSuffix("hello").generate("test"), "http://test123-res.cloudinary.com/test/hello")
    }

    func testHttpEscape() {

        XCTAssertEqual(cloudinary?.createUrl().setType("youtube").generate("http://www.youtube.com/watch?v=d9NF2edxy-M"), "\(prefix)/image/youtube/http://www.youtube.com/watch%3Fv%3Dd9NF2edxy-M")
    }

    func testDoubleSlash() {

        XCTAssertEqual(cloudinary?.createUrl().setType("youtube").generate("http://cloudinary.com//images//logo.png"), "\(prefix)/image/youtube/http://cloudinary.com/images/logo.png")
    }

    func testBackground() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setBackground("red")).generate("test"), "\(prefix)/image/upload/b_red/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setBackground("#112233")).generate("test"), "\(prefix)/image/upload/b_rgb:112233/test")
    }

    func testKeyframeInterval() {
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval(interval: 10)).generate("test"), "\(prefix)/image/upload/ki_10.0/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval(interval: 0.05)).generate("test"), "\(prefix)/image/upload/ki_0.05/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval(interval: 3.45)).generate("test"), "\(prefix)/image/upload/ki_3.45/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval(interval: 300)).generate("test"), "\(prefix)/image/upload/ki_300.0/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setKeyframeInterval("10")).generate("test"), "\(prefix)/image/upload/ki_10/test")
    }

    func testDefaultImage() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setDefaultImage("default")).generate("test"), "\(prefix)/image/upload/d_default/test")
    }

    func testAngle() {
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setAngle(12)).generate("test"), "\(prefix)/image/upload/a_12/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setAngle(["exif", "12"])).generate("test"), "\(prefix)/image/upload/a_exif.12/test")
    }

    func testOverlay() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlay("text:hello")).generate("test"), "\(prefix)/image/upload/l_text:hello/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlay("text:hello").setWidth(100).setHeight(100)).generate("test"), "\(prefix)/image/upload/h_100,l_text:hello,w_100/test")
    }

    func testUnderlay() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setUnderlay("text:hello")).generate("test"), "\(prefix)/image/upload/u_text:hello/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setUnderlay("text:hello").setWidth(100).setHeight(100)).generate("test"), "\(prefix)/image/upload/h_100,u_text:hello,w_100/test")
    }

    func testFetchFormat() {

        XCTAssertEqual(cloudinary?.createUrl().setType(.fetch).setFormat("jpg").generate("http://cloudinary.com/images/logo.png"), "\(prefix)/image/fetch/f_jpg/http://cloudinary.com/images/logo.png")
    }

    func testEffect() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setEffect(.sepia)).generate("test"), "\(prefix)/image/upload/e_sepia/test")
    }

    func testEffectWithParam() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setEffect(.sepia, param: "10")).generate("test"), "\(prefix)/image/upload/e_sepia:10/test")
    }
    
    func testArtisticEffect(){
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setEffect(.incognito)).generate("test"), "\(prefix)/image/upload/e_art:incognito/test")
    }

    func testDensity() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setDensity(150)).generate("test"), "\(prefix)/image/upload/dn_150/test")
    }

    func testPage() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setPage(5)).generate("test"), "\(prefix)/image/upload/pg_5/test")
    }

    func testBorder() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setBorder(5, color: "black")).generate("test"), "\(prefix)/image/upload/bo_5px_solid_black/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setBorder(5, color: "#ffaabbdd")).generate("test"), "\(prefix)/image/upload/bo_5px_solid_rgb:ffaabbdd/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setBorder("1px_solid_blue")).generate("test"), "\(prefix)/image/upload/bo_1px_solid_blue/test")
    }

    func testFlags() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setFlags(["abc"])).generate("test"), "\(prefix)/image/upload/fl_abc/test")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setFlags(["abc", "def"])).generate("test"), "\(prefix)/image/upload/fl_abc.def/test")
    }

    func testDprFloat() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setDpr(2.0)).generate("test"), "\(prefix)/image/upload/dpr_2.0/test")
    }

    func testDprAuto() {
        let url = cloudinary?.createUrl().setTransformation(CLDTransformation().setDprAuto()).generate("test")
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

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setAspectRatio(2.0)).generate("test"), "\(prefix)/image/upload/ar_2.0/test")
    }

    func testSignature() {
        let sig = cloudinarySignParamsUsingSecret(["a": "b", "c": "d", "e": ""], cloudinaryApiSecret: "abcd")
        XCTAssertEqual(sig, "ef1f04e0c1af08208a3dd28483107bc7f4a61209")
    }

    func testFolders() {

        XCTAssertEqual(cloudinary?.createUrl().generate("folder/test"), "\(prefix)/image/upload/v1/folder/test")
        XCTAssertEqual(cloudinary?.createUrl().setVersion("123").generate("folder/test"), "\(prefix)/image/upload/v123/folder/test")
    }
    
    func testFoldersWithForceVersion(){
        // should not add version if the user turned off forceVersion
        var result = cloudinary?.createUrl().setForceVersion(false).generate("folder/test")
        XCTAssertEqual("\(prefix)/image/upload/folder/test", result)
        
        // should still show explicit version if passed by the user
        result = cloudinary?.createUrl().setForceVersion(false).setVersion("1234").generate("folder/test")
        XCTAssertEqual("\(prefix)/image/upload/v1234/folder/test", result)
        
        // should add version if no value specified for forceVersion:
        result = cloudinary?.createUrl().generate("folder/test")
        XCTAssertEqual("\(prefix)/image/upload/v1/folder/test", result)
        
        // should add version if forceVersion is true
        result = cloudinary?.createUrl().setForceVersion(true).generate("folder/test");
        XCTAssertEqual("\(prefix)/image/upload/v1/folder/test", result)
        
        // should not use v1 if explicit version is passed
        result = cloudinary?.createUrl().setForceVersion(true).setVersion("1234").generate("folder/test");
        XCTAssertEqual("\(prefix)/image/upload/v1234/folder/test", result)
    }

    func testFoldersWithVersion() {

        XCTAssertEqual(cloudinary?.createUrl().generate("v1234/test"), "\(prefix)/image/upload/v1234/test")
    }

    func testShorten() {

        XCTAssertEqual(cloudinary?.createUrl().setShortenUrl(true).generate("test"), "\(prefix)/iu/test")
    }

    func testSignUrls() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setWidth(10).setHeight(20).setCrop(.crop)).setVersion("1234").generate("image.jpg", signUrl: true), "\(prefix)/image/upload/s--Ai4Znfl3--/c_crop,h_20,w_10/v1234/image.jpg")
    }

    func testEscapePublicId() {

        let tests = ["a b": "a%20b", "a+b": "a%2Bb", "a%20b": "a%20b", "a-b": "a-b", "a??b": "a%3F%3Fb"]
        for key in tests.keys {
            XCTAssertEqual(cloudinary?.createUrl().generate(key), "\(prefix)/image/upload/\(tests[key]!)")
        }
    }

    func testPreloadedImage() {

        XCTAssertEqual(cloudinary?.createUrl().generate("raw/private/v1234567/document.docx"), "\(prefix)/raw/private/v1234567/document.docx")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setWidth(1.1).setCrop(.scale)).generate("image/private/v1234567/img.jpg"), "\(prefix)/image/private/c_scale,w_1.1/v1234567/img.jpg")
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
    }

    fileprivate func testGravityUrl(_ gravity: CLDTransformation.CLDGravity, _ expected: String) {
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setWidth(100).setCrop(CLDTransformation.CLDCrop.crop).setGravity(gravity)).generate("public_id"),
                "\(prefix)/image/upload/\(expected)/public_id")
    }

    func testVideoCodec() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setVideoCodec("auto")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vc_auto/video_id")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setVideoCodecAndProfileAndLevel("h264", videoProfile: "basic", level: "3.1")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vc_h264:basic:3.1/video_id")
    }

    func testAudioCodec() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setAudioCodec("acc")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/ac_acc/video_id")
    }

    func testBitRate() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setBitRate("1m")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/br_1m/video_id")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setBitRate(2048)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/br_2048/video_id")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setBitRate(kb: 44)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/br_44k/video_id")
    }

    func testAudioFrequency() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setAudioFrequency("44100")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/af_44100/video_id")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setAudioFrequency(44100)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/af_44100/video_id")
    }

    func testVideoSampling() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setVideoSampling("20")).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vs_20/video_id")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setVideoSampling(frames: 20)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vs_20/video_id")
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setVideoSampling(delay: 2.3)).setResourceType(.video).generate("video_id"), "\(prefix)/video/upload/vs_2.3s/video_id")
    }

    func testOverlayOptions() {

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "logo"))).generate("test"), "\(prefix)/image/upload/l_logo/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "logo").setType(.private))).generate("test"), "\(prefix)/image/upload/l_private:logo/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "logo").setFormat(format: "png"))).generate("test"), "\(prefix)/image/upload/l_logo.png/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "folder/logo"))).generate("test"), "\(prefix)/image/upload/l_folder:logo/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "cat").setResourceType(.video))).generate("test"), "\(prefix)/image/upload/l_video:cat/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDTextLayer().setText(text: "Hello/World").setFontFamily(fontFamily: "Arial").setFontSize(18))).generate("test"), "\(prefix)/image/upload/l_text:Arial_18:Hello%252FWorld/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDTextLayer().setText(text: "Hello World, Nice to meet you?").setFontFamily(fontFamily: "Arial").setFontSize(18))).generate("test"), "\(prefix)/image/upload/l_text:Arial_18:Hello%20World%252C%20Nice%20to%20meet%20you%3F/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDTextLayer().setText(text: "Hello World, Nice to meet you?").setFontFamily(fontFamily: "Arial").setFontSize(18).setFontStyle(.italic).setFontWeight(.bold).setLetterSpacing(4))).generate("test"), "\(prefix)/image/upload/l_text:Arial_18_bold_italic_letter_spacing_4:Hello%20World%252C%20Nice%20to%20meet%20you%3F/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDSubtitlesLayer().setPublicId(publicId: "sample_sub_en.srt"))).generate("test"), "\(prefix)/image/upload/l_subtitles:sample_sub_en.srt/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDSubtitlesLayer().setFontFamily(fontFamily: "Arial").setFontSize(40).setPublicId(publicId: "sample_sub_he.srt"))).generate("test"), "\(prefix)/image/upload/l_subtitles:Arial_40:sample_sub_he.srt/test")
        
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDSubtitlesLayer().setFontFamily(fontFamily:"Arial").setFontSize(40).setFontAntialiasing(CLDTextLayer.CLDFontAntialiasing.FAST)
            .setFontHinting(CLDTextLayer.CLDFontHinting.MEDIUM).setPublicId(publicId: "sample_sub_he.srt"))).generate("test"), "\(prefix)/image/upload/l_subtitles:Arial_40_antialias_fast_hinting_medium:sample_sub_he.srt/test")

        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDSubtitlesLayer().setFontFamily(fontFamily:"Arial").setFontSize(40).setFontAntialiasing("fast")
            .setFontHinting("medium").setPublicId(publicId: "sample_sub_he.srt"))).generate("test"), "\(prefix)/image/upload/l_subtitles:Arial_40_antialias_fast_hinting_medium:sample_sub_he.srt/test")
        
        XCTAssertEqual(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDFetchLayer(url: "https://res.cloudinary.com/demo/image/upload/sample"))).generate("test"),
                       "\(prefix)/image/upload/l_fetch:aHR0cHM6Ly9yZXMuY2xvdWRpbmFyeS5jb20vZGVtby9pbWFnZS91cGxvYWQvc2FtcGxl/test")
    }

    func testOverlayErrors() {
        XCTAssertNil(cloudinary?.createUrl().setTransformation(CLDTransformation().setOverlayWithLayer(CLDTextLayer().setText(text: "text").setFontStyle(.italic))).generate("test"))

        XCTAssertNil(cloudinary?.createUrl().setTransformation(CLDTransformation().setUnderlayWithLayer(CLDLayer().setResourceType(.video))).generate("test"))
    }

    func testCustomFunction(){
        XCTAssertEqual(CLDTransformation().setCustomFunction(.wasm("blur_wasm")).asString() ,"fn_wasm:blur_wasm")
        XCTAssertEqual(CLDTransformation().setCustomFunction(.remote("https://df34ra4a.execute-api.us-west-2.amazonaws.com/default/cloudinaryFunction")).asString()
                ,"fn_remote:aHR0cHM6Ly9kZjM0cmE0YS5leGVjdXRlLWFwaS51cy13ZXN0LTIuYW1hem9uYXdzLmNvbS9kZWZhdWx0L2Nsb3VkaW5hcnlGdW5jdGlvbg==")
    }
    
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
}

