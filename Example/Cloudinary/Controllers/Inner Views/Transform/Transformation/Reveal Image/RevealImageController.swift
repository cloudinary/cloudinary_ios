//
//  RevealImageController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 30/01/2024.
//

import Foundation
import UIKit

class RevealImageController: UIViewController {

    @IBOutlet weak var ivMain: RevealImageView!

    func setMainImageView(rightImage: String?, leftImage: String?) {
        ImageHelper.getImageFromURL(URL(string: rightImage!)!) { image in
            DispatchQueue.main.async {
                self.ivMain.rightImage = image
            }
        }
        ImageHelper.getImageFromURL(URL(string: leftImage!)!) { image in
            DispatchQueue.main.async {
                self.ivMain.leftImage = image
            }
        }
    }

}
