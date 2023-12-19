//
//  VideoEventsManager.swift
//  Cloudinary
//
//  Created by Adi Mizrahi on 14/12/2023.
//

import Foundation
@objcMembers public class VideoEventsManager {

    let CLD_ANALYTICS_ENDPOINT_PRODUCTION_URL: String = "https://video-analytics-api.cloudinary.com/v1/video-analytics"
    public var CLD_ANALYTICS_ENDPOINT_DEVELOPMENT_URL = ""

    var viewId: String

    var userId: String!

    var trackingType: TrackingType = .auto

    var cloudName: String?

    var publicId: String?

    public init() {
        viewId = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
        userId = getUserId()
    }

    func getUserId() -> String {
        if let userId = UserDefaults.standard.string(forKey: "CLDVideoPlayerUserId") {
            return userId
        } else {
            var newUserId = UUID().uuidString
            newUserId = newUserId.lowercased().replacingOccurrences(of: "-", with: "")
            UserDefaults.standard.set(newUserId, forKey: "CLDVideoPlayerUserId")
            return newUserId
        }
    }

    public func sendViewStartEvent(videoUrl: String, providedData: [String: Any]? = nil) {
        let event = VideoViewStartEvent(trackingType: trackingType, videoUrl: videoUrl, trackingData: ["cloudName": cloudName ?? "", "publicId": publicId ?? ""], providedData: providedData)
        addEventToQueue(event: event)
    }

    public func sendViewEndEvent(providedData: [String: Any]? = nil) {
        let event = VideoViewEnd(trackingType: trackingType,  providedData: providedData)
        addEventToQueue(event: event)
    }

    public func sendLoadMetadataEvent(duration: Int, providedData: [String: Any]? = nil) {
        let event = VideoLoadMetadata(trackingType: trackingType, duration: duration, providedData: providedData)
        addEventToQueue(event: event)
    }

    public func sendPlayEvent(providedData: [String: Any]? = nil) {
        let event = VideoPlayEvent(trackingType: trackingType, providedData: providedData)
        addEventToQueue(event: event)

    }

    public func sendPauseEvent(providedData: [String: Any]? = nil) {
        let event = VideoPauseEvent(trackingType: trackingType, providedData: providedData)
        addEventToQueue(event: event)
    }

    public var eventQueue = [VideoEvent]()
    private var timer: Timer?

    func addEventToQueue(event: VideoEvent) {
        eventQueue.append(event)
    }

    @objc public func sendEvents() {
        guard !eventQueue.isEmpty else {
            return
        }

        let eventsToSend = Array(eventQueue.prefix(eventQueue.count))
        sendEventToEndpoint(childEvents: eventsToSend)
        eventQueue.removeFirst(eventsToSend.count)
    }

    private func buildFormDataPart(boundary: String, name: String, value: String? = nil) -> Data {
        var body = Data()
        body.append(contentsOf: "--\(boundary)\r\n".utf8)
        body.append(contentsOf: "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".utf8)
        if let value = value {
            body.append(contentsOf: "\(value)\r\n".utf8)
        }
        return body
    }

    private func buildEventsData(childEvents: [VideoEvent]) -> Data? {
        var body = Data()
        var eventData: [[String: Any]] = []
        for childEvent in childEvents {
            eventData.append([
                VideoEventJSONKeys.eventName.rawValue: childEvent.eventName,
                VideoEventJSONKeys.eventTime.rawValue: childEvent.eventTime,
                VideoEventJSONKeys.eventDetails.rawValue: childEvent.eventDetails])
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: eventData, options: [])
            body.append(jsonData)
            body.append(contentsOf: "\r\n".utf8)
            return body
        } catch {
            print("Error creating JSON data: \(error)")
            return nil
        }

    }

    private func sendEventToEndpoint(childEvents: [VideoEvent]) {
        var request = URLRequest(url: URL(string: CLD_ANALYTICS_ENDPOINT_PRODUCTION_URL)!)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("ios_video_player_analytics_test", forHTTPHeaderField: "User-Agent")
        var body = Data()

        // Add events data
        body.append(buildFormDataPart(boundary: boundary, name: "userId", value: userId))
        body.append(buildFormDataPart(boundary: boundary, name: "viewId", value: viewId))
        body.append(buildFormDataPart(boundary: boundary, name: "events"))
        body.append(buildEventsData(childEvents: childEvents)!)
        body.append(contentsOf: "--\(boundary)--\r\n".utf8)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending event: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) {
                print("Event sent successfully")
            } else {
                print("Failed to send event. Response: \(response.debugDescription)")
            }
        }.resume()
    }
}
