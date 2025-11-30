//
//  CLDVideoPlayer.swift
//
//  Copyright (c) 2018 Cloudinary (http://cloudinary.com)
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

import Foundation
import AVKit


@available(iOS 10.0, *)
@objcMembers open class CLDVideoPlayer: AVPlayer {

    var automaticStreamingProfile: Bool = false

    var analytics: Bool = true
    var isIntialized: Bool = false
    var loadMetadataSent: Bool = false

    var publicId: String?

    var transformation: CLDTransformation?

    var eventsManager: VideoEventsManager = VideoEventsManager()

    var providedData: [String: Any]?

    override init() {
        super.init()
        setAnalyticsObservers()
    }

    /**
     Download a video asynchronously from the specified URL and set it to the AVPlayer video.

     - parameter publicId:                      The remote asset's name (e.g. the public id of an uploaded image).
     - parameter cloudinary:                    An instance of CLDCloudinary.
     - parameter transformation:                An instance of CLDTransformation.
     - parameter automaticStreamingProfile:     A bool to indicate the use of automatic streaming profile default: false

     */
    public init(publicId: String, cloudinary: CLDCloudinary, transformation: CLDTransformation? = nil, automaticStreamingProfile: Bool? = false) {
        var cloudinary = cloudinary
        cloudinary.config.analyticsObject.setFeatureFlag(flag: "F")
        var transformation = transformation
        var cldUrl = cloudinary.createUrl()
        if automaticStreamingProfile ?? false && transformation == nil {
            cldUrl = cldUrl.setFormat("m3u8")
            transformation = CLDTransformation().setStreamingProfile("auto")
        }
        guard let urlString = cldUrl.setResourceType(.video)
            .setTransformation(transformation ?? CLDTransformation())
            .generate(publicId), let url = URL(string: urlString) else {
            print("Error - could not generate URL for CLDVideoPlayer")
            super.init()
            return
        }
        super.init(url: url)
    }

    /**
     Initializes a CLDVideoPlayer instance, using a given AVPlayerItem.

     - parameter item:  The player item to put into AVPlayer

     */
    public override init(playerItem item: AVPlayerItem?) {
        super.init(playerItem: item)
    }

    /**
     Initializes a CLDVideoPlayer instance, using a given URL.

     - parameter url:  The URL to put into AVPlayer

     */
    public override init(url URL: URL) {
        super.init(url: URL)
    }

    /**
     Initializes a CLDVideoPlayer instance, using a given URL.

     - parameter url:  The string to put into AVPlayer

     */
    public init(url string: String) {
        guard let url = URL(string: string) else {
            print("Error - could not generate URL for CLDVideoPlayer")
            super.init()
            return
        }
        super.init(url: url)
    }

    public func setAnalytics(_ analyticsType: AnalyticsType, cloudName: String?, publicId: String?) {
        switch analyticsType {
        case .auto:
            eventsManager.trackingType = .auto
            eventsManager.cloudName = cloudName ?? ""
            eventsManager.publicId = publicId ?? self.publicId
            break
        case .manual:
            eventsManager.trackingType = .manual
            eventsManager.cloudName = cloudName ?? ""
            eventsManager.publicId = publicId ?? self.publicId
            break
        case .disabled:
            analytics = false
        }
    }

    public func flushEvents() {
        guard analytics else { return }
        eventsManager.sendEvents()
    }

    public func flushEventsAndCloseSession() {
        guard analytics else { return }
        eventsManager.sendViewEndEvent(providedData: providedData)
        flushEvents()
    }

    deinit {
        guard analytics else { return }
        removeObserver(self, forKeyPath: PlayerKeyPath.status.rawValue)
        removeObserver(self, forKeyPath: PlayerKeyPath.timeControlStatus.rawValue)
        flushEventsAndCloseSession()
    }

    func setAnalyticsObservers() {
        guard analytics else {
            return
        }
        addObserver(self, forKeyPath: PlayerKeyPath.status.rawValue, options: [.new], context: nil)
        addObserver(self, forKeyPath: PlayerKeyPath.timeControlStatus.rawValue, options: [.new], context: nil)
    }

    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let path = keyPath, let changes = change else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        switch path {
        case PlayerKeyPath.status.rawValue:
            if let newStatusNumber = changes[.newKey] as? NSNumber, let newStatus = AVPlayer.Status(rawValue: newStatusNumber.intValue) {
                handleStatusChanged(newStatus)
            }
        case PlayerKeyPath.timeControlStatus.rawValue:
            if let newStatusNumber = changes[.newKey] as? NSNumber, let newStatus = AVPlayer.TimeControlStatus(rawValue: newStatusNumber.intValue) {
                handleTimeControlStatusChanged(newStatus)
            }
        default:
            super.observeValue(forKeyPath: path, of: object, change: changes, context: context)
        }
    }

}

@available(iOS 10.0, *)
extension CLDVideoPlayer {
    func handleStatusChanged(_ status: AVPlayer.Status) {
        switch status {
        case .readyToPlay:
            if let assetURL = self.currentItem?.asset as? AVURLAsset {
                let mediaURL = assetURL.url
                eventsManager.sendViewStartEvent(videoUrl: mediaURL.absoluteString, providedData: providedData)
                isIntialized = true

                loadDurationAsynchronously()
            }
            break
        case .failed:
            // Playback failed
            break
        case .unknown:
            // Unknown status
            break
        @unknown default:
            break
        }
    }
    
    private func loadDurationAsynchronously() {
        guard let currentItem = self.currentItem else { return }
        
        let asset = currentItem.asset
        let durationKey = "duration"
        
        // Load the duration key asynchronously
        asset.loadValuesAsynchronously(forKeys: [durationKey]) { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                var error: NSError?
                let status = asset.statusOfValue(forKey: durationKey, error: &error)
                
                switch status {
                case .loaded:
                    let duration = asset.duration
                    var durationInSeconds = 0
                    
                    if duration.isValid && duration.isNumeric && !duration.isIndefinite {
                        let durationSeconds = CMTimeGetSeconds(duration)
                        
                        if durationSeconds.isFinite && !durationSeconds.isNaN {
                            durationInSeconds = Int(durationSeconds)
                        }
                    }
                    
                    if !self.loadMetadataSent {
                        self.loadMetadataSent = true
                        self.eventsManager.sendLoadMetadataEvent(duration: durationInSeconds)
                    }
                case .failed, .cancelled:
                    print("Failed to load duration: \(error?.localizedDescription ?? "Unknown error")")
                case .loading:
                    // Still loading, could retry or wait
                    break
                case .unknown:
                    // Unknown status
                    break
                @unknown default:
                    break
                }
            }
        }
    }

    func handleTimeControlStatusChanged(_ status: AVPlayer.TimeControlStatus) {
        switch status {
        case .playing:
            eventsManager.sendPlayEvent(providedData: providedData)
        case .paused:
            // Player paused
            if isIntialized {
                if self.timeControlStatus == .paused {
                    eventsManager.sendPauseEvent(providedData: providedData)
                }
            }
        case .waitingToPlayAtSpecifiedRate:
            break
        @unknown default:
            break
        }
    }

    public func setProvidedData(data: [String: Any]) {
        providedData = data
    }
}
