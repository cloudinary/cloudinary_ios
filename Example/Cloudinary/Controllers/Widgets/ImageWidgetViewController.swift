//
//  ImageWidgetViewController.swift
//  iOS_Geekle_Conference
//
//  Created by Adi Mizrahi on 19/09/2023.
//

import Foundation
import UIKit
import Cloudinary

class ImageWidgetViewController: UIViewController {
    @IBOutlet weak var ivLocal: CLDUIImageView!
    @IBOutlet weak var ivRemote: CLDUIImageView!
    @IBOutlet weak var ivCloudinary: CLDUIImageView!

    let cloudinary = CloudinaryHelper.shared.cloudinary

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalImage()
        setRemoteImage()
        setCloudinaryImage()
        EventsHandler.shared.logEvent(event: EventObject(name: "Image Widget"))
    }

    private func setLocalImage() {
        ivLocal.image = UIImage(named: "house")
    }

    private func setRemoteImage() {
        ivRemote.cldSetImage("https://res.cloudinary.com/mobiledemoapp/image/upload/v1706628181/Demo%20app%20content/Frame_871_ao5o4r.jpg", cloudinary: cloudinary)
    }

    private func setCloudinaryImage() {
        ivCloudinary.cldSetImage(publicId: "Demo%20app%20content/Frame_871_ao5o4r", cloudinary: cloudinary)
    }
}
