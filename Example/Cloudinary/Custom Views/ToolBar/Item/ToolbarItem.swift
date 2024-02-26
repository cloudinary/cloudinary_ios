//
//  ToolbarItem.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 27/12/2023.
//

import Foundation
import UIKit
class ToolbarItem: UIView {

    @IBOutlet weak var ivMain: UIImageView!
    @IBOutlet weak var lbMain: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ToolbarItem", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func selectItem() {
        ivMain.tintColor = UIColor(named: "primary")
        lbMain.textColor = UIColor(named: "primary")
    }

    func unselectItem() {
        ivMain.tintColor = UIColor(named: "text_not_selected")
        lbMain.textColor = UIColor(named: "text_not_selected")
    }
}

