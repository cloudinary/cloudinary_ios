//
//  InnerUploadFrame.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 28/12/2023.
//

import Foundation
import UIKit

class InnerUploadFrame: UIView {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var vwGradientView: GradientView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let nibName = String(describing: type(of: self))
        if let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
        vwGradientView.layer.cornerRadius = vwGradientView.frame.height / 2
    }

    func setTitle(title: String) {
        lbTitle.text = title
    }

    func setSubtitle(subtitle: String) {
        lbSubtitle.text = subtitle
    }
}
