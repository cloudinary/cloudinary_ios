//
//  WarehouseTransformerFactoryTests.swift
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

class WarehouseTransformerFactoryTests: XCTestCase {
    
    @objc(codingClass)
    class codingClass: NSObject, NSCoding, Codable {
        func encode(with coder: NSCoder) {}
        required init?(coder: NSCoder) {}
    }
    
    // MARK: - create trasformer
    func test_createTrasformer_codeable_shouldBeCreated() {
        
        // When
        let transformer = WarehouseTransformerFactory.forCodable(ofType: codingClass.self)
        
        // Then
        XCTAssertNotNil(transformer.toData,   "sut should be initialized")
        XCTAssertNotNil(transformer.fromData, "sut should be initialized")
    }
    
    func test_createTrasformer_coding_shouldBeCreated() {
        
        // When
        let transformer = WarehouseTransformerFactory.forCoding(ofType: codingClass.self)
        
        // Then
        XCTAssertNotNil(transformer.toData,   "sut should be initialized")
        XCTAssertNotNil(transformer.fromData, "sut should be initialized")
    }
    
    func test_createTrasformer_securedCoding_shouldBeCreated() {
        
        // When
        let transformer = WarehouseTransformerFactory.forSecuredCoding(ofType: codingClass.self)
        
        // Then
        XCTAssertNotNil(transformer.toData,   "sut should be initialized")
        XCTAssertNotNil(transformer.fromData, "sut should be initialized")
    }
}
