//
//  NormalizingProductAssetsViewController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 21/02/2024.
//

import Foundation
import UIKit
import Cloudinary

class NormalizingProductAssetsViewController: UIViewController {
    
    @IBOutlet weak var ivTopLeft: CLDUIImageView!
    @IBOutlet weak var ivTopRight: CLDUIImageView!
    @IBOutlet weak var ivMidRight: CLDUIImageView!
    @IBOutlet weak var ivBottomLeft: CLDUIImageView!
    @IBOutlet weak var ivBottomMid: CLDUIImageView!
    @IBOutlet weak var ivBottomRight: CLDUIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setImageViews()
    }

    private func setImageViews() {
        ivTopLeft.cldSetImage(publicId: "pexels-aditya-aiyar-1407354_tiw4bv", cloudinary: CloudinaryHelper.shared.cloudinary)
        ivTopRight.cldSetImage(publicId: "pexels-mnz-1670766_n9hfoi", cloudinary: CloudinaryHelper.shared.cloudinary)
        ivMidRight.cldSetImage(publicId: "pexels-wendy-wei-12511453_b4shho", cloudinary: CloudinaryHelper.shared.cloudinary)
        ivBottomLeft.cldSetImage(publicId: "Rectangle_1434_fcnobi", cloudinary: CloudinaryHelper.shared.cloudinary)
        ivBottomMid.cldSetImage(publicId: "Rectangle_1435_mwtszu", cloudinary: CloudinaryHelper.shared.cloudinary)
        ivBottomRight.cldSetImage(publicId: "Rectangle_1436_kdsfld", cloudinary: CloudinaryHelper.shared.cloudinary)

    }
}
