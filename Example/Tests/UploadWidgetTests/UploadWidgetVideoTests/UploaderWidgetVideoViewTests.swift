//
//  UploaderWidgetVideoViewTests.swift
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
import AVKit

class UploaderWidgetVideoViewTests: NetworkBaseTest {
    
    var sut: CLDVideoView!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - init
    func test_init_shouldCreateElement() {
        
        // Given
        let frame      = CGRect.zero
        let playerItem = getVideo(.dog)
        let isMuted    = true
        
        // When
        sut = CLDVideoView(frame: frame, playerItem: playerItem, isMuted: isMuted)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.videoControlsView, "object should be initialized")
        XCTAssertNotNil(sut.videoPlayerView, "object should be initialized")
        XCTAssertNotNil(sut.player, "object should be initialized")
        XCTAssertEqual (sut.player.currentItem, playerItem, "objects should be equal")
    }
    
    func test_init_noVideo_shouldCreateElement() {
        
        // Given
        let frame      = CGRect.zero
        let isMuted    = true
        
        // When
        sut = CLDVideoView(frame: frame, playerItem: nil, isMuted: isMuted)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.videoControlsView, "object should be initialized")
        XCTAssertNotNil(sut.videoPlayerView, "object should be initialized")
        XCTAssertNotNil(sut.player, "object should be initialized")
        XCTAssertNil   (sut.player.currentItem, "object should not be initialized")
    }
    
    // MARK: - update
    func test_replace_playerItem_shouldUpdateElements() {
        
        // Given
        let frame             = CGRect.zero
        let playerItem        = getVideo(.dog)
        let playerItemUpdated = getVideo(.dog2)
        let isMuted           = true
        
        // When
        sut = CLDVideoView(frame: frame, playerItem: playerItem, isMuted: isMuted)
        sut.replaceCurrentItem(with: playerItemUpdated)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertEqual (sut.player.currentItem, playerItemUpdated, "objects should be equal")
    }
}
