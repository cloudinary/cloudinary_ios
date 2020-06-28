//
//  ExplicitMockOcrTests.swift
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

// explicitMockOcrTests created to reduce server calls to Cloudinary PAID OCR service
class ExplicitMockOcrTests: NetworkBaseTest {

    var sut : CLDExplicitResult!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
        sut = MockProvider.explicitMockResult
    }
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - explicit result
    func test_explicitResult_ocrParsing_ShouldParseAsExpected() {

        //Given
        let expectedStatus                       = "complete"
        let expectedLocale                       = "en"
        let expectedTextDescription              = "OCR test image\nSOME FONT\nAnother font\nOne more\nlast one\n"
        let expectedVerticeX                     = CGFloat(89)
        let expectedVerticeY                     = CGFloat(87)
        let expectedFullTextAnnotationText       = "OCR test image\nSOME FONT\nAnother font\nOne more\nlast one\n"
        let expectedPagesWidth                   = 1144
        let expectedPagesHeight                  = 1048
        let expectedLanguageCode                 = "en"
        let expectedConfidence                   = 1
        let expectedBlockType                    = "TEXT"
        let expectedBoundingBoxVerticeX          = CGFloat(241)
        let expectedBoundingBoxVerticeY          = CGFloat(84)
        let expectedParagraphBoundingBoxVerticeX = CGFloat(241)
        let expectedParagraphBoundingBoxVerticeY = CGFloat(84)
        let expectedWordsBoundingBoxVerticeX     = CGFloat(241)
        let expectedWordsBoundingBoxVerticeY     = CGFloat(87)
        let expectedSymbolText                   = "O"
        let expectedSymbolsBoundingBoxVerticeX   = CGFloat(241)
        let expectedSymbolsBoundingBoxVerticeY   = CGFloat(88)
        
        // Then
        XCTAssertNotNil(sut.info?.ocr, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr, "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.status, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.status, expectedStatus, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0], "mock properties should not be nil")
        
        // text annotations
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].textAnnotations!, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0], "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0].locale, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0].locale, expectedLocale, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0].textDescription, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0].textDescription, expectedTextDescription, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0].boundingBlock, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0].boundingBlock?.vertices, "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0].boundingBlock?.vertices![0], "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0].boundingBlock?.vertices![0].x, expectedVerticeX, "value should be equal to expected value")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].textAnnotations![0].boundingBlock?.vertices![0].y, expectedVerticeY, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation, "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.text, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.text, expectedFullTextAnnotationText, "value should be equal to expected value")
        
        // pages
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0], "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].width, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].width, expectedPagesWidth, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].height, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].height, expectedPagesHeight, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].property, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].property, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].property?.detectedLanguages, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].property?.detectedLanguages![0], "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].property?.detectedLanguages![0].languageCode, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].property?.detectedLanguages![0].languageCode, expectedLanguageCode, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].property?.detectedLanguages![0].confidence, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].property?.detectedLanguages![0].confidence, expectedConfidence, "value should be equal to expected value")
        
        // blocks
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0], "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].blockType, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].blockType, expectedBlockType, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].property, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].property?.detectedLanguages, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].property?.detectedLanguages![0], "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].property?.detectedLanguages![0].languageCode, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].property?.detectedLanguages![0].languageCode, expectedLanguageCode, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].property?.detectedLanguages![0].confidence, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].property?.detectedLanguages![0].confidence, expectedConfidence, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].boundingBox, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].boundingBox?.vertices, "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].boundingBox?.vertices![0], "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].boundingBox?.vertices![0].x, expectedBoundingBoxVerticeX, "value should be equal to expected value")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].boundingBox?.vertices![0].y, expectedBoundingBoxVerticeY, "value should be equal to expected value")
        
        // paragraph
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0], "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].property, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].property?.detectedLanguages, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].property?.detectedLanguages![0], "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].property?.detectedLanguages![0].languageCode, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].property?.detectedLanguages![0].languageCode, expectedLanguageCode, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].property?.detectedLanguages![0].confidence, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].property?.detectedLanguages![0].confidence, expectedConfidence, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].boundingBox, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].boundingBox?.vertices, "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].boundingBox?.vertices![0], "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].boundingBox?.vertices![0].x, expectedParagraphBoundingBoxVerticeX, "value should be equal to expected value")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].boundingBox?.vertices![0].y, expectedParagraphBoundingBoxVerticeY, "value should be equal to expected value")
        
        // words
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0], "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0], "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].property, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].property?.detectedLanguages, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].property?.detectedLanguages![0], "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].property?.detectedLanguages![0].languageCode, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].property?.detectedLanguages![0].languageCode, expectedLanguageCode, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].boundingBox, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].boundingBox?.vertices, "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].boundingBox?.vertices![0], "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].boundingBox?.vertices![0].x, expectedWordsBoundingBoxVerticeX, "value should be equal to expected value")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].boundingBox?.vertices![0].y, expectedWordsBoundingBoxVerticeY, "value should be equal to expected value")
       
        // symbols
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0], "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].text, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].text, expectedSymbolText , "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].property, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].property?.detectedLanguages, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].property?.detectedLanguages![0], "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].property?.detectedLanguages![0].languageCode, "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].property?.detectedLanguages![0].languageCode, expectedLanguageCode, "value should be equal to expected value")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].boundingBox, "mock properties should not be nil")
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].boundingBox?.vertices, "mock properties should not be nil")
        
        XCTAssertNotNil(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].boundingBox?.vertices![0], "mock properties should not be nil")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].boundingBox?.vertices![0].x, expectedSymbolsBoundingBoxVerticeX, "value should be equal to expected value")
        XCTAssertEqual(sut.info?.ocr?.advOcr?.data![0].fullTextAnnotation?.pages![0].blocks![0].paragraphs![0].words![0].symbols![0].boundingBox?.vertices![0].y, expectedSymbolsBoundingBoxVerticeY, "value should be equal to expected value")
    }
}
