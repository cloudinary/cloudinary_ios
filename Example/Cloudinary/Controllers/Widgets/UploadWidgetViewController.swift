//
//  UploadWidgetViewController.swift
//  iOS_Geekle_Conference
//
//  Created by Adi Mizrahi on 19/09/2023.
//

import Foundation
import UIKit
import Cloudinary

class UploadWidgetViewController: UIViewController {

    @IBOutlet weak var vwUploadContainer: UIView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var ivMain: CLDUIImageView!
    @IBOutlet weak var vwOpenGallery: UIView!

    var cloudinary: CLDCloudinary!
    var uploadWidget: CLDUploaderWidget!

    var noCloudController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUploadButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CloudinaryHelper.shared.getUploadCloud() == nil {
            openNoCloudController()
        } else {
            cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: CloudinaryHelper.shared.getUploadCloud()!))
        }
        EventsHandler.shared.logEvent(event: EventObject(name: "Upload Widget"))
    }

    func setUploadButton() {
        vwOpenGallery.layer.cornerRadius = vwOpenGallery.frame.height / 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openUploadWidget))
        vwOpenGallery.addGestureRecognizer(tapGesture)
    }

    @objc func openUploadWidget() {
        let configuration = CLDWidgetConfiguration(
          uploadType: CLDUploadType(signed: false, preset: "ios_sample"))

        uploadWidget = CLDUploaderWidget(
          cloudinary: cloudinary,
          configuration: configuration,
          images: nil,
          delegate: self)

        uploadWidget.presentWidget(from: self)
    }

    @objc func stepBack() {
        self.dismiss(animated: true)
    }

    private func showUploadingView() {
        vwUploadContainer.isHidden = true
        aiLoading.isHidden = false

    }

    private func hideUploadingView() {
        self.aiLoading.isHidden = true
    }

    private func openNoCloudController() {
        noCloudController = UIStoryboard(name: "UploadNoCloud", bundle: nil).instantiateViewController(identifier: "UploadNoCloudController")
        (noCloudController as! UploadNoCloudController).delegate = self
//            currentController.modalPresentationStyle = .fullScreen
        self.present(noCloudController, animated: true)
    }
}

extension UploadWidgetViewController: CLDUploaderWidgetDelegate {
    func uploadWidget(_ widget: CLDUploaderWidget, willCall uploadRequests: [CLDUploadRequest]) {
      uploadRequests[0].response( { response, error in
          self.hideUploadingView()
          self.ivMain.cldSetImage(response!.secureUrl!, cloudinary: self.cloudinary)
      } )
    }
    func widgetDidCancel(_ widget: CLDUploaderWidget) {
    }
    func uploadWidgetDidDismiss() {
        showUploadingView()
    }
}

extension UploadWidgetViewController: UploadChoiceControllerDelegate {
    func switchToController(_ uploadState: UploadChoiceState, url: String?) {
        showUploadingView()
        cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: CloudinaryHelper.shared.getUploadCloud()!))
        if noCloudController != nil {
            noCloudController.dismiss(animated: true)
        }
    }

    func dismissController() {
    }
}
