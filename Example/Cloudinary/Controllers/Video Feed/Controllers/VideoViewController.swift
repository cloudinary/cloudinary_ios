//
//  VideoViewController.swift
//  ios-video-testing
//
//  Created by Adi Mizrahi on 16/11/2023.
//

import Foundation
import UIKit
import Cloudinary
import AVKit

class VideoViewController: UIViewController {

    @IBOutlet weak var vwVideoView: UIView!

    @IBOutlet weak var cvVideoFeed: UICollectionView!

    var collectionController: VideoFeedCollectionController!

    var playerController: AVPlayerViewController!
    var player: CLDVideoPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setVideoView()
        setVideoFeedCollectionView()
        EventsHandler.shared.logEvent(event: EventObject(name: "Video"))
    }

    private func setVideoView() {
        player = CLDVideoPlayer(url: "https://res.cloudinary.com/mobiledemoapp/video/upload/v1706627936/Demo%20app%20content/sport-1_tjwumh.mp4")
        playerController = AVPlayerViewController()
        playerController.player = player
        addChild(playerController)
        playerController.videoGravity = .resizeAspectFill
        vwVideoView.addSubview(playerController.view)
        playerController.view.frame = vwVideoView.bounds
        playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerController.didMove(toParent: self)
    }

    private func setVideoFeedCollectionView() {
        collectionController = VideoFeedCollectionController(self)
        cvVideoFeed.delegate = collectionController
        cvVideoFeed.dataSource = collectionController
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        player.seek(to: .zero) // Seek to the beginning of the video
        player.play()
    }
}

extension VideoViewController: VideoFeedCollectionDelegate {
    func cellClicked(_ index: Int) {
        if let controller = UIStoryboard(name: "VideoFeed", bundle: nil).instantiateViewController(identifier: "VideoFeedController") as? VideoFeedController {
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
}
