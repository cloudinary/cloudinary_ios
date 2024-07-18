//
//  SingleUploadViewController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 11/01/2024.
//

import Foundation
import UIKit
import Photos
import Cloudinary
import AVKit

class SingleUploadViewController: UIViewController {

    @IBOutlet weak var vwImage: UIView!
    @IBOutlet weak var ivMain: UIImageView!
    @IBOutlet weak var vwOpenGallery: UIView!
    @IBOutlet weak var lbButton: UILabel!

    weak var delegate: UploadChoiceControllerDelegate!

    var uploadWidget: CLDUploaderWidget!

    var url: String?

    var cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: CloudinaryHelper.shared.getUploadCloud()!))

    var uploadLoadingView: UploadLoadingView?

    var type: UploadViewType = .Upload

    private var imagePicker: UIImagePickerController!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setOpenGalleryView()
        setMainView()
        switch type {
        case .Upload:
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload"))
        case .UploadLarge:
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload Large"))
        case .UploadWidget:
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload Widget"))
        }
    }

    private func setMainView() {
        guard let url = url else {
            return
        }
        if type == .Upload || type == .UploadWidget {
            ivMain.isHidden = false
            ivMain.cldSetImage(url , cloudinary: self.cloudinary)
        }
        if type == .UploadLarge {
            lbButton.text = "Upload Video"
            ivMain.isHidden = true
            let player = CLDVideoPlayer(url: url)
                let playerController = AVPlayerViewController()

                playerController.player = player
                addChild(playerController)
                playerController.videoGravity = .resizeAspectFill
                vwImage.addSubview(playerController.view)
                playerController.view.frame = vwImage.bounds
                playerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                playerController.didMove(toParent: self)
                player.play()
        }
    }

    private func setOpenGalleryView() {
        vwOpenGallery.layer.cornerRadius = vwOpenGallery.frame.height / 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGalleryClicked))
        vwOpenGallery.addGestureRecognizer(tapGesture)
    }

    @objc private func openGalleryClicked() {
        if type == .UploadWidget {

        } else {
            if imagePicker == nil {
                imagePicker = UIImagePickerController()
            }
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                imagePicker.delegate = self
                if type == .UploadLarge {
                    imagePicker.mediaTypes = ["public.movie"]
                }
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }

    private func addUploadingView() {
        let loadingViewSize = CGSize(width: 180, height: 70)
        let loadingViewOrigin = CGPoint(x: (vwImage.frame.width - loadingViewSize.width) / 2, y: (vwImage.frame.height - loadingViewSize.height) / 2)

        uploadLoadingView = UploadLoadingView(frame: CGRect(origin: loadingViewOrigin, size: loadingViewSize))
        uploadLoadingView!.startAnimation()
        vwImage.addSubview(uploadLoadingView!)
    }

    private func removeUploadingView() {
        if let uploadLoadingView = uploadLoadingView {
            AnimationHelper.animateOut(view: uploadLoadingView)
        }
    }

    func uploadImage(_ image: UIImage) {
        addUploadingView()
        let data = image.pngData()
        cloudinary.createUploader().upload(data: data!, uploadPreset: "ios_sample", completionHandler:  { response, error in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.ivMain.cldSetImage( response!.secureUrl!, cloudinary: self.cloudinary)
                }
                self.removeUploadingView()
            }
        })
    }
}

extension SingleUploadViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            ivMain.image = nil
            uploadImage(image)
        }
    }
}
extension SingleUploadViewController: CLDUploaderWidgetDelegate {
    func uploadWidget(_ widget: CLDUploaderWidget, willCall uploadRequests: [CLDUploadRequest]) {
        addUploadingView()
      uploadRequests[0].response( { response, error in
          self.ivMain.cldSetImage(response!.secureUrl!, cloudinary: self.cloudinary)
          self.removeUploadingView()
      } )
    }
    func widgetDidCancel(_ widget: CLDUploaderWidget) {
    }
    func uploadWidgetDidDismiss() {
    }
}
