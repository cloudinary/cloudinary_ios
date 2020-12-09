//
//  CLDUploaderWidget.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

@objc public protocol CLDUploaderWidgetDelegate: class {
    
    /**
    Informs the delegate that the upload process will begin for the added requests.
    
    - parameter widget:         The widget object.
    - parameter uploadRequests: The `CLDUploadRequest`s to be uploaded.
    
    */
    func uploadWidget(_ widget: CLDUploaderWidget, willCall uploadRequests: [CLDUploadRequest])
    
    /**
    Informs the delegate that the widget is canceled.
    
    - parameter widget:         The widget object.
    
    */
    func widgetDidCancel(_ widget: CLDUploaderWidget)
    
    /**
    Informs the delegate that the widget view is dismissed.
    
    - parameter widget:         The widget object.
    
    */
    func uploadWidgetDidDismiss()
}

@objcMembers public class CLDUploaderWidget: NSObject {
    
    public private(set) weak var rootViewController    : UIViewController!
    public private(set)      var cloudinaryObject      : CLDCloudinary
    public private(set)      var configuration         : CLDWidgetConfiguration?
    public private(set)      var images                : [UIImage]
    private                  var selectImageFromLibrary: Bool
    private                  var widgetViewController  : CLDWidgetViewController!
    private                  var widgetPresented       : Bool
    private                  var imagePicker           : UIImagePickerController!
    
    public              weak var delegate              : CLDUploaderWidgetDelegate?
    
    // MARK - public methods
    /**
    Initializes the `CLDUploaderWidget` instance with the specified cloudinaryObject, configuration, images and delegate.
     
    - parameter cloudinary:             The CLDCloudinary object to be used for uploading the selected images.
    - parameter configuration:          The configuration used by this CLDUploaderWidget instance.
    - parameter images:                 The images to be presented, edited and uploaded.
    - parameter delegate:               The delegate object conforming to `CLDUploaderWidgetDelegate`.
    
    - returns: The new `CLDUploaderWidget` instance.
    */
    public init(
        cloudinary: CLDCloudinary,
        configuration: CLDWidgetConfiguration?,
        images: [UIImage]?,
        delegate: CLDUploaderWidgetDelegate?
    ) {
        
        self.cloudinaryObject       = cloudinary
        self.configuration          = configuration
        self.images                 = images != nil ? images! : [UIImage]()
        self.selectImageFromLibrary = self.images.count == 0
        self.delegate               = delegate
        self.widgetPresented        = false
        
        super.init()
    }
    
    /**
    Sets the CLDCloudinary object to be used for uploading the selected images
    
    - parameter cloudinary:        The cloudinary object.
    
    - returns:                     The same instance of CLDUploaderWidget.
    */
    @objc(setCloudinaryFromCloudinary:)
    @discardableResult
    public func setCloudinary(_ cloudinary: CLDCloudinary) -> Self {
        
        guard widgetPresented == false else {
            print("cloudinary can not be set while widget is presented")
            return self
        }
        
        self.cloudinaryObject = cloudinary
        return self
    }
    
    /**
    Holds the configuration parameters to be used by the `CLDUpladerWidget` instance.
    
    - parameter configuration:     The configuration object.
    
    - returns:                     The same instance of CLDUploaderWidget.
    */
    @objc(setConfigurationFromConfiguration:)
    @discardableResult
    public func setConfiguration(_ configuration: CLDWidgetConfiguration) -> Self {
        
        guard widgetPresented == false else {
            print("configuration can not be set while widget is presented")
            return self
        }
        
        self.configuration = configuration
        return self
    }
    
    /**
    Sets images to be presented, edited and uploaded.
    
    - parameter images:            The images array object.
    
    - returns:                     The same instance of CLDUploaderWidget.
    */
    @objc(setImagesFromImages:)
    @discardableResult
    public func setImages(_ images: [UIImage]) -> Self {
        
        guard widgetPresented == false else {
            print("images can not be set while widget is presented")
            return self
        }
        
        self.images = images
        return self
    }
    
