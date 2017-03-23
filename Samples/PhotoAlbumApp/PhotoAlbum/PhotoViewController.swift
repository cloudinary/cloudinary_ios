//
//  PhotoViewController.swift
//  PhotoAlbum
//

import UIKit
import os.log
import Cloudinary

class PhotoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var middleImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!

    var publicId: String?
    var cld = CLDCloudinary(configuration: CLDConfiguration(cloudName: AppDelegate.cloudName, secure: true))
    var placeholder: UIImage?
    /*
         This value is either passed by `PhotoTableViewController` in `prepare(for:sender:)`
         or constructed as part of adding a new image.
     */
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Photo.
        if let photo = photo {
            let size: CGSize = self.photoImageView.frame.size
            let transformation = CLDTransformation().setWidth(Int(size.width)).setHeight(Int(size.height)).setCrop(.fit)
            let leftSize = self.leftImage.frame.size
            let leftTransformation = CLDTransformation().setWidth(Int(leftSize.width)).setHeight(Int(leftSize.height))
                    .setCrop(.fit)
                    .setRadius("max")
                    .setEffect(.grayscale)
            let middleSize = self.middleImage.frame.size
            let middleTransformation = CLDTransformation().setWidth(Int(middleSize.width)).setHeight(Int(middleSize.height))
                    .setCrop(.fit)
                    .setOverlayWithLayer(CLDTextLayer().setFontFamily(fontFamily: "Arial").setFontSize(80).setText(text: "Cloudinary"))
                    .setColor("white")
                    .chain()
                    .setAngle(20)
            let rightSize = self.rightImage.frame.size
            let rightTransformation = CLDTransformation().setWidth(Int(rightSize.width)).setHeight(Int(rightSize.height))
                    .setCrop(.fit)
                    .setBorder(10, color: "blue")
            navigationItem.title = photo.name
            nameTextField.text = photo.name
            if let publicId = photo.publicId {
                photoImageView.cldSetImage(publicId: publicId, cloudinary: cld, transformation: transformation, placeholder: placeholder)
                leftImage.cldSetImage(publicId: publicId, cloudinary: cld, transformation: leftTransformation, placeholder: placeholder)
                middleImage.cldSetImage(publicId: publicId, cloudinary: cld, transformation: middleTransformation, placeholder: placeholder)
                rightImage.cldSetImage(publicId: publicId, cloudinary: cld, transformation: rightTransformation, placeholder: placeholder)
                // pre-fetch transformations
                let downloader = cld.createDownloader()
                let url = cld.createUrl()
                downloader.fetchImage(url.setTransformation(leftTransformation.setHeight(Float(size.height)).setWidth(Float(size.width))).generate(publicId)!)
                downloader.fetchImage(url.setTransformation(middleTransformation.setHeight(Float(size.height)).setWidth(Float(size.width))).generate(publicId)!)
                downloader.fetchImage(url.setTransformation(rightTransformation.setHeight(Float(size.height)).setWidth(Float(size.width))).generate(publicId)!)
            } else {
                photoImageView.image = photo.image
            }

        }
        
        // Enable the Save button only if the text field has a valid Photo name.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        leftImage.image = nil
        middleImage.image = nil
        rightImage.image = nil
        photo?.publicId = nil
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {

        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddPhotoMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPhotoMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The PhotoViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)


        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let image = photoImageView.image
        let publicId = photo?.publicId
        // Set the image to be passed to PhotoTableViewController after the unwind segue.
        photo = Photo(name: name, image: image, publicId: publicId)

    }
    
    //MARK: Actions

    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their image library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    fileprivate func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

