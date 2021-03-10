//
//  StorehouseExpiryTests.swift
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

class StorehouseExpiryTests: XCTestCase {

    var sut : StorehouseExpiry!

    override func tearDownWithError() throws {
        
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_shouldBeInitialized() {
        
        // Given
        sut = .never
        
        // Then
        XCTAssertNotNil(sut, "sut should be initialized")
    }

    // MARK: - isExpired
    func test_isExpired_never_shouldNotBeExpired() {
        
        // Given
        sut = .never
        
        // Then
        XCTAssertFalse(sut.isExpired, "sut should not be expired")
    }
    func test_isExpired_secondsFrom1970_shouldNotBeExpired() {
        
        // Given
        sut = .secondsFrom1970(60 * 60 * 24 * 365 * 70)
        
        // Then
        XCTAssertFalse(sut.isExpired, "sut should not be expired")
    }
    func test_isExpired_date_shouldNotBeExpired() {
        
        // Given
        sut = .date(Date() + 10)
        
        // Then
        XCTAssertFalse(sut.isExpired, "sut should not be expired")
    }
    func test_isExpired_oldDate_shouldBeExpired() {
        
        // Given
        sut = .date(Date() - 10)
        
        // Then
        XCTAssertTrue(sut.isExpired, "sut should be expired")
    }
    func test_isExpiredForBase_never_shouldNotBeExpired() {
        
        // Given
        sut = .never
        
        // Then
        XCTAssertFalse(sut.isExpired(for: Date()), "sut should not be expired")
    }
    func test_isExpiredForBase_secondsFrom1970_shouldNotBeExpired() {
        
        // Given
        sut = .secondsFrom1970(60 * 60 * 24 * 365 * 70)
        
        // Then
        XCTAssertFalse(sut.isExpired(for: Date()), "sut should not be expired")
    }
    func test_isExpiredForBase_date_shouldNotBeExpired() {
        
        // Given
        sut = .date(Date() + 10)
        
        // Then
        XCTAssertFalse(sut.isExpired(for: Date()), "sut should not be expired")
    }
    func test_isExpiredForBase_oldDate_shouldBeExpired() {
        
        // Given
        sut = .date(Date() - 10)
        
        // Then
        XCTAssertTrue(sut.isExpired(for: Date()), "sut should be expired")
    }
}
