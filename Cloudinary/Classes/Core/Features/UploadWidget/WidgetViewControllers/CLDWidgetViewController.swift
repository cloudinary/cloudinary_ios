//
//  CLDWidgetViewController.swift
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

internal protocol CLDWidgetViewControllerDelegate: class {
    func widgetViewController(_ controller: CLDWidgetViewController, didFinishEditing editedImages: [CLDWidgetImageContainer])
    func widgetViewControllerDidCancel(_ controller: CLDWidgetViewController)
}

internal class CLDWidgetViewController: UIViewController {
    
    private(set)  var configuration        : CLDWidgetConfiguration?
    private(set)  var images               : [CLDWidgetImageContainer]
    internal weak var delegate             : CLDWidgetViewControllerDelegate?
    
    private(set) var topButtonsView        : UIView!
    private(set) var backButton            : UIButton!
    private(set) var actionButton          : UIButton!
    private(set) var containerView         : UIView!
    
    private(set) var previewViewController : CLDWidgetPreviewViewController!
    private(set) var editViewController    : CLDWidgetEditViewController!
    private(set) var editIsPresented       : Bool
    
    private      var currentAspectLockState: CLDWidgetConfiguration.AspectRatioLockState

    private let previewActionButtonTitle      = "edit "
    private let editActionButtonLockedTitle   = "Aspect ratio locked "
    private let editActionButtonUnlockedTitle = "Aspect ratio unlocked "
    private let transitionDuration            = 0.5
    
    // MARK: - init
    internal init(
        images       : [CLDWidgetImageContainer],
        configuration: CLDWidgetConfiguration? = nil,
        delegate     : CLDWidgetViewControllerDelegate? = nil
    ) {
        
        self.configuration = configuration
        self.images        = images
        self.delegate      = delegate
        self.editIsPresented        = false
        self.currentAspectLockState = .enabledAndOff
        
        super.init(nibName: nil, bundle: nil)
        
        if let initialAspectLockState = configuration?.initialAspectLockState {
            currentAspectLockState = initialAspectLockState
        }
        
        previewViewController = CLDWidgetPreviewViewController(images: images, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        createUI()
    }
}

// MARK: - private methods
private extension CLDWidgetViewController {

    func moveToPreviewScreen() {
        
        editIsPresented = false
        
        transition(from: editViewController, to: previewViewController, inView: containerView)
        
        updateActionButton(by: .goToEditScreen)
    }
    
    func moveToEditScreen(with image: CLDWidgetImageContainer) {
        
        editIsPresented = true
        
        editViewController = nil
        editViewController = CLDWidgetEditViewController(image: image, configuration: configuration, delegate: self, initialAspectLockState: currentAspectLockState)
        
        transition(from: previewViewController, to: editViewController, inView: containerView)
        
        updateActionButton(by: currentAspectLockState)
    }
}

// MARK: - CLDWidgetPreviewDelegate
extension CLDWidgetViewController: CLDWidgetPreviewDelegate {
    
    func widgetPreviewViewController(_ controller: CLDWidgetPreviewViewController, didFinishEditing images: [CLDWidgetImageContainer]) {
        delegate?.widgetViewController(self, didFinishEditing: images)
    }
    
    func widgetPreviewViewControllerDidCancel(_ controller: CLDWidgetPreviewViewController) {
        delegate?.widgetViewControllerDidCancel(self)
    }
}

// MARK: - CLDWidgetEditDelegate
extension CLDWidgetViewController: CLDWidgetEditDelegate {
    
    func widgetEditViewController(_ controller: CLDWidgetEditViewController, didFinishEditing image: CLDWidgetImageContainer) {
        
        previewViewController.selectedImageEdited(newImage: image)
        moveToPreviewScreen()
    }
    
    func widgetEditViewControllerDidReset(_ controller: CLDWidgetEditViewController) {
        if currentAspectLockState != .disabled {
            updateActionButton(by: .enabledAndOff)
        }
    }
    
    func widgetEditViewControllerDidCancel(_ controller: CLDWidgetEditViewController) {
        moveToPreviewScreen()
    }
}

// MARK: - child presentation
private extension CLDWidgetViewController {
    
