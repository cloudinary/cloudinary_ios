//
//  MainPageController.swift
//  ios-video-testing
//
//  Created by Adi Mizrahi on 16/11/2023.
//

import Foundation
import UIKit

class MainPageController: UIPageViewController {

    var videoControllersList = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let videoLinksData = VideoHelper.parsePlist() ?? [String]()

        for link in videoLinksData {
            if let controller = UIStoryboard(name: "VideoFeed", bundle: nil).instantiateViewController(identifier: "VideoFeedContainerController") as? VideoFeedContainerController {
                _ = controller.view
                controller.videoURL = link
                controller.setupPlayer()
                controller.modalPresentationStyle = .fullScreen
                videoControllersList.append(controller)
            }
        }
        self.dataSource = self
        (videoControllersList[0] as! VideoFeedContainerController).playVideo()
        setViewControllers([videoControllersList[0]], direction: .forward, animated: true, completion: nil)
    }
}

extension MainPageController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let indexOfCurrentPageViewController = videoControllersList.index(of: viewController)!
    if indexOfCurrentPageViewController == 0 {
     return nil // To show there is no previous page
    } else {
      // Previous UIViewController instance
        guard let controller = videoControllersList[indexOfCurrentPageViewController - 1] as? VideoFeedContainerController else {
            return videoControllersList[indexOfCurrentPageViewController - 1]
        }
        controller.playVideo()
      return videoControllersList[indexOfCurrentPageViewController - 1]
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let indexOfCurrentPageViewController = videoControllersList.index(of: viewController)!
    if indexOfCurrentPageViewController == videoControllersList.count - 1 {
      return nil // To show there is no next page
    } else {
      // Next UIViewController instance
        guard let controller = videoControllersList[indexOfCurrentPageViewController + 1] as? VideoFeedContainerController else {
            return videoControllersList[indexOfCurrentPageViewController + 1]
        }
        controller.playVideo()
        return videoControllersList[indexOfCurrentPageViewController + 1]
    }
  }
}
