//
//  GradientView.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 27/12/2023.
//

import Foundation
import UIKit
@IBDesignable
class GradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }

    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }

    func updateView() {
        guard let gradientLayer = layer as? CAGradientLayer else { return }

        gradientLayer.colors = [UIColor(red: 0.204, green: 0.282, blue: 0.773, alpha: 1).cgColor,
                                UIColor(red: 0.157, green: 0.733, blue: 0.98, alpha: 1).cgColor
                                ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top-left
               gradientLayer.endPoint = CGPoint(x: 1, y: 1)   // Bottom-right
//        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0.98, b: 0.98, c: -0.98, d: 0.45, tx: 0.5, ty: -0.21))
        gradientLayer.position = self.center
    }
}
