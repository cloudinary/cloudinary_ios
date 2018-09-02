//
// Created by Nitzan Jaitman on 02/09/2018.
// Copyright (c) 2018 Cloudinary. All rights reserved.
//

import Foundation
import XCTest
@testable import Cloudinary

class StringUtilsTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testBase64 (){
        let str = "ad?.,x09~!@!"
        XCTAssertEqual("YWQ/Lix4MDl+IUAh", str.base64())
    }
    
    func testUrlSafeBase64(){
         XCTAssertEqual("YWQ_Lix4MDl-IUAh", str.urlSafeBase64())
    }
}
