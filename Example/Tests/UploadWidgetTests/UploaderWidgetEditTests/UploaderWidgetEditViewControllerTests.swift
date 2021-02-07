//
//  UploaderWidgetEditViewControllerTests.swift
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

class UploaderWidgetEditViewControllerTests: NetworkBaseTest, CLDWidgetEditDelegate {
    
    var sut: CLDWidgetEditViewController!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Helper
    func createImageContainer() -> CLDWidgetAssetContainer {
        return CLDWidgetAssetContainer(originalImage: getImage(.logo), editedImage: getImage(.logo))
    }
    
    // MARK: - delegate
    func widgetEditViewController(_ controller: CLDWidgetEditViewController, didFinishEditing image: CLDWidgetAssetContainer) {
        print("delegate didFinishEditing")
    }
    func widgetEditViewControllerDidReset(_ controller: CLDWidgetEditViewController) {
        print("delegate didReset")
    }
    func widgetEditViewControllerDidCancel(_ controller: CLDWidgetEditViewController) {
        print("delegate didCancel")
    }
    
    // MARK: - test init
    func test_init_emptyImage_shouldCreateObject() {
        
        // Given
        let image = CLDWidgetAssetContainer(originalImage: UIImage(), editedImage: UIImage())
        
        // When
        sut = CLDWidgetEditViewController(image: image)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
    }
    func test_init_emptyProperties_shouldCreateObject() {
        
        // Given
        let image = CLDWidgetAssetContainer(originalImage: UIImage(), editedImage: UIImage())
        
        // When
        sut = CLDWidgetEditViewController(image: image, configuration: nil, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
    }
    func test_init_properties_shouldCreateObjectWithProperties() {
        
        // Given
        let image = createImageContainer()
        let configuration = CLDWidgetConfiguration(allowRotate: true, initialAspectLockState: .enabledAndOn)
        
        // When
        sut = CLDWidgetEditViewController(image: image, configuration: configuration, delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
        XCTAssertEqual (sut.configuration, configuration, "objects should be equal")
        XCTAssertEqual (sut.image, image, "objects should be equal")
    }
    func test_init_delegateAfterInit_shouldCreateObjectAndUpdateDelegate() {
        
        // Given
        let image = createImageContainer()
        let configuration = CLDWidgetConfiguration(allowRotate: true, initialAspectLockState: .enabledAndOn)
        
        // When
        sut = CLDWidgetEditViewController(image: image, configuration: configuration, delegate: nil)
        sut.delegate = self
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
        XCTAssertEqual (sut.configuration, configuration, "objects should be equal")
        XCTAssertEqual (sut.image, image, "objects should be equal")
    }
    
    // MARK: - test views
    func test_createView_shouldCreateObjectWithUIElements() {

        // Given
        let image = createImageContainer()

        // When
        sut = CLDWidgetEditViewController(image: image)
        let _ = sut.view

        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.buttonsView, "object should be initialized")
        XCTAssertNotNil(sut.cancelButton, "object should be initialized")
        XCTAssertNotNil(sut.rotateButton, "object should be initialized")
        XCTAssertNotNil(sut.doneButton, "object should be initialized")
        XCTAssertNotNil(sut.cropView, "object should be initialized")
    }
    func test_createView_shouldCreateCustomButtonsInSameSuperview() {

        // Given
        let image = createImageContainer()

        // When
        sut = CLDWidgetEditViewController(image: image)
        let _ = sut.view

        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertEqual (sut.cancelButton.buttonType, .custom, "objects should be equal")
        XCTAssertEqual (sut.rotateButton.buttonType, .custom, "objects should be equal")
        XCTAssertEqual (sut.doneButton.buttonType, .custom, "objects should be equal")
        XCTAssertEqual (sut.cancelButton.superview, sut.buttonsView, "objects should be equal")
        XCTAssertEqual (sut.rotateButton.superview, sut.buttonsView, "objects should be equal")
        XCTAssertEqual (sut.doneButton.superview, sut.buttonsView, "objects should be equal")
    }
    func test_createView_allowRotateTrue_rotateButtonShouldBeVisible() {

        // Given
        let image = createImageContainer()
        let configuration = CLDWidgetConfiguration(allowRotate: true, initialAspectLockState: .enabledAndOn)

        // When
        sut = CLDWidgetEditViewController(image: image, configuration: configuration)
        let _ = sut.view

        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertFalse (sut.rotateButton.isHidden, "rotate button should be visible when allowRotate = true")
    }
    func test_createView_allowRotateFalse_rotateButtonShouldBeHidden() {

        // Given
        let image = createImageContainer()
        let configuration = CLDWidgetConfiguration(allowRotate: false, initialAspectLockState: .enabledAndOn)

        // When
        sut = CLDWidgetEditViewController(image: image, configuration: configuration)
        let _ = sut.view

        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertTrue (sut.rotateButton.isHidden, "rotate button should be hidden when allowRotate = false")
    }
}
