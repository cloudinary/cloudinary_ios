//
//  CLDURLCacheConfigurationTests.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
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

@testable import Cloudinary
import Foundation
import XCTest

class CLDURLCacheConfigurationTests: XCTestCase {

    var sut : CLDURLCacheConfiguration!
    
    override func setUp() {
        super.setUp()
        
        sut = CLDURLCacheConfiguration.defualt
    }
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_currentDefaultParamaters_shouldStoreDefaultProperties() {
        
        // Given
        let securedStorage            = false
        let minCacheResponseAge       = TimeInterval(604800)
        let maxCacheResponseAge       = TimeInterval(259200)
        let expirationDelayDefault    = TimeInterval(5 * 60 * 60) // 1 hours
        let expirationDelayMinimum    = TimeInterval(5 * 60     ) // 5 minutes
        let lastModificationFraction  = Double(0.1)
        let logingScope               = CLDURLCacheConfiguration.LogingScope.debugOnly

        // Then
        XCTAssertNotNil(sut, "Initilized object should not be nil")
        XCTAssertEqual(sut.securedStorage, securedStorage, "Initilized object should contain expected value")
        XCTAssertEqual(sut.minCacheResponseAge, minCacheResponseAge, "Initilized object should contain expected value")
        XCTAssertEqual(sut.maxCacheResponseAge, maxCacheResponseAge, "Initilized object should contain expected value")
        XCTAssertEqual(sut.expirationDelayDefault, expirationDelayDefault, "Initilized object should contain expected value")
        XCTAssertEqual(sut.expirationDelayMinimum, expirationDelayMinimum, "Initilized object should contain expected value")
        XCTAssertEqual(sut.lastModificationFraction, lastModificationFraction, "Initilized object should contain expected value")
        XCTAssertEqual(sut.logingScope, logingScope, "Initilized object should contain expected value")
    }
    
}
