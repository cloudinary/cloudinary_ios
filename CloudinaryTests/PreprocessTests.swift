//
//  PreprocessTests.swift
//  CloudinaryTests
//
//  Created by Nitzan Jaitman on 04/01/2018.
//  Copyright © 2018 Cloudinary. All rights reserved.
//

import Foundation
import XCTest
@testable import Cloudinary

class PreprocessTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    fileprivate func getImage()->UIImage {
        let bundle = Bundle(for: PreprocessTests.self)
        let url = bundle.url(forResource: "borderCollie", withExtension: "jpg")!
        
        return CLDPreprocessHelpers.resizeImage(image: UIImage(contentsOfFile: url.path)!, requiredSize: CGSize(width: 300, height:300))
    }
    
    func testLimit() {
        let image = getImage()
    
        var modified = try! CLDPreprocessHelpers.limit(width: 5000, height: 5000)(image)
        XCTAssertEqual(image.size, modified.size)
        
        modified = try! CLDPreprocessHelpers.limit(width: 5000, height: 10)(image)
        XCTAssertEqual(modified.size, CGSize(width: 10, height:10))
        
        modified = try! CLDPreprocessHelpers.limit(width: 10, height: 5000)(image)
        XCTAssertEqual(modified.size, CGSize(width: 10, height:10))
        
        modified = try! CLDPreprocessHelpers.limit(width: 200, height: 300)(image)
        XCTAssertEqual(modified.size, CGSize(width: 200, height:200))
        
        modified = try! CLDPreprocessHelpers.limit(width: 300, height: 200)(image)
        XCTAssertEqual(modified.size, CGSize(width: 200, height:200))
        
        modified = try! CLDPreprocessHelpers.limit(width: 400, height: 200)(image)
        XCTAssertEqual(modified.size, CGSize(width: 200, height:200))
        
        modified = try! CLDPreprocessHelpers.limit(width: 200, height: 400)(image)
        XCTAssertEqual(modified.size, CGSize(width: 200, height:200))

        modified = try! CLDPreprocessHelpers.limit(width: 500, height: 300)(image)
        XCTAssertEqual(modified.size, CGSize(width: 300, height:300))

        modified = try! CLDPreprocessHelpers.limit(width: 300, height: 500)(image)
        XCTAssertEqual(modified.size, CGSize(width: 300, height:300))
    }
    
    func testDimensionValidator() {
        let image = getImage()
        
        var modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 300, maxWidth: 300, minHeight: 300, maxHeight: 300)(image)
        XCTAssertNotNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 300, maxWidth: 3000, minHeight: 300, maxHeight: 3000)(image)
        XCTAssertNotNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 10, maxWidth: 3000, minHeight: 10, maxHeight: 3000)(image)
        XCTAssertNotNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 10, maxWidth: 300, minHeight: 10, maxHeight: 300)(image)
        XCTAssertNotNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 400, maxWidth: 3000, minHeight: 30, maxHeight: 3000)(image)
        XCTAssertNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 300, maxWidth: 300, minHeight: 400, maxHeight: 3000)(image)
        XCTAssertNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 300, maxWidth: 300, minHeight: 100, maxHeight: 200)(image)
        XCTAssertNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 100, maxWidth: 200, minHeight: 300, maxHeight: 300)(image)
        XCTAssertNil(modified)
    }
}
