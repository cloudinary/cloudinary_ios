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
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app = nil
    }

    // MARK: - rotate button
    func test_rotateStates_on_shouldShowRotateButton() {
             
        // When
        app.buttons["goToWidgetBarButton"].tap()
        app.buttons["widgetSettingsPresentBarButton"].tap()
        app.buttons["widgetViewControllerActionButton"].tap()
        
        let rotateButton = app.buttons["editViewControllerRotateButton"]
        
        // Then
        XCTAssertTrue(rotateButton.exists, "button should exist")
        XCTAssertTrue(rotateButton.isEnabled, "button should be enabled")
    }
    func test_rotateStates_off_shouldNotShowRotateButton() {
           
        // When
        app.buttons["goToWidgetBarButton"].tap()
        app.switches["rotateStateSwitch"].swipeLeft()
        
        app.buttons["widgetSettingsPresentBarButton"].tap()
        app.buttons["widgetViewControllerActionButton"].tap()
        
        let rotateButton = app.buttons["editViewControllerRotateButton"]
        
        // Then
        XCTAssertFalse(rotateButton.exists, "button should not exist")
    }
    
    // MARK: - action button
    func test_actionButtonStates_EnabledAndOff_shouldShowActionButtonWithText() {
        
        // When
        app.buttons["goToWidgetBarButton"].tap()
        app.buttons["widgetSettingsPresentBarButton"].tap()
        let actionButton = app.buttons["widgetViewControllerActionButton"]
        actionButton.tap()
        
        // Then
        XCTAssertTrue (actionButton.exists, "button should exist")
        XCTAssertTrue (actionButton.isEnabled, "button should be enabled")
        XCTAssertEqual(actionButton.label, "Aspect ratio unlocked ", "button label should be set to string")
    }
    func test_actionButtonStates_EnabledAndOn_shouldShowActionButtonWithText() {
        
        // When
        app.buttons["goToWidgetBarButton"].tap()
        app.segmentedControls["aspectLockSegmented"].children(matching: .button).element(boundBy: 1).tap()
        app.buttons["widgetSettingsPresentBarButton"].tap()
        let actionButton = app.buttons["widgetViewControllerActionButton"]
        actionButton.tap()
        
        // Then
        XCTAssertTrue (actionButton.exists, "button should exist")
        XCTAssertTrue (actionButton.isEnabled, "button should be enabled")
        XCTAssertEqual(actionButton.label, "Aspect ratio locked ", "button label should be set to string")
    }
    func test_actionButtonStates_disabled_shouldHideActionButton() {
        
        // When
        app.buttons["goToWidgetBarButton"].tap()
        app.segmentedControls["aspectLockSegmented"].children(matching: .button).element(boundBy: 2).tap()
        app.buttons["widgetSettingsPresentBarButton"].tap()
        app.buttons["widgetViewControllerActionButton"].tap()
        let actionButton = app.buttons["widgetViewControllerActionButton"]
        
        // Then
        XCTAssertTrue (actionButton.exists, "button should exist")
        XCTAssertFalse(actionButton.isEnabled, "button should be disabled")
        XCTAssertEqual(actionButton.label, String(), "button label should be set to empty string")
    }
    
    // MARK: - collection view
    func test_collectionView_many_shouldHaveManyCells() {
        
        // When
        app.buttons["goToWidgetBarButton"].tap()
        app.buttons["widgetSettingsPresentBarButton"].tap()
        let secondCell = app.collectionViews.children(matching: .cell).element(boundBy: 1)
        
        // Then
        XCTAssertTrue(secondCell.exists, "second cell should exist")
    }
    func test_collectionView_one_shouldHaveOneCell() {
        
        // When
        app.buttons["goToWidgetBarButton"].tap()
        app.segmentedControls["initialImagesSegmented"].children(matching: .button).element(boundBy: 1).tap()
        app.buttons["widgetSettingsPresentBarButton"].tap()
        
        let secondCell = app.collectionViews.children(matching: .cell).element(boundBy: 1)
        
        // Then
        XCTAssertFalse(secondCell.exists, "only one cell should exist")
    }
    func test_collectionView_none_shouldPresentImagePicker() {
        
        // Given
        let existsPredicate = NSPredicate(format: "exists == true")
       
        // When
        app.buttons["goToWidgetBarButton"].tap()
        app.segmentedControls["initialImagesSegmented"].children(matching: .button).element(boundBy: 2).tap()
        app.buttons["widgetSettingsPresentBarButton"].tap()
        let imagePicker = app.collectionViews["PhotosGridView"]
        
        
        // wait for image picker to load
        expectation(for: existsPredicate, evaluatedWith: imagePicker, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        // Then
        XCTAssertTrue(imagePicker.exists, "if no assets added to the widget, image picker should be presented")
    }
}
