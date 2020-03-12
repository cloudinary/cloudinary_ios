//
//  CryptoUtilsTests.swift
//  CloudinaryTests
//
//  Created by Nitzan Jaitman on 14/11/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import XCTest
@testable import Cloudinary

class CryptoUtilsTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMd5() {
        let md5 = "sadnkjqndlk3j43qdaoni834j032df8j0a9sdfu03124".cld_md5()
        XCTAssertEqual("e75465c18b05f1a7e665bbafa9266ef4", md5)
    }
    
    func testSha1Base8(){
        let value = "sadnkjqndlk3j43qdaoni834j032df8j0a9sdfu03124"
        let secret = "rnkjd123af43214na"
        let shar1WithSecret = value.sha1_base8(secret)
        let sha1 = value.sha1_base8(nil)
        
        XCTAssertEqual("6aab31b1ad46b21ba8b1a64d451a762395ae222a", shar1WithSecret)
        XCTAssertEqual("89f30d95fd5e83ce93247677e4a301e279a48ca2", sha1)
    }
    
    func testSha1Base64(){
        let value = "sadnkjqndlk3j43qdaoni834j032df8j0a9sdfu03124"
        let sha1 = value.sha1_base64()
        
        XCTAssertEqual("ifMNlf1eg86TJHZ35KMB4nmkjKI", sha1)
    }
}

