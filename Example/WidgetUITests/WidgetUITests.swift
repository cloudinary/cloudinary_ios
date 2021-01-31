//
//  WidgetUITests.swift
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

import XCTest

class WidgetUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        
        app = nil
    }

    // MARK: - rotate button
    func test_rotateStates_on_shouldShowRotateButton() {
             
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        app.buttons[UITestConstants.widgetViewControllerActionButton].tap()
        
        let rotateButton = app.buttons[UITestConstants.editViewControllerRotateButton]
        
        // Then
        XCTAssertTrue(rotateButton.exists, "button should exist")
        XCTAssertTrue(rotateButton.isEnabled, "button should be enabled")
    }
    func test_rotateStates_off_shouldNotShowRotateButton() {
           
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.switches[UITestConstants.rotateStateSwitch].swipeLeft()
        
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        app.buttons[UITestConstants.widgetViewControllerActionButton].tap()
        
        let rotateButton = app.buttons[UITestConstants.editViewControllerRotateButton]
        
        // Then
        XCTAssertFalse(rotateButton.exists, "button should not exist")
    }
    
    // MARK: - action button
    func test_actionButtonStates_noVideoEnabledAndOff_shouldShowActionButtonWithText() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        let actionButton = app.buttons[UITestConstants.widgetViewControllerActionButton]
        actionButton.tap()
        
        // Then
        XCTAssertTrue (actionButton.exists, "button should exist")
        XCTAssertTrue (actionButton.isEnabled, "button should be enabled")
        XCTAssertEqual(actionButton.label, "Aspect ratio unlocked ", "button label should be set to string")
    }
    func test_actionButtonStates_noVideoEnabledAndOn_shouldShowActionButtonWithText() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.aspectLockSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        let actionButton = app.buttons[UITestConstants.widgetViewControllerActionButton]
        actionButton.tap()
        
        // Then
        XCTAssertTrue (actionButton.exists, "button should exist")
        XCTAssertTrue (actionButton.isEnabled, "button should be enabled")
        XCTAssertEqual(actionButton.label, "Aspect ratio locked ", "button label should be set to string")
    }
    func test_actionButtonStates_noVideoDisabled_shouldHideActionButton() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.aspectLockSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        app.buttons[UITestConstants.widgetViewControllerActionButton].tap()
        let actionButton = app.buttons[UITestConstants.widgetViewControllerActionButton]
        
        // Then
        XCTAssertTrue (actionButton.exists, "button should exist")
        XCTAssertFalse(actionButton.isEnabled, "button should be disabled")
        XCTAssertEqual(actionButton.label, String(), "button label should be set to empty string")
    }
    func test_actionButtonStates_withVideoEnabledAndOff_shouldShowActionButtonWithText() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        let actionButton = app.buttons[UITestConstants.widgetViewControllerActionButton]
        actionButton.tap()
        
        // Then
        XCTAssertTrue (actionButton.exists, "button should exist")
        XCTAssertFalse(actionButton.isEnabled, "button should be disabled")
        XCTAssertEqual(actionButton.label, String(), "button label should be set to empty string")
    }
    func test_actionButtonStates_withVideoEnabledAndOn_shouldShowActionButtonWithText() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.aspectLockSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        let actionButton = app.buttons[UITestConstants.widgetViewControllerActionButton]
        actionButton.tap()
        
        // Then
        XCTAssertTrue (actionButton.exists, "button should exist")
        XCTAssertFalse(actionButton.isEnabled, "button should be disabled")
        XCTAssertEqual(actionButton.label, String(), "button label should be set to empty string")
    }
    func test_actionButtonStates_withVideoDisabled_shouldHideActionButton() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.aspectLockSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        app.buttons[UITestConstants.widgetViewControllerActionButton].tap()
        let actionButton = app.buttons[UITestConstants.widgetViewControllerActionButton]
        
        // Then
        XCTAssertTrue (actionButton.exists, "button should exist")
        XCTAssertFalse(actionButton.isEnabled, "button should be disabled")
        XCTAssertEqual(actionButton.label, String(), "button label should be set to empty string")
    }
    
    // MARK: - collection view
    func test_collectionView_many_shouldHaveManyCells() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        let secondCell = app.collectionViews.children(matching: .cell).element(boundBy: 1)
        
        // Then
        XCTAssertTrue(secondCell.exists, "second cell should exist")
    }
    func test_collectionView_oneImage_shouldHaveOneCell() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let firstCell = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        let secondCell = app.collectionViews.children(matching: .cell).element(boundBy: 1)
        
        // Then
        XCTAssertTrue(firstCell.exists, "one cell should exist")
        XCTAssertFalse(secondCell.exists, "only one cell should exist")
    }
    func test_collectionView_oneVideo_shouldHaveOneCell() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let firstCell = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        let secondCell = app.collectionViews.children(matching: .cell).element(boundBy: 1)
        
        // Then
        XCTAssertTrue(firstCell.exists, "one cell should exist")
        XCTAssertFalse(secondCell.exists, "only one cell should exist")
    }
    func test_collectionView_none_shouldPresentImagePicker() {
        
        // Given
        let existsPredicate = NSPredicate(format: "exists == true")
       
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        let imagePicker = app.navigationBars[UITestConstants.photos]
        
        // wait for image picker to load
        expectation(for: existsPredicate, evaluatedWith: imagePicker, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        // Then
        XCTAssertTrue(imagePicker.exists, "if no assets added to the widget, image picker should be presented")
    }
    
    // MARK: - video view
    func test_videoView_oneVideo_shouldBePresented() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let isHittable = app.otherElements[UITestConstants.previewViewControllerVideoView].isHittable
        
        // Then
        XCTAssertTrue(isHittable, "video view should be presented when video is selected")
    }
    func test_videoView_mixAssets_shouldBePresented() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 0).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 0).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let isHittable = app.otherElements[UITestConstants.previewViewControllerVideoView].isHittable
        
        // Then
        XCTAssertTrue(isHittable, "video view should be presented when video is selected")
    }
    func test_videoView_noVideo_shouldNotBePresented() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let presented = app.otherElements[UITestConstants.previewViewControllerVideoView].exists
        
        // Then
        XCTAssertFalse(presented, "video view should not be presented when video is not selected")
    }
    
    // MARK: - video controls view
    func test_videoControlView_oneVideo_shouldExist() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let videoControlExists = app.otherElements[UITestConstants.videoControlsView].exists
        
        // Then
        XCTAssertTrue(videoControlExists, "video control should exist in this situation")
    }
    func test_videoControlViewButton_oneVideo_shouldBeHittble() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let isHittable = app.buttons[UITestConstants.videoViewPausePlayButton].isHittable
        
        // Then
        XCTAssertTrue(isHittable, "pausePlayButton should be presented when video is selected")
    }
    func test_videoControlViewButton_oneVideo_shouldUpdateTextOnPress() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let initialButtonText = app.buttons[UITestConstants.videoViewPausePlayButton].label
        app.buttons[UITestConstants.videoViewPausePlayButton].tap()
        let updatedButtonText = app.buttons[UITestConstants.videoViewPausePlayButton].label
        
        // Then
        XCTAssertNotEqual(initialButtonText, updatedButtonText, "pressing pausePlayButton should change its state and text")
    }
    func test_videoControlViewTimer_oneVideo_videoControlViewShouldDisappearAfterShortTime() {
        
        // Given
        let hittablePredicate = NSPredicate(format: "isHittable == false")
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let pausePlayButton = app.buttons[UITestConstants.videoViewPausePlayButton]
        
        // wait for pausePlayButton to disappear
        expectation(for: hittablePredicate, evaluatedWith: pausePlayButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        // Then
        XCTAssertFalse(pausePlayButton.exists, "playPauseButton should disappear after a few seconds when the video is playing and showing the controls")
    }
    func test_videoControlView_backgroundPressed_videoControlViewShouldDisappear() {
                
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
       
        // tap() will tap in the middle (on the button!) this code will force background press
        let videoControls = app.otherElements[UITestConstants.videoControlsView]
        let normalized = videoControls.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: 10, dy: 10))
        coordinate.tap()
        
        let pausePlayButton = app.buttons[UITestConstants.videoViewPausePlayButton]
        
        // Then
        XCTAssertFalse(pausePlayButton.exists, "playPauseButton should disappear after a few seconds when the video is playing and showing the controls")
    }
    
    // MARK: - video player view
    func test_videoPlayerView_oneVideo_shouldExist() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 2).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        let videoPlayerExists = app.otherElements[UITestConstants.videoPlayerView].exists
        
        // Then
        XCTAssertTrue(videoPlayerExists, "video player should exist when video view is presented")
    }
    
    // MARK: - image video transitions
    func test_imageVideoTransitions_videoToImage_shouldNotPresentVideoView() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        app.collectionViews.children(matching: .cell).element(boundBy: 1).tap()
        
        let presented = app.otherElements[UITestConstants.previewViewControllerVideoView].exists
        
        // Then
        XCTAssertFalse(presented, "video view should not be presented when video is not selected")
    }
    func test_imageVideoTransitions_videoToImageToVideo_shouldPresentVideoView() {
        
        // When
        app.buttons[UITestConstants.goToWidgetBarButton].tap()
        app.segmentedControls[UITestConstants.initialImagesSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.segmentedControls[UITestConstants.initialVideosSegmented].children(matching: .button).element(boundBy: 1).tap()
        app.buttons[UITestConstants.widgetSettingsPresentBarButton].tap()
        
        app.collectionViews.children(matching: .cell).element(boundBy: 1).tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        
        let presented = app.otherElements[UITestConstants.previewViewControllerVideoView].exists
        
        // Then
        XCTAssertTrue(presented, "video view should be presented when video is selected")
    }
    
}

class UITestConstants {
    
    static let goToWidgetBarButton              = "goToWidgetBarButton"
    static let widgetSettingsPresentBarButton   = "widgetSettingsPresentBarButton"
    static let widgetViewControllerActionButton = "widgetViewControllerActionButton"
    static let editViewControllerRotateButton   = "editViewControllerRotateButton"
    static let rotateStateSwitch                = "rotateStateSwitch"
    static let aspectLockSegmented              = "aspectLockSegmented"
    static let initialImagesSegmented           = "initialImagesSegmented"
    static let initialVideosSegmented           = "initialVideosSegmented"
    static let allPhotos                        = "All Photos"
    static let photos                           = "Photos"
    
    static let previewViewControllerVideoView   = "previewViewControllerVideoView"
    static let videoViewPausePlayButton         = "videoViewPausePlayButton"
    static let videoControlsView                = "videoControlsView"
    static let videoPlayerView                  = "videoPlayerView"
}
