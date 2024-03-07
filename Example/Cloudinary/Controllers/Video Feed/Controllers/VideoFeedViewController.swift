import Foundation
import Cloudinary
import UIKit
import AVKit

class VideoFeedViewController: UIViewController {
    
    var videoURL: String?
    @IBOutlet weak var vwVideoView: UIView!
    @IBOutlet weak var vwVideoOverlay: UIView!
    
    private var player: CLDVideoPlayer?
    
    static func getInstance(url: String) -> VideoFeedViewController {
        let storyboard = UIStoryboard(name: "VideoFeed", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "VideoFeedViewController") as? VideoFeedViewController else {
            fatalError("Unable to instantiate VideoFeedViewController from the storyboard.")
        }
        viewController.videoURL = url
        return viewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EventsHandler.shared.logEvent(event: EventObject(name: "Video Feed"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func addVideoOverlay(_ playerController: AVPlayerViewController) {
        // Load the view controller from the "VideoSocialOverlay" storyboard
        let overlayViewController = UIStoryboard(name: "VideoSocialOverlays", bundle: nil).instantiateViewController(withIdentifier: "VideoSocialOverlaysController")
        
        // Add the overlay view controller as a child of AVPlayerViewController
        playerController.addChild(overlayViewController)
        overlayViewController.didMove(toParent: playerController)
        
        // Add the overlay view controller's view as a subview to playerController's contentOverlayView
        playerController.contentOverlayView?.addSubview(overlayViewController.view)
        overlayViewController.view.frame = playerController.contentOverlayView?.bounds ?? .zero
        overlayViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupPlayer() {
        guard let videoURLString = videoURL else {
            return
        }
        
        if isViewLoaded == false {
            _ = view
        }
        
        player = CLDVideoPlayer(url: videoURLString)
        player?.isMuted = true
        let playerController = AVPlayerViewController()
        playerController.player = player
        addChild(playerController)
        playerController.videoGravity = .resizeAspectFill
        playerController.showsPlaybackControls = false
        vwVideoView.addSubview(playerController.view)
        playerController.view.frame = vwVideoView.bounds
        playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerController.didMove(toParent: self)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
        addVideoOverlay(playerController)
    }
    
    func playVideo() {
        player?.play()
    }
    
    @objc func playerItemDidReachEnd() {
        // Seek to the start of the video to loop it
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
