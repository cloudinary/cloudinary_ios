//
//  VideoAnalytics.swift
//  Cloudinary
//
//  Created by Adi Mizrahi on 14/12/2023.
//

import Foundation

public typealias EventDetails = [String: Any]
typealias CustomerData = [String: Any]
typealias VideoData = [String: Any]
typealias ProvidedData = [String: Any]

public enum TrackingType: String {
    case manual = "manual"
    case auto = "auto"
}

public enum PlayerKeyPath: String {
    case status = "status"
    case timeControlStatus = "timeControlStatus"
    case duration = "duration"
}

enum AnalyticsType {
    case auto
    case manual
    case disabled
}

struct VideoPlayer {
    var type: String
    var version: String
}

public class VideoEvent {
    public var trackingType: TrackingType
    public var eventName: String
    public var eventTime: Int
    public var eventDetails: EventDetails

    init(trackingType: TrackingType, eventName: String, eventDetails: EventDetails? = nil) {
        self.trackingType = trackingType
        self.eventName = eventName
        self.eventTime = Int(Int64((Date().timeIntervalSince1970 * 1000.0).rounded()))
        self.eventDetails = eventDetails ?? [String: Any]()
        self.eventDetails[VideoEventJSONKeys.videoPlayer.rawValue] = createVideoPlayerObject()
    }

    func createVideoPlayerObject() -> [String: Any] {
        return [VideoEventJSONKeys.type.rawValue: "ios_player", VideoEventJSONKeys.version.rawValue: CLDNetworkCoordinator.DEFAULT_VERSION]
    }

    func createCustomerData(trackingData: [String: String]?, providedData: [String: Any]?) -> [String: Any] {
        var videoData = VideoData()
        videoData[VideoEventJSONKeys.cloudName.rawValue] = trackingData?[VideoEventJSONKeys.cloudName.rawValue] ?? ""
        videoData[VideoEventJSONKeys.publicId.rawValue] = trackingData?[VideoEventJSONKeys.publicId.rawValue] ?? ""

        var result: [String: Any] = [VideoEventJSONKeys.videoData.rawValue: videoData]

        if let providedData = providedData, !providedData.isEmpty {
            var providedDataObject = ProvidedData()
            providedData.forEach { (key, value) in
                providedDataObject[key] = value
            }
            result[VideoEventJSONKeys.providedData.rawValue] = providedDataObject
        }

        return result
    }

    func toDictonary() -> [String: Any] {
        var detailsDictionary: [String: Any] = [:]

        for (key, value) in eventDetails {
            detailsDictionary[key] = value
        }
        return [
            VideoEventJSONKeys.eventName.rawValue: eventName,
            VideoEventJSONKeys.eventName.rawValue: eventTime,
            VideoEventJSONKeys.eventDetails.rawValue: detailsDictionary
        ]
    }
}

public class VideoViewStartEvent: VideoEvent {
    public init(trackingType: TrackingType = .auto, videoUrl: String, trackingData: [String: String]?,providedData: [String: Any]? = nil) {
        var eventDetails = EventDetails()
        eventDetails[VideoEventJSONKeys.trackingType.rawValue] = trackingType.rawValue
        eventDetails[VideoEventJSONKeys.videoUrl.rawValue] = videoUrl
        let defaultEventName = EventNames.viewStart.rawValue
        super.init(trackingType: trackingType, eventName: defaultEventName, eventDetails: eventDetails)
        super.eventDetails[VideoEventJSONKeys.customerData.rawValue] = createCustomerData(trackingData: trackingData, providedData: providedData)
    }
}

public class VideoLoadMetadata: VideoEvent {
    public init(trackingType: TrackingType = .auto, duration: Int, providedData: [String: Any]? = nil) {
        var eventDetails = EventDetails()
        eventDetails[VideoEventJSONKeys.trackingType.rawValue] = trackingType.rawValue
        eventDetails[VideoEventJSONKeys.videoDuration.rawValue] = duration
        let defaultEventName = EventNames.loadMetadata.rawValue
        super.init(trackingType: trackingType, eventName: defaultEventName, eventDetails: eventDetails)
    }
}

public class VideoViewEnd: VideoEvent {
    public init(trackingType: TrackingType = .auto, providedData: [String: Any]? = nil) {
        var eventDetails = EventDetails()
        eventDetails[VideoEventJSONKeys.trackingType.rawValue] = trackingType.rawValue
        let defaultEventName = EventNames.viewEnd.rawValue
        super.init(trackingType: trackingType, eventName: defaultEventName, eventDetails: eventDetails)
    }
}

public class VideoPlayEvent: VideoEvent {
    public init(trackingType: TrackingType = .auto, providedData: [String: Any]? = nil) {
        let defaultEventName = EventNames.play.rawValue
        super.init(trackingType: trackingType, eventName: defaultEventName)
    }
}

public class VideoPauseEvent: VideoEvent {
    public init(trackingType: TrackingType = .auto, providedData: [String: Any]? = nil) {
        let defaultEventName = EventNames.pause.rawValue
        super.init(trackingType: trackingType, eventName: defaultEventName)
    }
}


public enum VideoEventJSONKeys: String {
    case userId = "userId"
    case trackingType = "trackingType"
    case viewId = "viewId"
    case events = "events"
    case eventName = "eventName"
    case eventTime = "eventTime"
    case eventDetails = "eventDetails"
    case videoPlayer = "videoPlayer"
    case videoUrl = "videoUrl"
    case videoDuration = "videoDuration"
    case videoPublicId = "videoPublicId"
    case transformation = "transfromation"
    case videoExtension = "videoExtension"
    case customerData = "customerData"
    case videoData = "videoData"
    case providedData = "providedData"
    case cloudName = "cloudName"
    case publicId = "publicId"
    case type = "type"
    case version = "version"
}

public enum EventNames: String {
    case viewStart = "viewStart"
    case viewEnd = "viewEnd"
    case loadMetadata = "loadMetadata"
    case play = "play"
    case pause = "pause"
}
