//
//  AnimationHelper.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 03/01/2024.
//

import Foundation
import UIKit
class AnimationHelper {

    public static func animateOut(view: UIView) {
        UIView.animate(withDuration: 0.5) {
            view.alpha = 0
        } completion: { _ in
            view.removeFromSuperview()
        }
    }

    public static func animateTabController(_ vwContainer: UIView, _ newController: UIViewController, currentViewController: UIViewController?, completion: @escaping () -> Void) {

        let animationDirection = getAnimationDirection(newController, currentViewController)
        // Add new controller as child

        // Add the new controller's view
        vwContainer.addSubview(newController.view)

        // Perform the animation
        if animationDirection == .leftToRight {
            newController.view.frame = CGRect(x: vwContainer.bounds.width, y: 0, width: vwContainer.bounds.width, height: vwContainer.bounds.height)
            UIView.animate(withDuration: 0.5) {
                // Slide the current view out to the left
                if let viewController = currentViewController {
                    viewController.view.frame.origin.x = -vwContainer.bounds.width
                }

                // Slide the new view in from the right
                newController.view.frame.origin.x = 0
            } completion: { (_) in
                completion()
            }
        } else {
            newController.view.frame = CGRect(x: -vwContainer.bounds.width, y: 0, width: vwContainer.bounds.width, height: vwContainer.bounds.height)
            UIView.animate(withDuration: 0.25) {
                if let viewController = currentViewController {
                    viewController.view.frame.origin.x = vwContainer.bounds.width
                }

                // Slide the new view in from the left
                newController.view.frame.origin.x = 0
            } completion: { (_) in
                completion()
            }
        }
    }


    private static func getAnimationDirection(_ newController: UIViewController, _ currentController: UIViewController?) -> AnimationDirection {
        guard let currentController = currentController else {
            return .leftToRight
        }
        if let _ = newController as? DeliveryViewController {
            return .rightToLeft;
        }
        if let _ = newController as? UploadViewController {
            if let _ = currentController as? DeliveryViewController {
                return .leftToRight
            } else {
                return .rightToLeft
            }
        }
        return .leftToRight
    }

    public static func animateTitleOut(_ view: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            view.alpha = 0.0
        })
    }

    public static func animateTitleIn(_ view: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            view.alpha = 1.0
        })
    }

    enum AnimationDirection {
        case rightToLeft
        case leftToRight
    }
}

