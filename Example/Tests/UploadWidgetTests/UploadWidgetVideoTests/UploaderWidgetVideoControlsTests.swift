//
//  UploaderWidgetVideoControlsTests.swift
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

class UploaderWidgetVideoControlsTests: NetworkBaseTest, CLDVideoControlsViewDelegate {
    
    var sut: CLDVideoControlsView!
    
    func pausePressedOnVideoControls(_ videoControls: CLDVideoControlsView) {}
    func playPressedOnVideoControls(_ videoControls: CLDVideoControlsView) {}
    
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
        let frame = CGRect.zero
        
        // When
        sut = CLDVideoControlsView(frame: frame, delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.playPauseButton, "object should be initialized")
        XCTAssertNotNil(sut.visibilityTimer, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertNotNil(sut.currentState, "object should be initialized")
        XCTAssertNotNil(sut.shownAndPlayingState, "object should be initialized")
        XCTAssertNotNil(sut.shownAndPausedState, "object should be initialized")
        XCTAssertNotNil(sut.hiddenAndPlayingState, "object should be initialized")
        XCTAssertNotNil(sut.hiddenAndPausedState, "object should be initialized")
    }
    
    func test_init_noDelegate_shouldCreateElement() {
        
        // Given
        let frame = CGRect.zero
        
        // When
        sut = CLDVideoControlsView(frame: frame, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.playPauseButton, "object should be initialized")
        XCTAssertNotNil(sut.visibilityTimer, "object should be initialized")
        XCTAssertNil   (sut.delegate, "object should not be initialized")
        XCTAssertNotNil(sut.currentState, "object should be initialized")
        XCTAssertNotNil(sut.shownAndPlayingState, "object should be initialized")
        XCTAssertNotNil(sut.shownAndPausedState, "object should be initialized")
        XCTAssertNotNil(sut.hiddenAndPlayingState, "object should be initialized")
        XCTAssertNotNil(sut.hiddenAndPausedState, "object should be initialized")
    }
    
    // MARK: - states
    func test_initialState_shownAndPlayingState_shouldBeEqualToExpectedState() {
        
        // Given
        let frame = CGRect.zero
        
        // When
        sut = CLDVideoControlsView(frame: frame, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.currentState, "object should be initialized")
        XCTAssertEqual (sut.currentState as? CLDVideoShownAndPlayingState, sut.shownAndPlayingState as? CLDVideoShownAndPlayingState, "objects should be equal")
    }
    
    func test_updateState_shownAndPausedState_shouldUpdateState() {
        
        // Given
        let frame = CGRect.zero
        
        // When
        sut = CLDVideoControlsView(frame: frame, delegate: nil)
        sut.setNewState(newState: sut.shownAndPausedState)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.currentState, "object should be initialized")
        XCTAssertEqual (sut.currentState as? CLDVideoShownAndPausedState, sut.shownAndPausedState as? CLDVideoShownAndPausedState,"objects should be equal")
    }
    func test_updateState_hiddenAndPlayingState_shouldUpdateState() {
        
        // Given
        let frame = CGRect.zero
        
        // When
        sut = CLDVideoControlsView(frame: frame, delegate: nil)
        sut.setNewState(newState: sut.hiddenAndPlayingState)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.currentState, "object should be initialized")
        XCTAssertEqual (sut.currentState as? CLDVideoHiddenAndPlayingState, sut.hiddenAndPlayingState as? CLDVideoHiddenAndPlayingState,"objects should be equal")
    }
    func test_updateState_hiddenAndPausedState_shouldUpdateState() {
        
        // Given
        let frame = CGRect.zero
        
        // When
        sut = CLDVideoControlsView(frame: frame, delegate: nil)
        sut.setNewState(newState: sut.hiddenAndPausedState)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.currentState, "object should be initialized")
        XCTAssertEqual (sut.currentState as? CLDVideoShownAndPausedState, sut.hiddenAndPausedState as? CLDVideoShownAndPausedState,"objects should be equal")
    }
}
