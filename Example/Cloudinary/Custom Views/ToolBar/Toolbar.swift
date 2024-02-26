//
//  Toolbar.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 27/12/2023.
//

import Foundation
import UIKit

protocol ToolbarDelegate {
    func deliverySelected()
    func uploadSelected()
    func widgetsSelected()
    func videoSelected()
}


class Toolbar: UIView {
    @IBOutlet weak var vwDelivery: ToolbarItem!
    @IBOutlet weak var vwUpload: ToolbarItem!
    @IBOutlet weak var vwWidgets: ToolbarItem!
    @IBOutlet weak var vwVideo: ToolbarItem!

    var delegate: ToolbarDelegate

    init(frame: CGRect, delegate: ToolbarDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        let nibName = String(describing: type(of: self))
        if let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
        setItems()
        setupGestures()
        selectItem(.Delivery)
    }

    private func setItems() {
        vwDelivery.ivMain.image = UIImage(named: "car-speed-limiter")
        vwDelivery.lbMain.text = "Delivery"

        vwUpload.ivMain.image = UIImage(named: "upload")
        vwUpload.lbMain.text = "Upload"

        vwWidgets.ivMain.image = UIImage(named: "widgets")
        vwWidgets.lbMain.text = "Widgets"

        vwVideo.ivMain.image = UIImage(named: "video")
        vwVideo.lbMain.text = "Video"
    }

    private func setupGestures() {
        let deliveryTapGesture = UITapGestureRecognizer(target: self, action: #selector(deliveryViewTapped))
        vwDelivery.addGestureRecognizer(deliveryTapGesture)

        let uploadTapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadViewTapped))
        vwUpload.addGestureRecognizer(uploadTapGesture)

        let widgetTapGesture = UITapGestureRecognizer(target: self, action: #selector(widgetsViewTapped))
        vwWidgets.addGestureRecognizer(widgetTapGesture)

        let videoTapGesture = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped))
        vwVideo.addGestureRecognizer(videoTapGesture)
    }

    @objc private func deliveryViewTapped() {
        selectItem(.Delivery)
    }

    @objc private func uploadViewTapped() {
        selectItem(.Upload)
    }

    @objc private func widgetsViewTapped() {
        selectItem(.Widgets)
    }

    @objc private func videoViewTapped() {
        selectItem(.Video)
    }

    private func selectItem(_ item: ToolbarOptions) {
        switch item {
        case .Delivery:
            vwDelivery.selectItem()
            vwUpload.unselectItem()
            vwWidgets.unselectItem()
            vwVideo.unselectItem()
            delegate.deliverySelected()
            break
        case .Upload:
            vwDelivery.unselectItem()
            vwUpload.selectItem()
            vwWidgets.unselectItem()
            vwVideo.unselectItem()
            delegate.uploadSelected()
            break
        case .Widgets:
            vwDelivery.unselectItem()
            vwUpload.unselectItem()
            vwWidgets.selectItem()
            vwVideo.unselectItem()
            delegate.widgetsSelected()
            break
        case .Video:
            vwDelivery.unselectItem()
            vwUpload.unselectItem()
            vwWidgets.unselectItem()
            vwVideo.selectItem()
            delegate.videoSelected()
            break
        }
    }

    private func unselectItem(_ item: ToolbarOptions) {
        switch item {
        case .Delivery:
            break
        case .Upload:
            break
        case .Widgets:
            break
        case .Video:
            break
        }
    }
}
enum ToolbarOptions {
    case Delivery
    case Upload
    case Widgets
    case Video
}