    func transition(from oldViewController: UIViewController, to newViewController: UIViewController, inView containerView: UIView) {
        
        // invoke viewWillAppear()...
        newViewController.beginAppearanceTransition(true, animated: true)
        oldViewController.beginAppearanceTransition(false, animated: true)
        
        // check if its already self child
        if newViewController.parent != self {
            
            addChild(newViewController)
            newViewController.didMove(toParent: self)
        }
        
        // adding newVC.view to fill containerView
        newViewController.view.removeFromSuperview()
        containerView.addSubview(newViewController.view)
        newViewController.view.cld_addConstraintsToFill(containerView)
        
        // prepare for animation
        newViewController.view.alpha = 0
        containerView.bringSubviewToFront(newViewController.view)
        newViewController.view.layoutIfNeeded()
        
        // animate
        UIView.animate(withDuration: transitionDuration, delay: 0, options: [], animations: {
            
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            
        }) { (complete) in
            
            newViewController.endAppearanceTransition()
            oldViewController.endAppearanceTransition()
            oldViewController.view.removeFromSuperview()
        }
    }
    
    func presentAsChild(_ viewController: UIViewController, inView containerView: UIView) {
        
        viewController.beginAppearanceTransition(true, animated: true)
        
        if viewController.parent != self {
            
            addChild(viewController)
            viewController.didMove(toParent: self)
        }
        
        viewController.view.removeFromSuperview()
        
        containerView.addSubview(viewController.view)
        viewController.view.cld_addConstraintsToFill(containerView)
        
        containerView.bringSubviewToFront(viewController.view)
        viewController.view.layoutIfNeeded()
        
        viewController.endAppearanceTransition()
    }
}

// MARK: - top buttons
private extension CLDWidgetViewController {
    
    enum ActionButtonState: Int {
        case aspectRatioEnabledAndOff
        case aspectRatioEnabledAndOn
        case aspectRatioDisabled
        case goToEditScreen
    }
    
    @objc func actionPressed(_ sender: UIButton) {
        if editIsPresented {
            toggleAspectRatioLockStates()
            editViewController.aspectRatioLockPressed()
        }
        else {
            moveToEditScreen(with: previewViewController.selectedImage())
        }
    }
    
    @objc func backPressed(_ sender: UIButton) {
        if editIsPresented {
            moveToPreviewScreen()
        }
        else {
            delegate?.widgetViewControllerDidCancel(self)
        }
    }
    
    func toggleAspectRatioLockStates() {
        currentAspectLockState = currentAspectLockState == .enabledAndOff ? .enabledAndOn : .enabledAndOff
        updateActionButton(by: currentAspectLockState)
    }
    
    func updateActionButton(by aspectLockState: CLDWidgetConfiguration.AspectRatioLockState) {
       
        switch aspectLockState {
        case .enabledAndOff: updateActionButton(by: .aspectRatioEnabledAndOff)
        case .enabledAndOn : updateActionButton(by: .aspectRatioEnabledAndOn)
        case .disabled     : updateActionButton(by: .aspectRatioDisabled)
        }
    }
    
    func updateActionButton(by actionButtonState: ActionButtonState) {
        
        UIView.transition(with: actionButton, duration: transitionDuration, options: .transitionCrossDissolve, animations: {
            switch actionButtonState {
            
            case .aspectRatioEnabledAndOff:
                self.actionButton.cld_setImagedTitle(self.editActionButtonUnlockedTitle, withSuffix: CLDImageGenerator.generateImage(from: RatioOpenedIconInstructions()))
                
            case .aspectRatioEnabledAndOn:
                self.actionButton.cld_setImagedTitle(self.editActionButtonLockedTitle, withSuffix: CLDImageGenerator.generateImage(from: RatioLockedIconInstructions()))
                
            case .aspectRatioDisabled:
                self.actionButton.isEnabled = false
                self.actionButton.setAttributedTitle(NSAttributedString(string: String()), for: .normal)
                
            case .goToEditScreen:
                self.actionButton.cld_setImagedTitle(self.previewActionButtonTitle, withSuffix: CLDImageGenerator.generateImage(from: CropRotateIconInstructions()))
                self.actionButton.isEnabled = true
            }
        }, completion: nil)
    }
}

// MARK: - create UI
private extension CLDWidgetViewController {
    