    /**
    Sets a delegate object conforming to `CLDUploaderWidgetDelegate` protocol to recieve information via delegate methods.
    
    - parameter delegate:          The delegate object.
    
    - returns:                     The same instance of CLDUploaderWidget.
    */
    @objc(setDelegateFromDelegate:)
    @discardableResult
    public func setDelegate(_ delegate: CLDUploaderWidgetDelegate) -> Self {
        
        self.delegate = delegate
        return self
    }
    
    /**
    Modally presenting the widget or an `UIImagePickerController` from the given view controller.
    
    - parameter viewController:    The presenting `UIViewController` object.
    */
    public func presentWidget(from viewController: UIViewController) {
        
        let viewControllerToPresent: UIViewController
        
        if selectImageFromLibrary {
            imagePicker = createImagePicker()
            viewControllerToPresent = imagePicker
        }
        else {
            widgetViewController    = createWidgetViewController()
            viewControllerToPresent = widgetViewController
        }
        
        if #available(iOS 9.0, *) {
            viewControllerToPresent.loadViewIfNeeded()
        }
        else {
            _ = viewController.view
        }
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        
        if #available(iOS 13.0, *) {
            viewControllerToPresent.isModalInPresentation = true
        }
        
        rootViewController = viewController
        rootViewController.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    /**
    Dismisses the widget.
    */
    public func dismissWidget() {
        
        if selectImageFromLibrary {
            imagePicker.dismiss(animated: true) {
                self.delegate?.uploadWidgetDidDismiss()
            }
        }
        else {
            widgetViewController.dismiss(animated: true) {
                self.delegate?.uploadWidgetDidDismiss()
            }
        }
    }
    
    // MARK - private methods
    private func createWidgetViewController() -> CLDWidgetViewController {
        
        let imageContainers = images.compactMap {
            CLDWidgetImageContainer(originalImage: $0, editedImage: $0)
        }
        return CLDWidgetViewController(images: imageContainers, configuration: configuration, delegate: self)
    }
    
    private func createImagePicker() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        return picker
    }
    
    private func upload(_ images: [CLDWidgetImageContainer]) -> [CLDUploadRequest] {
        
        let datas = images.compactMap {
            $0.editedImage.pngData()
        }
        
        let uploader = cloudinaryObject.createUploader()
        
        let requests = datas.compactMap { (data) -> CLDUploadRequest? in
           
            // unsigned upload must have a preset
            if let configuration = configuration,
                configuration.uploadType.signed == false,
                let preset = configuration.uploadType.preset {
                
                return uploader.upload(data: data, uploadPreset: preset).response {
                    (result, error) in
                    print("result \(String(describing: result))")
                    print("error \(String(describing: error))")
                }
            }
            else {
                // default upload type
                return uploader.signedUpload(data: data).response { (result, error) in
                    print("result \(String(describing: result))")
                    print("error \(String(describing: error))")
                }
            }
        }
        return requests
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CLDUploaderWidget: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            images = [image]
            widgetViewController = createWidgetViewController()
            picker.pushViewController(widgetViewController, animated: true)
        }
        else {
            dismissWidget()
            return
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.widgetDidCancel(self)
        dismissWidget()
    }
}

// MARK: - CLDWidgetViewControllerDelegate
extension CLDUploaderWidget: CLDWidgetViewControllerDelegate {
    func widgetViewController(_ controller: CLDWidgetViewController, didFinishEditing editedImages: [CLDWidgetImageContainer]) {
        
        let uploadRequests = upload(editedImages)
        
        delegate?.uploadWidget(self, willCall: uploadRequests)
        dismissWidget()
    }
    
    func widgetViewControllerDidCancel(_ controller: CLDWidgetViewController) {
        delegate?.widgetDidCancel(self)
        dismissWidget()
    }
}
