//
//  BaseTestCase.swift
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

@testable import Cloudinary
import Foundation
import XCTest

class BaseTestCase: XCTestCase {
    let timeout: TimeInterval = 120.0

    static var testDirectoryURL: URL { return FileManager.temporaryDirectoryURL.appendingPathComponent("org.cloudinary.tests") }
    var testDirectoryURL: URL { return BaseTestCase.testDirectoryURL }

    override func setUp() {
        super.setUp()

        FileManager.removeAllItemsInsideDirectory(at: testDirectoryURL)
        FileManager.createDirectory(at: testDirectoryURL)
    }

    override func setUpWithError() throws {
        
        try XCTSkipIf(shouldSkipTest(), "test skipped")
        
        try super.setUpWithError()
    }
    
    /**
     override this method to skip tests when needed
    */
    func shouldSkipTest() -> Bool {
        return false
    }
    
    func url(forResource fileName: String, withExtension ext: String) -> URL {
        let bundle = Bundle(for: BaseTestCase.self)
        return bundle.url(forResource: fileName, withExtension: ext)!
    }
}
