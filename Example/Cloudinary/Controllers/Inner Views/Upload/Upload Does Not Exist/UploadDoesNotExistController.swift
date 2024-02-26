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
    @IBOutlet weak var vwUpload: UIView!

    private var imagePicker: UIImagePickerController!

    weak var delegate: UploadChoiceControllerDelegate!

    var type: UploadViewType = .Upload

    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: CloudinaryHelper.shared.getUploadCloud()!))

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUploadImageView()
        if type == .UploadLarge {
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload Large"))
        } else {
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload"))
        }
    }

    func setUploadImageView() {
        vwUpload.layer.cornerRadius = vwUpload.frame.height / 2

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadClicked))
        vwUpload.addGestureRecognizer(tapGesture)
    }

    @objc private func uploadClicked() {
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

    func uploadImage(_ image: UIImage) {
        let data = image.pngData()
        cloudinary.createUploader().upload(data: data!, uploadPreset: "ios_sample", completionHandler:  { response, error in
            DispatchQueue.main.async {
                self.delegate.switchToController(.UploadExist, url: response?.secureUrl)
            }
        })
    }

    func uploadVideo(_ url: NSURL) {
        let params = CLDUploadRequestParams()
        params.setResourceType("video")
        cloudinary.createUploader().upload(url: url as URL, uploadPreset: "ml_default", params: params) { response, error in
            DispatchQueue.main.async {
                self.delegate.switchToController(.UploadExist, url: response?.secureUrl)
            }
        }
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
