//
//  PhotoAlbumTests.swift
//  PhotoAlbumTests
//

import XCTest
@testable import PhotoAlbum

class PhotoAlbumTests: XCTestCase {
    
    //MARK: Photo Class Tests
    
    // Confirm that the Photo initializer returns a Photo object when passed valid parameters.
    func testPhotoInitializationSucceeds() {
        
        let photo = Photo.init(name: "Positive", photo: nil)
        XCTAssertNotNil(photo)

    }
    
    // Confirm that the Photo initialier returns nil when passed an empty name.
    func testPhotoInitializationFails() {

        // Empty String
        let emptyStringPhoto = Photo.init(name: "", photo: nil)
        XCTAssertNil(emptyStringPhoto)
        
    }
}
