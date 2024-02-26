//
//  WidgetsViewController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 25/01/2024.
//

import Foundation
import UIKit
import Cloudinary
import AVKit

class WidgetsViewController: UIViewController {

    @IBOutlet weak var vwImageWidgetVideo: UIView!
    @IBOutlet weak var vwUploadWidget: UIView!
    @IBOutlet weak var vwImageWidget: UIView!
    @IBOutlet weak var vwUploadWidgetVideo: UIView!

    var imageWidgetplayer: CLDVideoPlayer!
    var uploadWidgetplayer: CLDVideoPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUploadWidgetView()
        setImageWidgetView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUploadWidgetVideo()
        setImageWidgetVideo()
        EventsHandler.shared.logEvent(event: EventObject(name: "Widgets"))
    }

    private func setImageWidgetVideo() {
        imageWidgetplayer = CLDVideoPlayer(publicId: "DevApp_ImageUpload_02_vpsz7p", cloudinary: CloudinaryHelper.shared.cloudinary)
        configurePlayer(imageWidgetplayer, in: vwImageWidgetVideo)
    }

    private func setUploadWidgetVideo() {
        uploadWidgetplayer = CLDVideoPlayer(publicId: "DevApp_UploadWidget_02_r61cfi", cloudinary: CloudinaryHelper.shared.cloudinary)
        configurePlayer(uploadWidgetplayer, in: vwUploadWidgetVideo)
    }

    private func configurePlayer(_ player: CLDVideoPlayer, in view: UIView) {
        let playerLayer = AVPlayerLayer(player: player)
        view.backgroundColor = .black
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)

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
            uploadWidgetplayer.play()
            imageWidgetplayer.play()

        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setUploadWidgetView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadWidgetClicked))
        vwUploadWidget.addGestureRecognizer(tapGesture)
    }

    private func setImageWidgetView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageWidgetClicked))
        vwImageWidget.addGestureRecognizer(tapGesture)
    }

    @objc private func uploadWidgetClicked() {
        if let controller = UIStoryboard(name: "Base", bundle: nil).instantiateViewController(identifier: "BaseViewController") as? BaseViewController {
            controller.type = .UploadWidget
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }

    @objc private func imageWidgetClicked() {
        if let controller = UIStoryboard(name: "Base", bundle: nil).instantiateViewController(identifier: "BaseViewController") as? BaseViewController {
            controller.type = .ImageWidget
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
}
