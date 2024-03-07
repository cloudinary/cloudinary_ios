//
//  VideoFeedContainerController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 04/02/2024.
//

import Foundation
import UIKit

class VideoFeedContainerController: UIViewController {
    @IBOutlet weak var vwFeedContainer: UIView!
    var videoURL: String!
    var controller: VideoFeedViewController!


    func setupPlayer() {
        if isViewLoaded == false {
            _ = view
        }

        controller = UIStoryboard(name: "VideoFeed", bundle: nil).instantiateViewController(identifier: "VideoFeedViewController")
        if let controller = controller {
            controller.videoURL = videoURL
            controller.setupPlayer()

            controller.view.frame = vwFeedContainer.bounds
            vwFeedContainer.addSubview(controller.view)
            controller.didMove(toParent: self)
        }
    }

    func playVideo() {
        controller.playVideo()
    }
}
