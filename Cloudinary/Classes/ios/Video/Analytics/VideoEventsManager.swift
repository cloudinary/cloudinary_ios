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

    var trackingType: TrackingType = .auto

    var cloudName: String?

    var publicId: String?

    public init() {
        viewId = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
    }

    public func sendViewStartEvent(videoUrl: String, providedData: [String: Any]? = nil) {
        let event = VideoViewStartEvent(trackingType: trackingType, viewId: viewId, videoUrl: videoUrl, trackingData: ["cloudName": cloudName ?? "", "publicId": publicId ?? ""], providedData: providedData)
        addEventToQueue(event: event)
    }

    public func sendViewEndEvent(providedData: [String: Any]? = nil) {
        let event = VideoViewEnd(trackingType: trackingType, viewId: viewId,  providedData: providedData)
        addEventToQueue(event: event)
    }

    public func sendLoadMetadataEvent(duration: Int, providedData: [String: Any]? = nil) {
        let event = VideoLoadMetadata(trackingType: trackingType, viewId: viewId, duration: duration, providedData: providedData)
        addEventToQueue(event: event)
    }

    public func sendPlayEvent(providedData: [String: Any]? = nil) {
        let event = VideoPlayEvent(trackingType: trackingType, viewId: viewId, providedData: providedData)
        addEventToQueue(event: event)

    }

    public func sendPauseEvent(providedData: [String: Any]? = nil) {
        let event = VideoPauseEvent(trackingType: trackingType, viewId: viewId, providedData: providedData)
        addEventToQueue(event: event)
    }

    public var eventQueue = [VideoEvent]()

    func addEventToQueue(event: VideoEvent) {
        eventQueue.append(event)
    }

    @objc public func sendEvents() {
        guard !eventQueue.isEmpty else {
            print("Event queue is empty")
            return
        }

        let eventsToSend = Array(eventQueue.prefix(eventQueue.count))
        sendEventToEndpoint(childEvents: eventsToSend)
        eventQueue.removeFirst(eventsToSend.count)
    }

    private func sendEventToEndpoint(childEvents: [VideoEvent]) {
        var request = URLRequest(url: URL(string: CLD_ANALYTICS_ENDPOINT_PRODUCTION_URL)!)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()

        // Add events data

        body.append(contentsOf: "--\(boundary)\r\n".utf8)
        body.append(contentsOf: "Content-Disposition: form-data; name=\"userId\"\r\n\r\n".utf8)
        body.append(contentsOf: "\(childEvents[0].userId!)\r\n".utf8)

        body.append(contentsOf: "--\(boundary)\r\n".utf8)
        body.append(contentsOf: "Content-Disposition: form-data; name=\"viewId\"\r\n\r\n".utf8)
        body.append(contentsOf: "\(childEvents[0].viewId)\r\n".utf8)

        body.append(contentsOf: "--\(boundary)\r\n".utf8)
        body.append(contentsOf: "Content-Disposition: form-data; name=\"events\"\r\n\r\n".utf8)
        var eventData: [[String: Any]] = []
        for childEvent in childEvents {
            print("Sending event: \(childEvent.eventName)")
            eventData.append([
                VideoEventJSONKeys.eventName.rawValue: childEvent.eventName,
                VideoEventJSONKeys.eventTime.rawValue: childEvent.eventTime,
                VideoEventJSONKeys.eventDetails.rawValue: childEvent.eventDetails])
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: eventData, options: [])
            body.append(jsonData)
            body.append(contentsOf: "\r\n".utf8)
        } catch {
            print("Error creating JSON data: \(error)")
        }


        body.append(contentsOf: "--\(boundary)--\r\n".utf8)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending event: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) {
                //Success
            } else {
                print("Failed to send event. Response: \(response.debugDescription)")
            }
        }.resume()
    }
}
