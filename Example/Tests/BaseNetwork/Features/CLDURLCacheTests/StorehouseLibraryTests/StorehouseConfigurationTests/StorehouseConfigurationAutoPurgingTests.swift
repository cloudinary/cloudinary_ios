//
//  StorehouseConfigurationAutoPurgingTests.swift
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

class StorehouseConfigurationAutoPurgingTests: XCTestCase {

    var sut : StorehouseConfigurationAutoPurging!
    
    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_allParamaters_shouldStoreProperties() {
        
        // Given
        let expiryDate    : Date             = Date()
        let expiry        : StorehouseExpiry = .date(expiryDate)
        let memory        : Int              = 9
        let afterPurge    : Int              = 11
        
        // When
        sut = StorehouseConfigurationAutoPurging(expiry: expiry, memory: memory, preferredMemoryUsageAfterPurge: afterPurge)
        
        // Then
        XCTAssertEqual(sut.expiry.date, expiryDate, "Initilized object should contain expected value")
        XCTAssertEqual(sut.memoryCapacity, memory, "Initilized object should contain expected value")
        XCTAssertEqual(sut.preferredMemoryUsageAfterPurge, afterPurge, "Initilized object should contain expected value")
    }
    func test_init_emptyParamaters_shouldStoreDefaultProperties() {
        
        // Given
        let defaultMemoryCapacity : Int = 100_000_000
        let defaultAfterPurge     : Int = 60_000_000
        
        // When
        sut = StorehouseConfigurationAutoPurging()
        
        // Then
        switch sut.expiry {
        case .never:
            break
        default:
            XCTFail("default expiry value should be .never")
        }
        
        XCTAssertEqual(sut.memoryCapacity, defaultMemoryCapacity, "default value should be equal to expected value")
        XCTAssertEqual(sut.preferredMemoryUsageAfterPurge, defaultAfterPurge, "default value should be equal to expected value")
    }
}
