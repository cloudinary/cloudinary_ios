//
//  UploaderWidgetVideoDisplayLinkTests.swift
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

class UploaderWidgetVideoDisplayLinkTests: NetworkBaseTest, CLDDisplayLinkObserverDelegate {
    
    var sut: CLDDisplayLinkObserver!
    
    func displayLinkObserverDidTick(_ linkObserver: CLDDisplayLinkObserver) {}
    
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
                
        // When
        sut = CLDDisplayLinkObserver(delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.tickerTimestamp, "object should be initialized")
    }
    func test_init_noDelegate_shouldCreateElement() {
                
        // When
        sut = CLDDisplayLinkObserver(delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.tickerTimestamp, "object should be initialized")
    }
    
    // MARK: - internal methods
    func test_startTicker_shouldStartTheTickerLogic() {
                
        // When
        sut = CLDDisplayLinkObserver(delegate: nil)
        sut.startTicker()
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.tickerTimestamp, "object should be initialized")
        XCTAssertNotNil(sut.displayLinkTicker, "object should be initialized")
    }
    func test_stopTicker_shouldStopTheTickerLogic() {
                
        // When
        sut = CLDDisplayLinkObserver(delegate: nil)
        sut.startTicker()
        sut.stopTicker()
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.tickerTimestamp, "object should be initialized")
        XCTAssertNil   (sut.displayLinkTicker, "object should not be initialized")
    }
    
    func test_isValid_notRunning_shouldRepresentCurrentTickerState() {
                
        // When
        sut = CLDDisplayLinkObserver(delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.tickerTimestamp, "object should be initialized")
        XCTAssertFalse (sut.isValid(), "object should not be valid")
    }
    func test_isValid_running_shouldRepresentCurrentTickerState() {
                
        // When
        sut = CLDDisplayLinkObserver(delegate: nil)
        sut.startTicker()
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.tickerTimestamp, "object should be initialized")
        XCTAssertTrue  (sut.isValid(), "object should be valid")
    }
}
