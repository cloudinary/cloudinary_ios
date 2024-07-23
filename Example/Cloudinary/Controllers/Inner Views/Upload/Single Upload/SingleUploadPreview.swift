//
//  SingleUploadPreview.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 12/05/2024.
//

import Foundation
import UIKit
import Cloudinary
import AVKit

class SingleUploadPreview: UIViewController {

    var url: String!
    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: CloudinaryHelper.shared.getUploadCloud()!))

    @IBOutlet weak var vwShare: UIView!
    @IBOutlet weak var vwImage: UIView!
    @IBOutlet weak var ivMain: CLDUIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setShareView()
        if url.contains("video") {
                        let player = CLDVideoPlayer(url: url)
                            let playerController = AVPlayerViewController()

                            playerController.player = player
                            addChild(playerController)
                            playerController.videoGravity = .resizeAspect
                            vwImage.addSubview(playerController.view)
                            playerController.view.frame = vwImage.bounds
                            playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                            playerController.didMove(toParent: self)
                            player.play()
        } else {
            ivMain.cldSetImage(url, cloudinary: cloudinary)
        }
    }

    private func setShareView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(share))
        vwShare.addGestureRecognizer(gesture)
    }

    @objc private func share() {
        // Check if the image is available
        if let image = ivMain.image {
            // If image is available, share the image
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)

            // Present the activity view controller
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let viewController = window!.rootViewController {
                activityViewController.popoverPresentationController?.sourceView = viewController.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        } else {
            // If image is not available, share the URL
            guard let url = self.url else {
                return
            }

            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

            // Present the activity view controller
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if let viewController = window!.rootViewController {
                activityViewController.popoverPresentationController?.sourceView = viewController.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
