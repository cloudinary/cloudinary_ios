//
//  FileUtilsTests.swift
//  CloudinaryTests
//
//  Created by Nitzan Jaitman on 24/09/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import XCTest
@testable import Cloudinary

class FileUtilsTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSplitFile() {
        
        let url = Bundle.init(for: FileUtilsTests.self).url(forResource: "borderCollie", withExtension: "jpg")!
        let files = CLDFileUtils.splitFile(url: url, name: "testName", chunkSize: 1024 * 20)
        let totalSize = CLDFileUtils.getFileSize(url: url)
        
        var sum: Int64 = 0
        
        for file in files! {
            XCTAssertTrue(FileManager.default.fileExists(atPath: file.url.path))
            sum += Int64(file.length)
        }
        
        XCTAssertEqual(sum, totalSize)
    }
    
    func testRemoveFiles(){
        let url = Bundle.init(for: FileUtilsTests.self).url(forResource: "borderCollie", withExtension: "jpg")!
        let files = CLDFileUtils.splitFile(url: url, name: "testName", chunkSize: 1024 * 20)
        
        for file in files! {
            XCTAssertTrue(FileManager.default.fileExists(atPath: file.url.path))
        }
        
        CLDFileUtils.removeFiles(files: files!)
        
        for file in files! {
            XCTAssertFalse(FileManager.default.fileExists(atPath: file.url.path))
        }
        
    }
}
