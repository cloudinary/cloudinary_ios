//
//  TransformationCell.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 30/01/2024.
//

import Foundation
import UIKit

class TransformationCell: UICollectionViewCell {
    @IBOutlet weak var ivMain: UIImageView!
    @IBOutlet weak var lbMain: UILabel!
    
    func setCellContent(_ index: Int) {
        switch index {
        case 0:
            ivMain.image = UIImage(named: "smart_cropping")
            lbMain.text = "Smart Cropping"
        case 1:
            ivMain.image = UIImage(named: "localization_branding")
            lbMain.text = "Localization & Branding"
        case 2:
            ivMain.image = UIImage(named: "background_normalizing")
            lbMain.text = "Background normalizing"
        case 3:
            ivMain.image = UIImage(named: "color_alternation")
            lbMain.text = "Color alternation"
        default:
            break
        }
    }
}
