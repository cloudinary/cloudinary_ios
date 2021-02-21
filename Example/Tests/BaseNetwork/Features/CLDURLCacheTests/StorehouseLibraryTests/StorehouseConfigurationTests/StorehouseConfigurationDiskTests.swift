//
//  StorehouseConfigurationDiskTests.swift
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

class StorehouseConfigurationDiskTests: XCTestCase {

    var sut : StorehouseConfigurationDisk!
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_allParamaters_shouldStoreProperties() {
        
        // Given
        let name           : String              = "testName"
        let expiryDate     : Date                = Date()
        let expiry         : StorehouseExpiry    = .date(expiryDate)
        let maxSize        : Int                 = 9
        let protectionType : FileProtectionType? = .complete
        
        // When
        sut = StorehouseConfigurationDisk(name: name, expiry: expiry, maxSize: maxSize, protectionType: protectionType)
        
        // Then
        XCTAssertEqual(sut.name, name, "Initilized object should contain expected value")
        XCTAssertEqual(sut.expiry.date, expiryDate, "Initilized object should contain expected value")
        XCTAssertEqual(sut.maximumSize, maxSize, "Initilized object should contain expected value")
        XCTAssertEqual(sut.protectionType, protectionType, "Initilized object should contain expected value")
    }
    func test_init_onlyNameParamaters_shouldStoreDefaultProperties() {
        
        // Given
        let name                  : String              = "testName"
        let defaultMaxSize        : Int                 = 0
        let defaultProtectionType : FileProtectionType? = nil
        
        // When
        sut = StorehouseConfigurationDisk(name: name)
        
        // Then
        switch sut.expiry {
        case .never:
            break
        default:
            XCTFail("default expiry value should be .never")
        }
        
        XCTAssertEqual(sut.name, name, "default value should be equal to expected value")
        XCTAssertEqual(sut.maximumSize, defaultMaxSize, "default value should be equal to expected value")
        XCTAssertEqual(sut.protectionType, defaultProtectionType, "default value should be equal to expected value")
    }
}
