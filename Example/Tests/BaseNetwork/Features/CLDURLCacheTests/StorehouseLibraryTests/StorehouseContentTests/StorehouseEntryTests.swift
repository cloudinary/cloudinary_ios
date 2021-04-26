//
//  StorehouseEntryTests.swift
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

class StorehouseEntryTests: XCTestCase {

    var sut : StorehouseEntry<String>!

    override func tearDownWithError() throws {
        
        sut = nil
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_default_shouldBeInitialized() {
        
        // Given
        let inputObject   : String               = "inputObject"
        let expiryDate    : Date                 = Date()
        let expiry        : StorehouseExpiry     = .date(expiryDate)
        
        // When
        sut = StorehouseEntry(object: inputObject, expiry: expiry)
        
        // Then
        XCTAssertNotNil(sut, "sut should be initialized")
        XCTAssertEqual(sut.object, inputObject, "initialized value should be set")
        XCTAssertEqual(sut.expiry.date, expiryDate, "initialized value should be set")
        XCTAssertNil  (sut.filePath, "default value should be nil")
    }
    func test_init_shouldBeInitialized() {
        
        // Given
        let inputObject   : String               = "inputObject"
        let expiryDate    : Date                 = Date()
        let expiry        : StorehouseExpiry     = .date(expiryDate)
        let path          : String               = "path"
        
        // When
        sut = StorehouseEntry(object: inputObject, expiry: expiry, filePath: path)
        
        // Then
        XCTAssertNotNil(sut, "sut should be initialized")
        XCTAssertEqual(sut.object, inputObject, "initialized value should be set")
        XCTAssertEqual(sut.expiry.date, expiryDate, "initialized value should be set")
        XCTAssertEqual(sut.filePath, path, "initialized value should be set")
    }
}
