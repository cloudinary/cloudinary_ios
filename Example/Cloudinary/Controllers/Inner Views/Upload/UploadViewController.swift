//
//  UploadViewController.swift
//  iOS_Geekle_Conference
//
//  Created by Adi Mizrahi on 18/09/2023.
//

import Foundation
import UIKit
import Cloudinary

class UploadViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vwUpload: InnerUploadFrame!
    @IBOutlet weak var vwUploadLarge: InnerUploadFrame!
    @IBOutlet weak var vwFetchUpload: InnerUploadFrame!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViews()
        EventsHandler.shared.logEvent(event: EventObject(name: "Upload"))
    }

    private func setViews() {
        setUploadView()
        setUploadLargeView()
        setFetchUploadView()
    }

    private func setUploadView() {
        vwUpload.setTitle(title: "Upload")
        vwUpload.setSubtitle(subtitle: "Everything starts when you uploads a file")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadClicked))
        vwUpload.addGestureRecognizer(tapGesture)
    }

    private func setUploadLargeView() {
        vwUploadLarge.setTitle(title: "Upload large file")
        vwUploadLarge.setSubtitle(subtitle: "Share your big files up to 100GB")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadLargeClicked))
        vwUploadLarge.addGestureRecognizer(tapGesture)
    }

    private func setFetchUploadView() {
        vwFetchUpload.setTitle(title: "Fetch Upload")
        vwFetchUpload.setSubtitle(subtitle: "Upload image from any URL to your cloud")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fetchUploadClicked))
        vwFetchUpload.addGestureRecognizer(tapGesture)
    }

    @objc private func uploadClicked() {
        if let controller = UIStoryboard(name: "Base", bundle: nil).instantiateViewController(identifier: "BaseViewController") as? BaseViewController {
            controller.type = .Upload
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }

    @objc private func uploadLargeClicked() {
        if let controller = UIStoryboard(name: "Base", bundle: nil).instantiateViewController(identifier: "BaseViewController") as? BaseViewController {
            controller.type = .UploadLarge
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }

    @objc private func fetchUploadClicked() {
        if let controller = UIStoryboard(name: "Base", bundle: nil).instantiateViewController(identifier: "BaseViewController") as? BaseViewController {
            controller.type = .FetchUpload
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
}


