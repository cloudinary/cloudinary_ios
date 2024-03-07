//
//  VideoFeedCell.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 31/01/2024.
//

import Foundation
import UIKit

class VideoFeedCell: UICollectionViewCell {

    @IBOutlet weak var vwGradientView: GradientView!
    @IBOutlet weak var ivMain: UIImageView!

    func setImage(_ index: Int) {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = false
        vwGradientView.layer.cornerRadius = 4
        vwGradientView.layer.masksToBounds = false
        switch index {
        case 0:
            ivMain.image = UIImage(named: "tiktok")
        case 1:
            ivMain.image = UIImage(named: "instagram")
        case 2:
            ivMain.image = UIImage(named: "youtube")
        default:
            break
        }
    }
}
