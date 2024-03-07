//
//  UploadLoadingView.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 11/01/2024.
//

import Foundation
import UIKit

class UploadLoadingView: UIView {

    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
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
        let nib = UINib(nibName: "UploadLoadingView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    func startAnimation() {
        aiLoading.startAnimating()
    }

    func stopAnimation() {
        aiLoading.stopAnimating()
    }

}

