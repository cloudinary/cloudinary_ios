//
//  StorehouseInMemoryTests.swift
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

class StorehouseInMemoryTests: BaseStorehouseAnyTests<StorehouseInMemory<String>> {
    
    override func setUp() {
        super.setUp()
        
        createSut()
    }
    
    func createSut() {
       
        let expiryDate    : Date             = Date()
        let expiry        : StorehouseExpiry = .date(expiryDate)
        let countLimit    : UInt             = 100_000_000
        let totalCostLimit: UInt             = 100_000_000
        let configuration                    = StorehouseConfigurationInMemory(expiry: expiry, countLimit: countLimit, totalCostLimit: totalCostLimit)
        
        sut = StorehouseInMemory(configuration: configuration)
    }
    
    override func tearDownWithError() throws {
        try? sut.removeAll()
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_shouldStoreDefaultProperties() {
        
        // Given
        let defaultMemoryCapacity     = NSNotFound
        let defaultCurrentMemoryUsage = NSNotFound
        
        let expiryDate    : Date             = Date()
        let expiry        : StorehouseExpiry = .date(expiryDate)
        let countLimit    : UInt             = 9
        let totalCostLimit: UInt             = 11
        let configuration                    = StorehouseConfigurationInMemory(expiry: expiry, countLimit: countLimit, totalCostLimit: totalCostLimit)
        
        // When
        let uninitializedSut: StorehouseInMemory<String> = StorehouseInMemory(configuration: configuration)
        
        // Then
        XCTAssertEqual(uninitializedSut.memoryCapacity, defaultMemoryCapacity, "default value should be equal to expected value")
        XCTAssertEqual(uninitializedSut.currentMemoryUsage, defaultCurrentMemoryUsage, "default value should be equal to expected value")
    }
}
