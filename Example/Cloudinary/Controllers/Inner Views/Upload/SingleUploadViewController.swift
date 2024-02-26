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

    weak var delegate: UploadChoiceControllerDelegate!

    var url: String?

    var cloudinary = CloudinaryHelper.shared.cloudinary

    var uploadLoadingView: UploadLoadingView?

    var type: UploadViewType = .Upload

    private var imagePicker: UIImagePickerController!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setOpenGalleryView()
        setMainView()
        if type == .UploadLarge {
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload Large"))
        } else {
            EventsHandler.shared.logEvent(event: EventObject(name: "Upload"))
        }
    }

    private func setMainView() {
        guard let url = url else {
            return
        }
        if type == .Upload {
            ivMain.isHidden = false
            ivMain.cldSetImage(url , cloudinary: self.cloudinary)
        }
        if type == .UploadLarge {
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
        cloudinary.createUploader().upload(data: data!, uploadPreset: "ml_default", completionHandler:  { response, error in
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

