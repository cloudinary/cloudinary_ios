//
//  VideoFeedController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 04/02/2024.
//

import Foundation
import UIKit

class VideoFeedController: UIViewController {
    @IBOutlet weak var vwBack: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.bringSubviewToFront(vwBack)
    }

    private func setBackButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backClicked))
        vwBack.addGestureRecognizer(tapGesture)
    }


    @objc private func backClicked() {
        self.dismiss(animated: true)
    }
}
