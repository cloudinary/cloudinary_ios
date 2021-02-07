//
//  CLDVideoView.swift
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

import UIKit
import AVKit

class CLDVideoView: UIView {

    private(set) var videoControlsView: CLDVideoControlsView!
    private(set) var videoPlayerView  : CLDVideoPlayerView!
    private(set) var player           : AVPlayer
    
    /**
    Initializes the CLDVideoView

    - parameter frame:         The view's frame
    - parameter player:        The player for the presented video

    - returns:                 A new CLDVideoView instance.
    */
    init(frame: CGRect, playerItem: AVPlayerItem?, isMuted: Bool) {
        
        self.player = AVPlayer(playerItem: playerItem)
        self.player.isMuted = isMuted
        
        super.init(frame: frame)
        
        createUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    /**
    Plays a new video and adjust the controls

    - parameter item:         The new AVPlayerItem to play
    */
    func replaceCurrentItem(with item: AVPlayerItem) {

        player.seek(to: CMTime.zero)
        player.replaceCurrentItem(with: item)
        videoControlsView.resetControls()
    }
    
    /**
    Pausing the video player
    */
    func pauseVideo() {
        player.pause()
    }
}

// MARK: - CLDVideoControlsViewDelegate
extension CLDVideoView: CLDVideoControlsViewDelegate {
    
    func playPressedOnVideoControls(_ videoControls: CLDVideoControlsView) {
        player.play()
    }
    
    func pausePressedOnVideoControls(_ videoControls: CLDVideoControlsView) {
        player.pause()
    }
}

// MARK: - create UI
extension CLDVideoView {
    
    private func createUI() {
        
        videoControlsView = CLDVideoControlsView(frame: frame, delegate: self)
        videoControlsView.accessibilityIdentifier = "videoControlsView"
        videoPlayerView   = CLDVideoPlayerView  (frame: frame)
        videoPlayerView.accessibilityIdentifier = "videoPlayerView"
        
        addSubview(videoPlayerView)
        addSubview(videoControlsView)
        
        videoPlayerView  .cld_addConstraintsToFill(self)
        videoControlsView.cld_addConstraintsToFill(self)
        
        guard let playerLayer = videoPlayerView.playerLayer else { return }
        playerLayer.player = player
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoEnded), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        player.play()
    }
    
    @objc private func videoEnded() {
        
        player.seek(to: CMTime.zero)
        videoControlsView.videoEnded()
    }
}
