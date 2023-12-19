//
//  VideoEventsTests.swift
//  Cloudinary_Tests
//
//  Created by Adi Mizrahi on 18/12/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import Cloudinary
public class VideoEventTests: XCTestCase {

    func testVideoViewStartEventInitialization() {
        let videoUrl = "https://www.example.com/video.mp4"
        let trackingData = ["cloudName": "exampleCloud", "publicId": "abc123"]
        let providedData = ["key": "value"]

        let event = VideoViewStartEvent(videoUrl: videoUrl, trackingData: trackingData, providedData: providedData)

        XCTAssertEqual(event.eventName, EventNames.viewStart.rawValue)
        XCTAssertEqual(event.eventDetails[VideoEventJSONKeys.trackingType.rawValue] as? String, TrackingType.auto.rawValue)
        XCTAssertEqual(event.eventDetails[VideoEventJSONKeys.videoUrl.rawValue] as? String, videoUrl)

        if let customerData = event.eventDetails[VideoEventJSONKeys.customerData.rawValue] as? [String: Any],
           let videoData = customerData[VideoEventJSONKeys.videoData.rawValue] as? [String: Any] {
            XCTAssertEqual(videoData[VideoEventJSONKeys.cloudName.rawValue] as? String, trackingData["cloudName"])
            XCTAssertEqual(videoData[VideoEventJSONKeys.publicId.rawValue] as? String, trackingData["publicId"])
        }

        if let providedDataObject = event.eventDetails[VideoEventJSONKeys.providedData.rawValue] as? [String: Any] {
            XCTAssertEqual(providedDataObject["key"] as? String, providedData["key"])
        }
    }

    func testVideoLoadMetadataEventInitialization() {
        let duration = 120

        let event = VideoLoadMetadata(duration: duration)

        XCTAssertEqual(event.eventName, EventNames.loadMetadata.rawValue)
        XCTAssertEqual(event.eventDetails[VideoEventJSONKeys.trackingType.rawValue] as? String, TrackingType.auto.rawValue)
        XCTAssertEqual(event.eventDetails[VideoEventJSONKeys.videoDuration.rawValue] as? Int, duration)
    }

    func testVideoViewEndEventInitialization() {
        let providedData = ["key": "value"]

        let event = VideoViewEnd(providedData: providedData)

        XCTAssertEqual(event.eventName, EventNames.viewEnd.rawValue)
        XCTAssertEqual(event.eventDetails[VideoEventJSONKeys.trackingType.rawValue] as? String, TrackingType.auto.rawValue)

        if let providedDataObject = event.eventDetails[VideoEventJSONKeys.providedData.rawValue] as? [String: Any] {
            XCTAssertEqual(providedDataObject["key"] as? String, providedData["key"])
        }
    }

    func testVideoPlayEventInitialization() {
        let providedData = ["key": "value"]

        let event = VideoPlayEvent(providedData: providedData)

        XCTAssertEqual(event.eventName, EventNames.play.rawValue)

        if let providedDataObject = event.eventDetails[VideoEventJSONKeys.providedData.rawValue] as? [String: Any] {
            XCTAssertEqual(providedDataObject["key"] as? String, providedData["key"])
        }
    }

    func testVideoPauseEventInitialization() {
        let providedData = ["key": "value"]

        let event = VideoPauseEvent(providedData: providedData)

        XCTAssertEqual(event.eventName, EventNames.pause.rawValue)

        if let providedDataObject = event.eventDetails[VideoEventJSONKeys.providedData.rawValue] as? [String: Any] {
            XCTAssertEqual(providedDataObject["key"] as? String, providedData["key"])
        }
    }
}
