//
//  ConditionalProductViewController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 22/02/2024.
//

import Foundation
import UIKit
import Cloudinary

class ConditionalProductViewController: UIViewController {

    @IBOutlet weak var ivTopLeft: CLDUIImageView!
    @IBOutlet weak var ivTopRight: CLDUIImageView!
    @IBOutlet weak var ivBottom: CLDUIImageView!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setImageViews()
    }

    private func setImageViews() {
        ivTopLeft.cldSetImage(publicId: "Group_15_jda5ms", cloudinary: CloudinaryHelper.shared.cloudinary)

        ivTopRight.cldSetImage(publicId: "tshirt4_1_si0swc", cloudinary: CloudinaryHelper.shared.cloudinary)

        ivBottom.cldSetImage(publicId: "tshirt4_1_si0swc", cloudinary: CloudinaryHelper.shared.cloudinary, transformation: CLDTransformation().setOverlayWithLayer(CLDLayer().setPublicId(publicId: "Group_15_jda5ms")).setGravity(.northWest).setWidth(0.4).setX(10).setY(10))
    }
}
