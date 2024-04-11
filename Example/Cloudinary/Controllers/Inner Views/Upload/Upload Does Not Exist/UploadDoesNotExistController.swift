//
//  UploadDoesNotExistController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 30/01/2024.
//

import Foundation
import UIKit
import Cloudinary

class UploadDoesNotExistController: UIViewController {
    @IBOutlet weak var vwUploadContainer: UIView!
    @IBOutlet weak var vwUpload: UIView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!
    @IBOutlet weak var lbUploadButton: UILabel!
    @IBOutlet weak var lbUploadContainer: UILabel!

    private var imagePicker: UIImagePickerController!
    weak var delegate: UploadChoiceControllerDelegate!

    var uploadWidget: CLDUploaderWidget!

    var type: UploadViewType = .Upload

    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: CloudinaryHelper.shared.getUploadCloud()!))

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch type {
        case .Upload:
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload"))
        case .UploadLarge:
            lbUploadButton.text = "Upload Video"
            lbUploadContainer.text = "Upload your video now and let the magic begin!"
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload Large"))
        case .UploadWidget:
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload Widget"))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUploadImageView()
    }

    func setUploadImageView() {
        vwUpload.layer.cornerRadius = vwUpload.frame.height / 2

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadClicked))
        vwUpload.addGestureRecognizer(tapGesture)
    }

    @objc private func uploadClicked() {
        if type == .UploadWidget {
            openUploadWidget()
        } else {
            if imagePicker == nil {
                imagePicker = UIImagePickerController()
            }
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                if type == .UploadLarge {
                    imagePicker.mediaTypes = ["public.movie"]
                }
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }

    private func openUploadWidget() {
        let configuration = CLDWidgetConfiguration(
          uploadType: CLDUploadType(signed: false, preset: "ios_sample"))

        uploadWidget = CLDUploaderWidget(
          cloudinary: cloudinary,
          configuration: configuration,
          images: nil,
          delegate: self)

        uploadWidget.presentWidget(from: self)
    }

    private func showUploadingView() {
            vwUploadContainer.isHidden = true
            aiLoading.isHidden = false
    }

    private func hideUploadingView() {
        self.aiLoading.isHidden = true
    }

    func uploadImage(_ image: UIImage) {
        showUploadingView()
        let data = image.pngData()
        cloudinary.createUploader().upload(data: data!, uploadPreset: "ios_sample", completionHandler:  { response, error in
            DispatchQueue.main.async {
                self.delegate.switchToController(.UploadExist, url: response?.secureUrl)
                self.hideUploadingView()
            }
        })
    }

    func uploadVideo(_ url: NSURL) {
        showUploadingView()
        let params = CLDUploadRequestParams()
        params.setResourceType("video")
        cloudinary.createUploader().upload(url: url as URL, uploadPreset: "ios_sample", params: params, completionHandler:  { response, error in
            DispatchQueue.main.async {
                self.delegate.switchToController(.UploadExist, url: response?.secureUrl)
                self.hideUploadingView()
            }
        })
    }
}

extension UploadDoesNotExistController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            uploadImage(image)
       }
        if let url = info[.mediaURL] as? NSURL {
            uploadVideo(url)
        }
    }
}
extension UploadDoesNotExistController: CLDUploaderWidgetDelegate {
    func uploadWidget(_ widget: CLDUploaderWidget, willCall uploadRequests: [CLDUploadRequest]) {
        DispatchQueue.main.async {
            self.showUploadingView()
        }
      uploadRequests[0].response( { response, error in
          self.delegate.switchToController(.UploadExist, url: response?.secureUrl)
          self.hideUploadingView()
      } )
    }
    func widgetDidCancel(_ widget: CLDUploaderWidget) {
    }
    func uploadWidgetDidDismiss() {
    }
}
