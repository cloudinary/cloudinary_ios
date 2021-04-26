//
//  BaseStorehouseAnyTests.swift
//  Cloudinary_Tests
//
//  Created by Oz Deutsch on 13/01/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

@testable import Cloudinary
import Foundation
import XCTest


class BaseStorehouseAnyTests<Storehouse: StorehouseAny<String>> : XCTestCase {

    var sut : Storehouse!
    
    // MARK: - funcs
    func test_funcs_emptyEntry_shouldReturnNil() {
        
        // When
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
    func test_funcs_exists_objectShouldExists() {
        
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
