//
//  VideoEventsManagerTests.swift
//  Cloudinary_Tests
//
//  Created by Adi Mizrahi on 14/12/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import Cloudinary
final class VideoEventsManagerTests: XCTestCase {
    var videoEventManager: VideoEventsManager!

    override func setUp() {
        super.setUp()
        videoEventManager = VideoEventsManager()
        // Additional setup if needed
    }

    override func tearDown() {
        videoEventManager = nil
        super.tearDown()
    }

    func testAddingEventsToQueue() {
        let initialQueueCount = videoEventManager.eventQueue.count

        // Call functions that add events to the queue

        // Example:
        videoEventManager.sendViewStartEvent(videoUrl: "testURL")
        videoEventManager.sendViewEndEvent()
        videoEventManager.sendPlayEvent()

        XCTAssertEqual(videoEventManager.eventQueue.count, initialQueueCount + 3)
    }

    func testSendingEvents() {
        // Create an expectation for async testing
        let expectation = XCTestExpectation(description: "Events sent successfully")

        // Assuming you have mock URLSession or use a testable endpoint to avoid actual network calls
        videoEventManager.CLD_ANALYTICS_ENDPOINT_DEVELOPMENT_URL = "http://localhost:3001/mock_events" // Change to a mock endpoint

        // Add events to the queue
        videoEventManager.sendViewStartEvent(videoUrl: "testURL")
        videoEventManager.sendViewEndEvent()
        videoEventManager.sendPlayEvent()
        videoEventManager.sendEvents()
        // Simulate sending events
        //           videoEventManager.sendEvents()

        // Wait for a certain amount of time or use a completion block to verify successful sending
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
            // Assuming the response is received
            // Check if event queue is empty after sending
            XCTAssertTrue(self.videoEventManager.eventQueue.isEmpty)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 16.0) // Wait for an expectation
    }
}
