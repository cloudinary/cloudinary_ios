//
//  WarehouseTests.swift
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

class WarehouseTests: XCTestCase {

    var sut : Warehouse<String>!
    let maximumSizeDisk = 100_000_000
    
    override func setUp() {
        super.setUp()
        
        sut = createHybridSut()
    }
    
    func createHybridSut() -> Warehouse<String>! {
        
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
        let storehouseHybrid = StorehouseHybrid(inMemory: storehouseInMemory, onDisk: storehouseOnDisk)
        
        return Warehouse(hybrid: storehouseHybrid)
    }
    func createMemorySut() -> Warehouse<String>! {
        
        // in memory configuration
        let expiryDateMemory    : Date             = Date()
        let expiryMemory        : StorehouseExpiry = .date(expiryDateMemory)
        let countLimitMemory    : UInt             = 100_000_000
        let totalCostLimitMemory: UInt             = 100_000_000
        
        let configurationMemory                    = StorehouseConfigurationInMemory(expiry: expiryMemory, countLimit: countLimitMemory, totalCostLimit: totalCostLimitMemory)
        
        // on disk configuration
        let nameDisk          : String               = "nameTest"
        let expiryDateDisk    : Date                 = Date()
        let expiryDisk        : StorehouseExpiry     = .date(expiryDateDisk)
        let maxSizeDisk       : Int                  = maximumSizeDisk
        let protectionTypeDisk: FileProtectionType?  = .complete
        
        let configurationDisk = StorehouseConfigurationDisk(name: nameDisk , expiry: expiryDisk , maxSize: maxSizeDisk, protectionType: protectionTypeDisk)
        
        let transformer = WarehouseTransformerFactory.forCodable(ofType: String.self)
        
        return try? Warehouse(memoryConfig: configurationMemory, diskConfig: configurationDisk, transformer: transformer)
    }
    func createAutopurgeSut() -> Warehouse<String>! {
        
        // autopurge configuration
        let expiryDate    : Date             = Date()
        let expiry        : StorehouseExpiry = .date(expiryDate)
        let memory        : Int              = 100_000_000
        let afterPurge    : Int              = 60_000_000
        
        let configurationAutoPurge = StorehouseConfigurationAutoPurging(expiry: expiry, memory: memory, preferredMemoryUsageAfterPurge: afterPurge)
        
        // on disk configuration
        let nameDisk          : String               = "nameTest"
        let expiryDateDisk    : Date                 = Date()
        let expiryDisk        : StorehouseExpiry     = .date(expiryDateDisk)
        let maxSizeDisk       : Int                  = maximumSizeDisk
        let protectionTypeDisk: FileProtectionType?  = .complete
        
        let configurationDisk = StorehouseConfigurationDisk(name: nameDisk , expiry: expiryDisk , maxSize: maxSizeDisk, protectionType: protectionTypeDisk)
        
        let transformer   = WarehouseTransformerFactory.forCodable(ofType: String.self)
        
        return try? Warehouse(purgingConfig: configurationAutoPurge, diskConfig: configurationDisk, transformer: transformer)
    }
    
