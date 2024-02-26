//
//  SplashController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 27/12/2023.
//

import Foundation
import UIKit
class SplashViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let delayInSeconds: TimeInterval = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            self.transitionToMainController()
        }
        EventsHandler.shared.logEvent(event: EventObject(name: "Splash"))
    }

    func transitionToMainController() {
        // Instantiate your main view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your actual storyboard name
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") // Replace "MainViewController" with your actual view controller identifier

        // Transition to the main view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate {
            delegate.window?.rootViewController = mainViewController
        }
    }
}
