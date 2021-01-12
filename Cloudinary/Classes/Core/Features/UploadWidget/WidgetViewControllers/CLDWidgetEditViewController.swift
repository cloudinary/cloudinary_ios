//
//  CLDWidgetEditViewController.swift
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

internal protocol CLDWidgetEditDelegate: class {
    func widgetEditViewController(_ controller: CLDWidgetEditViewController, didFinishEditing image: CLDWidgetAssetContainer)
    func widgetEditViewControllerDidReset (_ controller: CLDWidgetEditViewController)
    func widgetEditViewControllerDidCancel(_ controller: CLDWidgetEditViewController)
}

internal class CLDWidgetEditViewController: UIViewController {
    
    private(set) var buttonsView : UIView!
    private(set) var cancelButton: UIButton!
    private(set) var rotateButton: UIButton!
    private(set) var doneButton  : UIButton!
    private(set) var cropView    : CLDCropView!
    
    private(set)  var image                 : CLDWidgetAssetContainer
    private(set)  var configuration         : CLDWidgetConfiguration?
    private(set)  var initialAspectLockState: CLDWidgetConfiguration.AspectRatioLockState
    internal weak var delegate              : CLDWidgetEditDelegate?
    
    private var firstTime               : Bool = true
    private let bottomCropViewPadding   : CGFloat = 10
    private let bottomButtonsViewPadding: CGFloat = 10
    
    // MARK: - init
    init(
        image: CLDWidgetAssetContainer,
        configuration: CLDWidgetConfiguration? = nil,
        delegate: CLDWidgetEditDelegate? = nil,
        initialAspectLockState: CLDWidgetConfiguration.AspectRatioLockState = .enabledAndOff
    ) {
        self.image                  = image
        self.configuration          = configuration
        self.delegate               = delegate
        self.initialAspectLockState = initialAspectLockState
        
        super.init(nibName: nil, bundle: nil)
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        super.loadView()
        createUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        adjustCropViewLocation(cropView)
        
        if firstTime {
            firstTime = false
            cropView.performInitialSetup()
        }
    }
}

// MARK: - crop view
extension CLDWidgetEditViewController {
    
    private func frameForCropView() -> CGRect {
        
        let bounds = view.bounds
        var frame  = CGRect.zero
        
        frame.size.height = bounds.height - buttonsView.frame.height - bottomButtonsViewPadding - bottomCropViewPadding
        frame.size.width  = bounds.width
        
        return frame
    }
    
    func aspectRatioLockPressed() {
        
        cropView.aspectRatioLockEnabled.toggle()
        if cropView.aspectRatioLockEnabled {
            cropView.lockAspectRatio(to: cropView.cropBoxFrame.size)
        }
    }
}

// MARK: - actions
private extension CLDWidgetEditViewController {
    
    @objc func resetPressed(sender: UIButton) {
        
        image.editedImage = image.originalImage
        
        // crete a new crop view with original image
        let oldView = cropView
        let newView = createCropView(for: image.originalImage!, aspectLockState: initialAspectLockState == .enabledAndOn)
        
        view.insertSubview(newView, belowSubview: cropView)
        
        adjustCropViewLocation(newView)
        newView.performInitialSetup()
        newView.alpha = 0.0
        
        cropView = newView
        
        UIView.animateKeyframes(withDuration: 1, delay: 0.0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                oldView?.alpha = 0.0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                newView.alpha  = 1.0
            }
            
        }) { (success) in
            oldView?.isHidden = true
            oldView?.removeFromSuperview()
        }
        
        cropView.aspectRatioLockEnabled = false
        
        delegate?.widgetEditViewControllerDidReset(self)
    }
    
    @objc func rotatePressed(sender: UIButton) {
        cropView.rotateImageNinetyDegreesAnimated(true)
    }
    
    @objc func donePressed(sender: UIButton) {
        
        let cropFrame  = cropView.imageCropFrame
        let angle      = cropView.angle
        let editedImage: CLDWidgetAssetContainer = image
        
        // check if image edited
        if angle != 0 || !cropFrame.equalTo(CGRect(origin: CGPoint.zero, size: image.editedImage!.size)) {
            let newImage = image.editedImage?.cld_cropImage(to: cropFrame, angle: angle)
            editedImage.editedImage = newImage
            
            if let presentationImage = newImage {
                editedImage.presentationImage = presentationImage
            }
        }
        
        delegate?.widgetEditViewController(self, didFinishEditing: editedImage)
    }
}

extension UIImage {
    
    func cld_hasAlpha() -> Bool {
        
        guard let cgimage = self.cgImage else { return false }
        let alphaInfo = cgimage.alphaInfo
        return (alphaInfo == .first || alphaInfo == .last ||
            alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast)
    }
    
