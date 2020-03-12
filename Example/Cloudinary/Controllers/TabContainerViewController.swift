//
//  TabContainerViewController.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 29/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary
import MobileCoreServices
import Photos

/*
 */
class TabContainerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var galleryButton: UIBarButtonItem!
    @IBOutlet weak var clearAllButton: UIBarButtonItem!
    
    // MARK: Actions
    override open func viewDidLoad() {
        // Let the user type in his cloud name if not set yet set:
        if UserDefaults.standard.string(forKey: "cloud_name") == nil {
            showCloudNameAlert()
        }
    }
    
    fileprivate func showCloudNameAlert() {
        let alert = UIAlertController(title: "Configuration", message: "Enter your cloud name.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = UserDefaults.standard.string(forKey: "last_cloud_name")
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            UserDefaults.standard.set(textField.text, forKey: "cloud_name")
            UserDefaults.standard.set(textField.text, forKey: "last_cloud_name")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            // init cloudinary now that there's a cloud name present
            appDelegate.initCloudinary()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showPicker(_ sender: Any) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            doShowPicker()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()
                if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                    self.doShowPicker()
                }
            })
        }
    }
    
    private func doShowPicker(){
        
        DispatchQueue.main.async { [weak self] in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            imagePickerController.delegate = self
            self?.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // Clear all local data (including cloud name)
    @IBAction func clearAll(_ sender: Any) {
        PersistenceHelper.clearAll()
        UserDefaults.standard.set(nil, forKey: "cloud_name")
        showCloudNameAlert()
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let imageUrl = info[UIImagePickerController.InfoKey.referenceURL] as! URL
        let contentType = info[UIImagePickerController.InfoKey.mediaType] as! String
        let resourceType = contentType.contains("movie") ? CLDUrlResourceType.video : CLDUrlResourceType.image
        Utils.saveImageUrl(imageUrl: imageUrl as URL, contentType: contentType) { url, name in
            if let url = url {
                // Save to local db
                PersistenceHelper.addResource(localUri: name!, type: resourceType.description)
                
                // upload to cloudinary
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                
                CloudinaryHelper.upload(cloudinary: appDelegate.cloudinary!, url: url, resourceType: resourceType)
                    .progress({ progress in
                        NotificationCenter.default.post(name: InProgressViewController.progressChangedNotification, object: nil, userInfo: ["name": name!, "progress": progress])
                    }).response({ response, error in
                        if (response != nil) {
                            PersistenceHelper.resourceUploaded(localPath: name!, publicId: (response?.publicId)!)
                            // cleanup - once a file is uploaded we don't use the local copy
                            try? FileManager.default.removeItem(at: url)
                        } else if (error != nil) {
                            PersistenceHelper.resourceError(localPath: name!, code: (error?.code) != nil ? (error?.code)! : -1, description: (error?.userInfo["message"] as? String))
                        }
                    })
            }
        }
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
}