    var topButtonsViewHeight: CGFloat { return 44 }
    var backButtonWidthRatio: CGFloat { return 0.25 }
    
    func createUI() {
        
        view.backgroundColor = .black
        
        createAllSubviews()
        addAllSubviews()
        addAllConstraints()
        
        presentAsChild(previewViewController, inView: containerView)
    }
    
    func createAllSubviews() {
        
        // top buttons view
        topButtonsView = UIView(frame: CGRect.zero)
        
        // buttons
        backButton = UIButton(type: .custom)
        backButton.setImage(CLDImageGenerator.generateImage(from: BackIconInstructions()), for: .normal)
        backButton.contentHorizontalAlignment = .left
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        
        actionButton = UIButton(type: .custom)
        updateActionButton(by: .goToEditScreen)
        actionButton.contentHorizontalAlignment = .right
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        actionButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)
        
        // container view
        containerView = UIView(frame: CGRect.zero)
    }
    
    func addAllSubviews() {
        
        view.addSubview(topButtonsView)
        topButtonsView.addSubview(backButton)
        topButtonsView.addSubview(actionButton)
        view.addSubview(containerView)
    }
    
    func addAllConstraints() {
        
        topButtonsView.translatesAutoresizingMaskIntoConstraints = false
        backButton    .translatesAutoresizingMaskIntoConstraints = false
        actionButton  .translatesAutoresizingMaskIntoConstraints = false
        containerView .translatesAutoresizingMaskIntoConstraints = false
        
        // top buttons view
        let collectionConstraints = [
            NSLayoutConstraint(item: topButtonsView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topButtonsView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topButtonsView!, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topButtonsView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: topButtonsViewHeight)
        ]
        NSLayoutConstraint.activate(collectionConstraints)
        
        // buttons
        let backButtonConstraints = [
            NSLayoutConstraint(item: backButton!, attribute: .leading, relatedBy: .equal, toItem: topButtonsView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backButton!, attribute: .top, relatedBy: .equal, toItem: topButtonsView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backButton!, attribute: .bottom, relatedBy: .equal, toItem: topButtonsView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: backButton!, attribute: .width
                , relatedBy: .equal, toItem: topButtonsView, attribute: .width, multiplier: backButtonWidthRatio, constant: 0)
        ]
        NSLayoutConstraint.activate(backButtonConstraints)
        
        backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let actionButtonConstraints = [
            NSLayoutConstraint(item: actionButton!, attribute: .trailing, relatedBy: .equal, toItem: topButtonsView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: actionButton!, attribute: .top, relatedBy: .equal, toItem: topButtonsView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: actionButton!, attribute: .bottom, relatedBy: .equal, toItem: topButtonsView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: actionButton!, attribute: .leading, relatedBy: .lessThanOrEqual, toItem: backButton, attribute: .trailing, multiplier: 1, constant: view.frame.width * 0.25),
        ]
        NSLayoutConstraint.activate(actionButtonConstraints)
        
        // container view
        let containerViewConstraints = [
            NSLayoutConstraint(item: containerView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView!, attribute: .top, relatedBy: .equal, toItem: topButtonsView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView!, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(containerViewConstraints)
    }
}

// MARK: - extension UIView
private extension UIView {
    
    func cld_addConstraintsToFill(_ parentView: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - extension UIButton
private extension UIButton {
    
    func cld_setImagedTitle(_ title: String, color: UIColor = .white, withSuffix image: UIImage?) {
        
        if let image = image {
            // Create Attachment
            let imageAttachment   = NSTextAttachment()
            imageAttachment.image = image
            
            // Set bound to reposition
            let imageOffsetY: CGFloat = -5.0
            imageAttachment.bounds    = CGRect(x: 0, y: imageOffsetY, width: image.size.width, height: image.size.height)
            
            // Create string with attachment
            let attachmentString = NSAttributedString(attachment: imageAttachment)
            
            // Initialize mutable string
            let completeText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : color])
            
            // Add image to mutable string
            completeText.append(attachmentString)
            
            self.setAttributedTitle(completeText, for: .normal)
        }
        else {
            self.setAttributedTitle(NSAttributedString(string: title), for: .normal)
        }
    }
}
