//
//  RevealImageView.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 08/01/2024.
//

import Foundation
import UIKit
class RevealImageView: UIImageView {

    public var leftImage: UIImage? {
        didSet {
            if let img = leftImage {
                leftImageLayer.contents = img.cgImage
            }
        }
    }
    public var rightImage: UIImage? {
        didSet {
            if let img = rightImage {
                self.image = img
            }
        }
    }

    // private properties
    private let leftImageLayer = CALayer()
    private let maskLayer = CALayer()
    private let lineView = UIView()
    private var pct: CGFloat = 0.5 {
        didSet {
            updateView()
        }
    }

    convenience init() {
        self.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        // any opaque color
        maskLayer.backgroundColor = UIColor.black.cgColor
        leftImageLayer.mask = maskLayer
        // the "reveal" image layer
        layer.addSublayer(leftImageLayer)

        // the vertical line
        lineView.backgroundColor = .white
        addSubview(lineView)

        isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first
        else { return }
        let loc = t.location(in: self)
        pct = loc.x / bounds.width
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first
        else { return }
        let loc = t.location(in: self)
        pct = loc.x / bounds.width
    }

    private func updateView() {
        // move the vertical line to the touch point
        lineView.frame = CGRect(x: bounds.width * pct, y: bounds.minY, width: 4, height: bounds.height)

        // update the "left image" mask to the touch point
        var r = bounds
        r.size.width = bounds.width * pct

        // disable layer animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.frame = r
        CATransaction.commit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        leftImageLayer.frame = bounds
        updateView()
    }
}