    override func tearDownWithError() throws {
        try? sut.removeAll()
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_hybrid_shouldBeInitialized() {
        
        // When
        let tempSut = createHybridSut()
        
        // Then
        XCTAssertNotNil(tempSut, "sut should be initialized")
    }
    func test_init_memory_shouldBeInitialized() {
        
        // When
        let tempSut = createMemorySut()
        
        // Then
        XCTAssertNotNil(tempSut, "sut should be initialized")
    }
    func test_init_autopurge_shouldBeInitialized() {
        
        // When
        let tempSut = createAutopurgeSut()
        
        // Then
        XCTAssertNotNil(tempSut, "sut should be initialized")
    }

    // MARK: - vars
    func test_vars_shouldReturnExpectedValue() {
        
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
    func test_vars_diskCapacity_shouldReturnExpectedValue() {
        
        // Given
        let objectToSave1   = "objectToSave1"
        let savedObjectKey1 = "key1"
        let objectToSave2   = "objectToSave2"
        let savedObjectKey2 = "key2"
        let expectedDiskUsage = 52
        
        // When
        try? sut.setObject(objectToSave1, forKey: savedObjectKey1)
        try? sut.setObject(objectToSave2, forKey: savedObjectKey2)
        let currentDiskUsage = sut.currentDiskUsage
        
        // Then
        XCTAssertEqual(currentDiskUsage, expectedDiskUsage, "entered strings should use expected disk space")
    }
    func test_vars_memoryCapacity_shouldReturnExpectedValue() {
        
        // Given
        let objectToSave1   = "objectToSave1"
        let savedObjectKey1 = "key1"
        let objectToSave2   = "objectToSave2"
        let savedObjectKey2 = "key2"
        let expectedDiskUsage = 52
        
        // When
        try? sut.setObject(objectToSave1, forKey: savedObjectKey1)
        try? sut.setObject(objectToSave2, forKey: savedObjectKey2)
        let currentDiskUsage = sut.currentDiskUsage
        
        // Then
        XCTAssertEqual(currentDiskUsage, expectedDiskUsage, "entered strings should use expected disk space")
    }
    func test_vars_currentMemoryUsage_shouldReturnExpectedValue() {
        
        // Given
        let objectToSave1   = "objectToSave1"
        let savedObjectKey1 = "key1"
        let objectToSave2   = "objectToSave2"
        let savedObjectKey2 = "key2"
        let expectedDiskUsage = 52
        
        // When
        try? sut.setObject(objectToSave1, forKey: savedObjectKey1)
        try? sut.setObject(objectToSave2, forKey: savedObjectKey2)
        let currentDiskUsage = sut.currentDiskUsage
        
        // Then
        XCTAssertEqual(currentDiskUsage, expectedDiskUsage, "entered strings should use expected disk space")
    }
    
    // MARK: - funcs
    func test_funcs_emptyEntry_shouldReturnNil() {
        
        let entry = try? sut.entry(forKey: "key")
        
        // Then
        XCTAssertNil(entry, "uninserted value should be nil")
    }
    func test_funcs_setObjectAndEntry_objectShouldBeSet() {
        
        // Given
        let objectToSave   = "objectToSave"
        let savedObjectKey = "key"
        
        // When
        try? sut.setObject(objectToSave, forKey: savedObjectKey)
        let entry = try? sut.entry(forKey: savedObjectKey).object
        
        // Then
        XCTAssertEqual(entry, objectToSave, "object should be set")
    }
    func test_funcs_removeAll_shouldReturnNil() {
        
        // Given
        let objectToSave   = "objectToSave"
        let savedObjectKey = "key"
        
        // When
        try? sut.setObject(objectToSave, forKey: savedObjectKey)
        try? sut.removeAll()
        
        let entry = try? sut.entry(forKey: savedObjectKey).object
        
        // Then
        XCTAssertNil(entry, "removed value should be nil")
    }
    func test_funcs_removeByKey_shouldReturnNil() {
        
        // Given
        let objectToSave   = "objectToSave"
        let savedObjectKey = "key"
        
        // When
        try? sut.setObject(objectToSave, forKey: savedObjectKey)
        try? sut.removeObject(forKey: savedObjectKey)
        
        let entry = try? sut.entry(forKey: savedObjectKey).object
        
        // Then
        XCTAssertNil(entry, "removed value should be nil")
    }
    func test_funcs_removeObjectIfExpired_shouldReturnNil() {
        
        // Given
        let objectToSave   = "objectToSave"
        let savedObjectKey = "key"
        
        // When
        try? sut.setObject(objectToSave, forKey: savedObjectKey)
        try? sut.removeObjectIfExpired(forKey: savedObjectKey)
        
        let entry = try? sut.entry(forKey: savedObjectKey).object
        
        // Then
        XCTAssertNil(entry, "removed value should be nil")
    }
    func test_funcs_removeExpiredObjects_shouldReturnNil() {
        
        // Given
        let objectToSave1   = "objectToSave1"
        let savedObjectKey1 = "key1"
        let objectToSave2   = "objectToSave2"
        let savedObjectKey2 = "key2"
        
        // When
        try? sut.setObject(objectToSave1, forKey: savedObjectKey1)
        try? sut.setObject(objectToSave2, forKey: savedObjectKey2)
        try? sut.removeExpiredObjects()
        
        let entry1 = try? sut.entry(forKey: savedObjectKey1).object
        let entry2 = try? sut.entry(forKey: savedObjectKey2).object
        
        // Then
        XCTAssertNil(entry1, "removed value should be nil")
        XCTAssertNil(entry2, "removed value should be nil")
    }
    func test_funcs_removeStoredObjects_shouldReturnNil() {
        
        // Given
        let objectToSave1   = "objectToSave1"
        let savedObjectKey1 = "key1"
        let objectToSave2   = "objectToSave2"
        let savedObjectKey2 = "key2"
        
        // When
        try? sut.setObject(objectToSave1, forKey: savedObjectKey1)
        try? sut.setObject(objectToSave2, forKey: savedObjectKey2)
        try? sut.removeStoredObjects(since: Date())
        
        let entry1 = try? sut.entry(forKey: savedObjectKey1).object
        let entry2 = try? sut.entry(forKey: savedObjectKey2).object
        
        // Then
        XCTAssertNil(entry1, "removed value should be nil")
        XCTAssertNil(entry2, "removed value should be nil")
    }
    func test_funcs_Object_objectShouldBeSet() {
        
        // Given
        let objectToSave   = "objectToSave"
        let savedObjectKey = "key"
        
        // When
        try? sut.setObject(objectToSave, forKey: savedObjectKey)
        let entry = try? sut.object(forKey: savedObjectKey)
        
        // Then
        XCTAssertEqual(entry, objectToSave, "object should be set")
    }
    func test_funcs_exists_objectShouldBeExists() {
        
        // Given
        let objectToSave   = "objectToSave"
        let savedObjectKey = "key"
        
        // When
        try? sut.setObject(objectToSave, forKey: savedObjectKey)
        let objectExists = try? sut.existsObject(forKey: savedObjectKey)
        
        // Then
        XCTAssert(objectExists == true, "object should be set")
    }
    func test_funcs_expired_objectShouldBeExpired() {
        
        // Given
        let objectToSave   = "objectToSave"
        let savedObjectKey = "key"
        
        // When
        try? sut.setObject(objectToSave, forKey: savedObjectKey)
        let objectExpired = try? sut.isExpiredObject(forKey: savedObjectKey)
        
        // Then
        XCTAssertTrue(objectExpired == true, "object should be expired")
    }
}