    func cld_cropImage(to frame: CGRect, angle: NSInteger) -> UIImage {
       
        var croppedImage: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(frame.size, !cld_hasAlpha(), scale)
        
            let context = UIGraphicsGetCurrentContext()
            
            //To conserve memory in not needing to completely re-render the image re-rotated,
            //map the image to a view and then use Core Animation to manipulate its rotation
            if (angle != 0) {
                let imageView = UIImageView(image: self)
                imageView.layer.minificationFilter  = .nearest
                imageView.layer.magnificationFilter = .nearest
                imageView.transform = CGAffineTransform.identity.rotated(by: CGFloat(angle) * (CGFloat(Double.pi)/180.0))
                
                let rotatedRect = imageView.bounds.applying(imageView.transform)
                let containerView = UIView(frame: CGRect(origin: .zero, size: rotatedRect.size))
                containerView.addSubview(imageView)
                imageView.center = containerView.center
                context?.translateBy(x: -frame.origin.x, y: -frame.origin.y)
                
                containerView.layer.render(in: context!)
            }
            else {
                context?.translateBy(x: -frame.origin.x, y: -frame.origin.y)
                draw(at: .zero)
            }
            
            croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        if let croppedCGImage = croppedImage?.cgImage {
            return UIImage(cgImage:croppedCGImage , scale: scale, orientation: .up)
        }
        else {
            return self
        }
    }
}

// MARK: - create UI
private extension CLDWidgetEditViewController {
 
    var buttonsViewHeight: CGFloat { return 70 }
    
    // MARK: - methods
    func createUI() {
        
        view.backgroundColor = .black
        
        createAllSubviews()
        addAllSubviews()
        addAllConstraints()
        configureScreen()
    }
    
    func createCropView(for image: UIImage, aspectLockState: Bool) -> CLDCropView {
        let aView                    = CLDCropView(image: image)
        aView.autoresizingMask       = [.flexibleWidth, .flexibleHeight]
        aView.aspectRatioLockEnabled = aspectLockState
        return aView
    }
    
    func createAllSubviews() {
        
        buttonsView = UIView()
        
        cropView = createCropView(for: image.editedImage!, aspectLockState: initialAspectLockState == .enabledAndOn)
        
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Reset", for: .normal)
        cancelButton.addTarget(self, action: #selector(resetPressed), for: .touchUpInside)
        
        let buttonImage = CLDImageGenerator.generateImage(from: RotateIconInstructions())
        rotateButton = UIButton(type: .custom)
        rotateButton.accessibilityIdentifier = "editViewControllerRotateButton"
        rotateButton.setImage(buttonImage, for: .normal)
        rotateButton.addTarget(self, action: #selector(rotatePressed), for: .touchUpInside)
        
        doneButton   = UIButton(type: .custom)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
    }
        
    func adjustCropViewLocation(_ aView: CLDCropView) {
        
        aView.frame = frameForCropView()
        aView.cropRegionInsets = UIEdgeInsets.zero
        aView.moveCroppedContentToCenterAnimated(false)
    }
    
    func addAllSubviews() {
        
        view.addSubview(cropView)
        view.addSubview(buttonsView)
        buttonsView.addSubview(cancelButton)
        buttonsView.addSubview(rotateButton)
        buttonsView.addSubview(doneButton)
    }
    
    func addAllConstraints() {
        
        buttonsView .translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        rotateButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton  .translatesAutoresizingMaskIntoConstraints = false
        
        let buttonsViewConstraints = [
            NSLayoutConstraint(item: buttonsView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: buttonsView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: buttonsView!, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -bottomButtonsViewPadding),
            NSLayoutConstraint(item: buttonsView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: buttonsViewHeight)
        ]
        NSLayoutConstraint.activate(buttonsViewConstraints)
        
        let cancelButtonConstraints = [
            NSLayoutConstraint(item: cancelButton!, attribute: .leading, relatedBy: .equal, toItem: buttonsView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cancelButton!, attribute: .trailing, relatedBy: .equal, toItem: rotateButton, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cancelButton!, attribute: .top, relatedBy: .equal, toItem: buttonsView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: cancelButton!, attribute: .bottom, relatedBy: .equal, toItem: buttonsView, attribute: .bottom, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(cancelButtonConstraints)
        
        let rotateButtonConstraints = [
            NSLayoutConstraint(item: rotateButton!, attribute: .trailing, relatedBy: .equal, toItem: doneButton, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rotateButton!, attribute: .top, relatedBy: .equal, toItem: buttonsView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rotateButton!, attribute: .height, relatedBy: .equal, toItem: cancelButton, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rotateButton!, attribute: .width, relatedBy: .equal, toItem: cancelButton, attribute: .width, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(rotateButtonConstraints)
        
        let doneButtonConstraints = [
            NSLayoutConstraint(item: doneButton!, attribute: .trailing, relatedBy: .equal, toItem: buttonsView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: doneButton!, attribute: .top, relatedBy: .equal, toItem: buttonsView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: doneButton!, attribute: .height, relatedBy: .equal, toItem: cancelButton, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: doneButton!, attribute: .width, relatedBy: .equal, toItem: cancelButton, attribute: .width, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(doneButtonConstraints)
    }
    
    func configureScreen() {
        
        guard let configuration = configuration else { return }

        if !configuration.allowRotate {
            rotateButton.isEnabled = false
            rotateButton.isHidden = true
        }
    }
}
