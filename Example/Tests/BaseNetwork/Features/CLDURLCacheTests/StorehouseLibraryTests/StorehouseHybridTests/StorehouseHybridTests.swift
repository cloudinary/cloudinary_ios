//
//  StorehouseHybridTests.swift
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

class StorehouseHybridTests: BaseStorehouseAnyTests<StorehouseHybrid<String>> {

    let maximumSizeDisk = 100_000_000
    
    override func setUp() {
        super.setUp()
        
        sut = createSut()
    }
    
    func createSut() -> StorehouseHybrid<String>! {
        
        // create storehouseOnDisk
        let nameDisk          : String               = "nameTest"
        let expiryDateDisk    : Date                 = Date()
        let expiryDisk        : StorehouseExpiry     = .date(expiryDateDisk)
        let maxSizeDisk       : Int                  = maximumSizeDisk
        let protectionTypeDisk: FileProtectionType?  = .complete
        
        let configuration = StorehouseConfigurationDisk(name: nameDisk , expiry: expiryDisk , maxSize: maxSizeDisk, protectionType: protectionTypeDisk)
        let transformer   = WarehouseTransformerFactory.forCodable(ofType: String.self)
        
        let storehouseOnDisk: StorehouseOnDisk<String> = try! StorehouseOnDisk(configuration: configuration, transformer: transformer)
        
        // create storehouseInMemory
        let expiryDateMemory    : Date             = Date()
        let expiryMemory        : StorehouseExpiry = .date(expiryDateMemory)
        let countLimitMemory    : UInt             = 100_000_000
        let totalCostLimitMemory: UInt             = 100_000_000
        let configurationMemory                    = StorehouseConfigurationInMemory(expiry: expiryMemory, countLimit: countLimitMemory, totalCostLimit: totalCostLimitMemory)
        
        let storehouseInMemory: StorehouseInMemory<String> = StorehouseInMemory(configuration: configurationMemory)
        
        // create storehouseHybrid
        return StorehouseHybrid(inMemory: storehouseInMemory, onDisk: storehouseOnDisk)
    }
    
    override func tearDownWithError() throws {
        try? sut.removeAll()
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_shouldBeInitialized() {
        
        // When
        let tempSut = createSut()
        
        // Then
        XCTAssertNotNil(tempSut, "sut should be initialized")
    }

    // MARK: - vars
    func test_vars_shouldReturnExpectedValues() {
        
        // Given
        let expectedMemoryCapacity = NSNotFound
        let expectedDiskCapacity   = maximumSizeDisk
        let expectedMemoryUsage    = NSNotFound
        let expectedDiskUsage      = 25
        
        let objectToSave   = "objectToSave"
        let savedObjectKey = "key"
        
        // When
        try? sut.setObject(objectToSave, forKey: savedObjectKey)
        
        // Then
        XCTAssertEqual(sut.memoryCapacity, expectedMemoryCapacity, "initialized value should be equal to expected value")
        XCTAssertEqual(sut.diskCapacity, expectedDiskCapacity, "initialized value should be equal to expected value")
        XCTAssertEqual(sut.currentMemoryUsage, expectedMemoryUsage, "initialized value should be equal to expected value")
        XCTAssertEqual(sut.currentDiskUsage, expectedDiskUsage, "initialized value should be equal to expected value")
    }
    func test_vars_diskUsage_shouldReturnExpectedValue() {
        
        // Given
        let objectToSave1        = "objectToSave1"
        let savedObjectKey1      = "key1"
        let objectToSave2        = "objectToSave2"
        let savedObjectKey2      = "key2"
        let expectedDiskUsage    = 52
        
        // When
        try? sut.setObject(objectToSave1, forKey: savedObjectKey1)
        try? sut.setObject(objectToSave2, forKey: savedObjectKey2)
        let currentDiskUsage = sut.currentDiskUsage
        
        // Then
        XCTAssertEqual(currentDiskUsage, expectedDiskUsage, "entered strings should use expected disk space")
    }
}
