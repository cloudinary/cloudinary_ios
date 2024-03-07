//
//  IntegrateAIViewController.swift
//  Cloudinary_Example
//
//  Created by Adi Mizrahi on 26/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary
import AVKit

class IntegrateAIViewController: UIViewController {

    @IBOutlet weak var vwVideoView: UIView!

    var videoPublicId: String = ""
    var player: CLDVideoPlayer!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setVideoView()
    }

    private func setVideoView() {
        player = CLDVideoPlayer(publicId: videoPublicId, cloudinary: CloudinaryHelper.shared.cloudinary)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = vwVideoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        vwVideoView.layer.addSublayer(playerLayer)

        // Add observer for AVPlayerItemDidPlayToEndTime
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)

        player.play()
    }

    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            // Seek to the start of the video to loop it
            playerItem.seek(to: .zero)
            player.play()
        }
    }
}
