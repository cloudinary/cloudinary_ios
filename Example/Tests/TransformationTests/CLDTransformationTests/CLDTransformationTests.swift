//
//  CLDTransformationTests.swift
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

@testable import Cloudinary
import Foundation
import XCTest

class CLDTransformationTests: BaseTestCase {
     
    var sut : CLDTransformation!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
        sut = CLDTransformation()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - width
    func test_setWidth_int_shouldReturnValidString() {
        
        // Given
        let input = 200
        
        let expectedResult = "200"
        
        // When
        sut.setWidth(input)
        
        let actualResult = sut.width!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setWidth_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setWidth(input)
        
        let actualResult = sut.width!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setWidth_string_shouldReturnValidString() {
        
        // Given
        let input = "200"
        
        let expectedResult = "200"
        
        // When
        sut.setWidth(input)
        
        let actualResult = sut.width!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setWidth_expression_shouldReturnValidString() {
        
        // Given
        let input = CLDExpression.width().add(by: 200)
        
        let expectedResult = "w_add_200"
        
        // When
        sut.setWidth(input)
        
        let actualResult = sut.width!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - height
    func test_setHeight_int_shouldReturnValidString() {
        
        // Given
        let input = 200
        
        let expectedResult = "200"
        
        // When
        sut.setHeight(input)
        
        let actualResult = sut.height!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setHeight_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setHeight(input)
        
        let actualResult = sut.height!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setHeight_string_shouldReturnValidString() {
        
        // Given
        let input = "height 200"
        
        let expectedResult = "h_200"
        
        // When
        sut.setHeight(input)
        
        let actualResult = sut.height!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setHeight_expression_shouldReturnValidString() {
        
        // Given
        let input = CLDExpression.height().add(by: 200)
        let expectedResult = "h_add_200"
        
        // When
        sut.setHeight(input)
        
        let actualResult = sut.height!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - named
    func test_setNamed_string_shouldReturnValidString() {
        
        // Given
        let input = "name1"
        
        let expectedResult = "name1"
        
        // When
        sut.setNamed(input)
        
        let actualResult = sut.named!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setNamed_array_shouldReturnValidString() {
        
        // Given
        let input1 = "name1"
        let input2 = "name2"
        
        let expectedResult = "name1.name2"
        
        // When
        sut.setNamed([input1, input2])
        
        let actualResult = sut.named!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - crop
    func test_setCrop_string_shouldReturnValidString() {
        
        // Given
        let input = "fill"
        
        let expectedResult = "fill"
        
        // When
        sut.setCrop(input)
        
        let actualResult = sut.crop!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setCrop_CLDCrop_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDCrop.fill
        
        let expectedResult = "fill"
        
        // When
        sut.setCrop(input)
        
        let actualResult = sut.crop!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - background
    func test_setBackground_stringValue_shouldReturnValidString() {
        
        // Given
        let input = "#rrraaa"
        
        let expectedResult = "rgb:rrraaa"
        
        // When
        sut.setBackground(input)
        
        let actualResult = sut.background!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - color
    func test_setColor_stringValue_shouldReturnValidString() {
        
        // Given
        let input = "#rrraaa"
        
        let expectedResult = "rgb:rrraaa"
        
        // When
        sut.setColor(input)
        
        let actualResult = sut.color!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - effect
    func test_setEffect_string_shouldReturnValidString() {
        
        // Given
        let input = "gamma"
        
        let expectedResult = "gamma"
        
        // When
        sut.setEffect(input)
        
        let actualResult = sut.effect!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setEffect_CLDEffect_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDEffect.oilPaint
        
        let expectedResult = "oil_paint"
        
        // When
        sut.setEffect(input)
        
        let actualResult = sut.effect!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setEffect_CLDArt_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDArtFilters.alDente
        
        let expectedResult = "art:al_dente"
        
        // When
        sut.setEffect(input)
        
        let actualResult = sut.effect!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setEffect_CLDEffectWithParam_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDEffect.gamma
        let param  = "200"
        
        let expectedResult = "gamma:200"
        
        // When
        sut.setEffect(input, param: param)
        
        let actualResult = sut.effect!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setEffect_stringEffectWithParam_shouldReturnValidString() {
        
        // Given
        let input = "gamma"
        let param = "200"
        
        let expectedResult = "gamma:200"
        
        // When
        sut.setEffect(input, param: param)
        
        let actualResult = sut.effect!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - angle
    func test_setAngle_int_shouldReturnValidString() {
        
        // Given
        let input = 200
        
        let expectedResult = "200"
        
        // When
        sut.setAngle(input)
        
        let actualResult = sut.angle!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setAngle_string_shouldReturnValidString() {
        
        // Given
        let input = "200"
        
        let expectedResult = "200"
        
        // When
        sut.setAngle(input)
        
        let actualResult = sut.angle!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setAngle_array_shouldReturnValidString() {
        
        // Given
        let input = ["200", "300"]
        
        let expectedResult = "200.300"
        
        // When
        sut.setAngle(input)
        
        let actualResult = sut.angle!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - opacity
    func test_setOpacity_int_shouldReturnValidString() {
        
        // Given
        let input = 200
        
        let expectedResult = "200"
        
        // When
        sut.setOpacity(input)
        
        let actualResult = sut.opacity!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setOpacity_string_shouldReturnValidString() {
        
        // Given
        let input = "200"
        
        let expectedResult = "200"
        
        // When
        sut.setOpacity(input)
        
        let actualResult = sut.opacity!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - border
    func test_setBorder_widthAndColor_shouldReturnValidString() {
        
        // Given
        let input          = 200
        let color          = "rgb:222.111.333"
        let expectedResult = "200px_solid_rgb:222.111.333"
        
        // When
        sut.setBorder(input, color: color)
        
        let actualResult = sut.border!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setBorder_string_shouldReturnValidString() {
        
        // Given
        let input = "5px_solid_#111111"
        
        let expectedResult = "5px_solid_rgb:111111"
        
        // When
        sut.setBorder(input)
        
        let actualResult = sut.border!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - x
    func test_setX_int_shouldReturnValidString() {
        
        // Given
        let input = 200
        
        let expectedResult = "200"
        
        // When
        sut.setX(input)
        
        let actualResult = sut.x!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setX_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setX(input)
        
        let actualResult = sut.x!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setX_string_shouldReturnValidString() {
        
        // Given
        let input = "+ 200"
        
        let expectedResult = "+_200"
        
        // When
        sut.setX(input)
        
        let actualResult = sut.x!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setX_expression_shouldReturnValidString() {
        
        // Given
        let input = CLDExpression.pageXOffset().add(by: 200)
        
        let expectedResult = "px_add_200"
        
        // When
        sut.setX(input)
        
        let actualResult = sut.x!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - y
    func test_setY_int_shouldReturnValidString() {
        
        // Given
        let input = 200
        
        let expectedResult = "200"
        
        // When
        sut.setY(input)
        
        let actualResult = sut.y!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setY_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setY(input)
        
        let actualResult = sut.y!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setY_string_shouldReturnValidString() {
        
        // Given
        let input = "+ 200"
        
        let expectedResult = "+_200"
        
        // When
        sut.setY(input)
        
        let actualResult = sut.y!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setY_expression_shouldReturnValidString() {
        
        // Given
        let input = CLDExpression.pageYOffset().add(by: 200)
        
        let expectedResult = "py_add_200"
        
        // When
        sut.setY(input)
        
        let actualResult = sut.y!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - radius
    func test_setRadius_int_shouldReturnValidString() {
        
        // Given
        let input = 200
        
        let expectedResult = "200"
        
        // When
        sut.setRadius(input)
        
        let actualResult = sut.radius!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setRadius_string_shouldReturnValidString() {
        
        // Given
        let input = "+ 200"
        
        let expectedResult = "+_200"
        
        // When
        sut.setRadius(input)
        
        let actualResult = sut.radius!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - quality
    func test_setQuality_int_shouldReturnValidString() {
        
        // Given
        let input = 200
        
        let expectedResult = "200"
        
        // When
        sut.setQuality(input)
        
        let actualResult = sut.quality!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setQuality_string_shouldReturnValidString() {
        
        // Given
        let input = "200"
        
        let expectedResult = "200"
        
        // When
        sut.setQuality(input)
        
        let actualResult = sut.quality!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setQuality_CLDQuality_shouldReturnValidString() { 
        
        // Given
        let input = CLDTransformation.CLDQuality.auto()
        
        let expectedResult = "auto"
        
        // When
        sut.setQuality(input)
        
        let actualResult = sut.quality!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setQuality_CLDQualityBest_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDQuality.auto(.best)
        
        let expectedResult = "auto:best"
        
        // When
        sut.setQuality(input)
        
        let actualResult = sut.quality!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setQuality_CLDQualityGood_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDQuality.auto(.good)
        
        let expectedResult = "auto:good"
        
        // When
        sut.setQuality(input)
        
        let actualResult = sut.quality!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setQuality_CLDQualityEco_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDQuality.auto(.eco)
        
        let expectedResult = "auto:eco"
        
        // When
        sut.setQuality(input)
        
        let actualResult = sut.quality!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setQuality_CLDQualityLow_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDQuality.auto(.low)
        
        let expectedResult = "auto:low"
        
        // When
        sut.setQuality(input)
        
        let actualResult = sut.quality!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }

    // MARK: - defaultImage
    func test_setDefaultImage_string_shouldReturnValidString() {
        
        // Given
        let input = "image1"
        
        let expectedResult = "image1"
        
        // When
        sut.setDefaultImage(input)
        
        let actualResult = sut.defaultImage!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - gravity
    func test_setGravity_string_shouldReturnValidString() {
        
        // Given
        let input = "right"
        
        let expectedResult = "right"
        
        // When
        sut.setGravity(input)
        
        let actualResult = sut.gravity!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setGravity_CLDGravity_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDGravity.center
        
        let expectedResult = "center"
        
        // When
        sut.setGravity(input)
        
        let actualResult = sut.gravity!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - colorSpace
    func test_setColorSpace_string_shouldReturnValidString() {
        
        // Given
        let input = "blue"
        
        let expectedResult = "blue"
        
        // When
        sut.setColorSpace(input)
        
        let actualResult = sut.colorSpace!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - prefix
    func test_setPrefix_string_shouldReturnValidString() {
        
        // Given
        let input = "www"
        
        let expectedResult = "www"
        
        // When
        sut.setPrefix(input)
        
        let actualResult = sut.prefix!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - overlay
    func test_setOverlay_string_shouldReturnValidString() {
        
        // Given
        let input = "image"
        
        let expectedResult = "image"
        
        // When
        sut.setOverlay(input)
        
        let actualResult = sut.overlay!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - underlay
    func test_setUnderlay_string_shouldReturnValidString() {
        
        // Given
        let input = "image"
        
        let expectedResult = "image"
        
        // When
        sut.setUnderlay(input)
        
        let actualResult = sut.underlay!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - fetschFormat
    func test_setFetchFormat_string_shouldReturnValidString() {
        
        // Given
        let input = "format"
        
        let expectedResult = "format"
        
        // When
        sut.setFetchFormat(input)
        
        let actualResult = sut.fetchFormat!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - density
    func test_setDensity_int_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30"
        
        // When
        sut.setDensity(input)
        
        let actualResult = sut.density!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setDensity_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setDensity(input)
        
        let actualResult = sut.density!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - page
    func test_setPage_int_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30"
        
        // When
        sut.setPage(input)
        
        let actualResult = sut.page!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setPage_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setPage(input)
        
        let actualResult = sut.page!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - delay
    func test_setDelay_int_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30"
        
        // When
        sut.setDelay(input)
        
        let actualResult = sut.delay!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setDelay_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setDelay(input)
        
        let actualResult = sut.delay!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - rawTransformation
    func test_setRawTransformation_shouldReturnValidString() {
        
        // Given
        let input = "r_w_add_200"
        
        let expectedResult = "r_w_add_200"
        
        // When
        sut.setRawTransformation(input)
        
        let actualResult = sut.rawTransformation!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setRawTransformation_multiProperties_shouldOrderTransformation() {
        
        // Given
        let input = "r_w_add_200"
        
        let expectedResult = "c_fit,w_100,r_w_add_200"
        
        // When
        sut.setCrop(.fit).setRawTransformation(input).setWidth(100)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setRawTransformation_ifEnd_shouldOrderTransformation() {
        
        // Given
        let input = "r_w_add_200"
        
        let expectedResult = "if_w_gt_100/c_fit,w_100,r_w_add_200/if_end"
        
        // When
        sut.ifCondition().width(">", 100).then().setCrop(.fit).setRawTransformation(input).setWidth(100).endIf()
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - flags
    func test_setFlags_string_shouldReturnValidString() {
        
        // Given
        let input = "30.20.10"
        
        let expectedResult = "30.20.10"
        
        // When
        sut.setFlags(input)
        
        let actualResult = sut.flags!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setFlags_array_shouldReturnValidString() {
        
        // Given
        let input = ["30","20","10"]
        
        let expectedResult = "30.20.10"
        
        // When
        sut.setFlags(input)
        
        let actualResult = sut.flags!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - dpr
    func test_setDpr_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setDpr(input)
        
        let actualResult = sut.dpr!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setDpr_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setDpr(input)
        
        let actualResult = sut.dpr!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - zoom
    func test_setZoom_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setZoom(input)
        
        let actualResult = sut.zoom!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setZoom_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setZoom(input)
        
        let actualResult = sut.zoom!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - aspectRatio
    func test_setAspectRatio_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setAspectRatio(input)
        
        let actualResult = sut.aspectRatio!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setAspectRatio_string_shouldReturnValidString() {
        
        // Given
        let input = "3:4"
        
        let expectedResult = "3:4"
        
        // When
        sut.setAspectRatio(input)
        
        let actualResult = sut.aspectRatio!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setAspectRatio_int_shouldReturnValidString() {
        
        // Given
        let inputNominator   = 3
        let inputDenuminator = 4
        
        let expectedResult = "3:4"
        
        // When
        sut.setAspectRatio(nominator: inputNominator, denominator: inputDenuminator)
        
        let actualResult = sut.aspectRatio!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - customFunction
    func test_setCustomFunction_wasm_shouldReturnValidString() {
        
        // Given
        let input = "func"
        
        let expectedResult = "wasm:func"
        
        // When
        sut.setCustomFunction(.wasm(input))
        
        let actualResult = sut.customFunction!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setCustomFunction_remote_shouldReturnValidString() {
        
        // Given
        let input = "func"
        
        let expectedResult = "remote:ZnVuYw=="
        
        // When
        sut.setCustomFunction(.remote(input))
        
        let actualResult = sut.customFunction!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - audioCodec
    func test_setAudioCodec_string_shouldReturnValidString() {
        
        // Given
        let input = "sound"
        
        let expectedResult = "sound"
        
        // When
        sut.setAudioCodec(input)
        
        let actualResult = sut.audioCodec!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - audioFrequency
    func test_setAudioFrequency_int_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30"
        
        // When
        sut.setAudioFrequency(input)
        
        let actualResult = sut.audioFrequency!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setAudioFrequency_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setAudioFrequency(input)
        
        let actualResult = sut.audioFrequency!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - bitRate
    func test_setBitRate_int_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30"
        
        // When
        sut.setBitRate(input)
        
        let actualResult = sut.bitRate!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setBitRate_intK_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30k"
        
        // When
        sut.setBitRate(kb: input)
        
        let actualResult = sut.bitRate!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setBitRate_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setBitRate(input)
        
        let actualResult = sut.bitRate!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - videoSampling
    func test_setVideoSampling_int_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30"
        
        // When
        sut.setVideoSampling(frames:input)
        
        let actualResult = sut.videoSampling!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setVideoSampling_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3s"
        
        // When
        sut.setVideoSampling(delay: input)
        
        let actualResult = sut.videoSampling!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setVideoSampling_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setVideoSampling(input)
        
        let actualResult = sut.videoSampling!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - duration
    func test_setDuration_int_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30p"
        
        // When
        sut.setDuration(percent: input)
        
        let actualResult = sut.duration!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setDuration_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setDuration(seconds: input)
        
        let actualResult = sut.duration!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setDuration_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setDuration(input)
        
        let actualResult = sut.duration!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - startOffset
    func test_setStartOffset_int_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30p"
        
        // When
        sut.setStartOffset(percent: input)
        
        let actualResult = sut.startOffset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setStartOffset_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setStartOffset(seconds: input)
        
        let actualResult = sut.startOffset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setStartOffset_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setStartOffset(input)
        
        let actualResult = sut.startOffset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - endOffset
    func test_setEndOffset_int_shouldReturnValidString() {
        
        // Given
        let input = 30
        
        let expectedResult = "30p"
        
        // When
        sut.setEndOffset(percent: input)
        
        let actualResult = sut.endOffset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setEndOffset_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setEndOffset(seconds: input)
        
        let actualResult = sut.endOffset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setEndOffset_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setEndOffset(input)
        
        let actualResult = sut.endOffset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - startOffsetAndEndOffset
    func test_setStartOffsetAndEndOffset_shouldReturnValidString() {
        
        // Given
        let inputStart = Float(30.3)
        let inputEnd   = Float(20.2)
        
        let expectedResult = "eo_20.2,so_30.3"
        
        // When
        sut.setStartOffsetAndEndOffset(startSeconds: inputStart, endSeconds: inputEnd)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setStartOffsetAndEndOffset_percent_shouldReturnValidString() {
        
        // Given
        let inputStart = 20
        let inputEnd   = 30
        
        let expectedResult = "eo_30p,so_20p"
        
        // When
        sut.setStartOffsetAndEndOffset(startPercent: inputStart, endPercent: inputEnd)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - videoCodec
    func test_setVideoCodec_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setVideoCodec(input)
        
        let actualResult = sut.videoCodec!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - param
    func test_setParam_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        let key   = CLDTransformation.TransformationParam.ANGLE.rawValue
        
        let expectedResult = "30"
        
        // When
        sut.setParam(key, value: input)
        
        let actualResult = sut.angle!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - offset
    func test_setOffset_intArray_shouldReturnValidString() {
        
        // Given
        let input = [30,20]
        
        let expectedResult = ["30p","20p"]
        
        // When
        sut.setOffset(percents: input)
        
        let actualResult = sut.offset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setOffset_oneValueIntArray_shouldReturnValidString() {
        
        // Given
        let input = [30]
        
        let expectedResult = ["30p","30p"]
        
        // When
        sut.setOffset(percents: input)
        
        let actualResult = sut.offset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setOffset_emptyIntArray_shouldNotStoreParam() {
        
        // Given
        let input = [Int]()
        
        // When
        sut.setOffset(percents: input)
        
        let actualResult = sut.offset
        
        // Then
        XCTAssertNil(actualResult, "offset should not be stored without a valid array")
    }
    func test_setOffset_floatArray_shouldReturnValidString() {
        
        // Given
        let input = [Float(30.3),Float(20.2)]
        
        let expectedResult = ["30.3","20.2"]
        
        // When
        sut.setOffset(seconds: input)
        
        let actualResult = sut.offset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setOffset_oneValueFloatArray_shouldReturnValidString() {
        
        // Given
        let input = [Float(30.3)]
        
        let expectedResult = ["30.3","30.3"]
        
        // When
        sut.setOffset(seconds: input)
        
        let actualResult = sut.offset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setOffset_emptyFloatArray_shouldNotStoreParam() {
        
        // Given
        let input = [Float]()
        
        // When
        sut.setOffset(seconds: input)
        
        let actualResult = sut.offset
        
        // Then
        XCTAssertNil(actualResult, "offset should not be stored without a valid array")
    }
    func test_setOffset_stringArray_shouldReturnValidString() {
        
        // Given
        let input = ["30","20"]
        
        let expectedResult = ["30","20"]
        
        // When
        sut.setOffset(input)
        
        let actualResult = sut.offset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setOffset_oneValueStringArray_shouldReturnValidString() {
        
        // Given
        let input = ["30"]
        
        let expectedResult = ["30","30"]
        
        // When
        sut.setOffset(input)
        
        let actualResult = sut.offset!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setOffset_emptyStringArray_shouldNotStoreParam() {
        
        // Given
        let input = [String]()
        
        // When
        sut.setOffset(input)
        
        let actualResult = sut.offset
        
        // Then
        XCTAssertNil(actualResult, "offset should not be stored without a valid array")
    }
    
    // MARK: - fps
    func test_setFps_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setFps(input)
        
        let actualResult = sut.fps!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setFps_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setFps(input)
        
        let actualResult = sut.fps!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setFps_CLDFps_shouldReturnValidString() {
        
        // Given
        let input = CLDTransformation.CLDFps.fromFloat(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setFps(input)
        
        let actualResult = sut.fps!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - overlayWithLayer
    func test_setOverlayWithLayer_float_shouldReturnValidString() {
        
        // Given
        let input = CLDLayer().setPublicId(publicId: "logo")
        
        let expectedResult = "logo"
        
        // When
        sut.setOverlayWithLayer(input)
        
        let actualResult = sut.overlay!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - underlayWithLayer
    func test_setUnderlayWithLayer_float_shouldReturnValidString() {
        
        // Given
        let input = CLDLayer().setPublicId(publicId: "logo")
        
        let expectedResult = "logo"
        
        // When
        sut.setUnderlayWithLayer(input)
        
        let actualResult = sut.underlay!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - topLeftPoint
    func test_setTopLeftPoint_shouldReturnValidString() {
        
        // Given
        let input = CGPoint(x: 20.2, y: 30.3)
        
        let expectedResult = "x_20.2,y_30.3"
        
        // When
        sut.setTopLeftPoint(input)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - keyframeInterval
    func test_setKeyframeInterval_float_shouldReturnValidString() {
        
        // Given
        let input = Float(30.3)
        
        let expectedResult = "30.3"
        
        // When
        sut.setKeyframeInterval(interval: input)
        
        let actualResult = sut.keyframeInterval!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    func test_setKeyframeInterval_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setKeyframeInterval(input)
        
        let actualResult = sut.keyframeInterval!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
    
    // MARK: - keyframeInterval
    func test_setStreamingProfile_string_shouldReturnValidString() {
        
        // Given
        let input = "30"
        
        let expectedResult = "30"
        
        // When
        sut.setStreamingProfile(input)
        
        let actualResult = sut.streamingProfile!
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling for inserted param should return its value")
    }
}
