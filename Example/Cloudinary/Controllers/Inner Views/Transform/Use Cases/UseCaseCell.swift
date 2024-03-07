//
//  UseCaseCell.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 30/01/2024.
//

import Foundation
import UIKit

class UseCaseCell: UICollectionViewCell {

    @IBOutlet weak var lbMain: UILabel!
    @IBOutlet weak var vwGradient: GradientView!

    func setCellBy(index: Int) {
        switch index {
        case 0:
            lbMain.text = "Normalizing Product Assets - Sizing"
        case 1:
            lbMain.text = "Conditional Product Badging"
        case 2:
            lbMain.text = "Adapt video to any screen"
        case 3:
            lbMain.text = "Integrate AI-generated backgrounds"
        default:
            break
        }
    }
}
