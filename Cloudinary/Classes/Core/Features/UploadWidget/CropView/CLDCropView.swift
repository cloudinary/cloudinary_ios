//
//  CLDCropView.swift
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

public extension CGFloat {
    
    static var ulpOfOne: CGFloat { CGFloat(Float.ulpOfOne) }
}

/**
 Preset values of the most common aspect ratios that can be used to quickly configure
 the crop view controller.
 */
@objc
public enum CLDCropViewControllerAspectRatioPreset : Int {
    case original
    case square
    case rect3x2
    case rect5x3
    case rect4x3
    case rect5x4
    case rect7x5
    case rect16x9
    case custom
}

/**
 When the user taps down to resize the box, this state is used
 to determine where they tapped and how to manipulate the box
 */
@objc
public enum CLDCropViewOverlayEdge : Int {
    case none
    case topLeft
    case top
    case topRight
    case right
    case bottomRight
    case bottom
    case bottomLeft
    case left
}

// =====================================================================================================================
@objc
public protocol CLDCropViewDelegate : NSObjectProtocol {
    @objc optional func cropView(_ cropView: CLDCropView, didChangeResettable state: Bool)
}

// =====================================================================================================================
@objc
@objcMembers
public class CLDCropView: UIView {
    
    // MARK: - Constants
    internal struct Constants {
        internal static let            padding : CGFloat      = CGFloat(14.0)     // kTOCropViewPadding
        internal static let      timerDuration : TimeInterval = TimeInterval(0.8) // kTOCropTimerDuration
        internal static let     minimumBoxSize : CGFloat      = CGFloat(42.0)     // kTOCropViewMinimumBoxSize
        internal static let circularPathRadius : CGFloat      = CGFloat(300.0)    // kTOCropViewCircularPathRadius
        internal static let   maximumZoomScale : CGFloat      = CGFloat(15.0)     // kTOMaximumZoomScale
    }
    
    // MARK: - Types
    internal class Calculator {
        internal class CropBox     {}
        internal class ImageCrop   {}
        internal class AspectRatio {}
    }
    
    // MARK: - Properties
    
    /**
     A delegate object that receives notifications from the crop view
     */
    public weak var delegate: CLDCropViewDelegate?
    
    /**
     If false, the user cannot resize the crop box frame using a pan gesture from a corner.
     Default value is true.
     */
    public var cropBoxResizeEnabled: Bool {
        get { _cropBoxResizeEnabled }
        set {
            _cropBoxResizeEnabled = newValue
            gridPanGestureRecognizer.isEnabled = newValue
        }
    }
    
    /**
     Inset the workable region of the crop view in case in order to make space for accessory views
     */
    public var cropRegionInsets: UIEdgeInsets
    
    /**
     When performing manual content layout (such as during screen rotation), disable any internal layout
     */
    public var internalLayoutDisabled: Bool
    
    /**
     A width x height ratio that the crop box will be rescaled to (eg 4:3 is {4.0f, 3.0f})
     Setting it to CGSizeZero will reset the aspect ratio to the image's own ratio.
     */
    public var aspectRatio: CGSize {
        get { _aspectRatio }
        set { setAspectRatio(newValue, animated: false) }
    }
    
    /**
     When the cropping box is locked to its current aspect ratio (But can still be resized)
     */
    public var aspectRatioLockEnabled: Bool
    
    /**
     If true, a custom aspect ratio is set, and the aspectRatioLockEnabled is set to YES,
     the crop box will swap it's dimensions depending on portrait or landscape sized images.
     This value also controls whether the dimensions can swap when the image is rotated.
     
     Default is true.
     */
    public var aspectRatioLockDimensionSwapEnabled: Bool
    
    /**
     When the user taps 'reset', whether the aspect ratio will also be reset as well
     
     Default is true.
     */
    public var resetAspectRatioEnabled: Bool
    
    /**
     The rotation angle of the crop view (Will always be negative as it rotates in a counter-clockwise direction)
     */
    public var angle: Int {
        get { _angle }
        set {
            // The initial layout would not have been performed yet.
            // Save the value and it will be applied when it has
            
            var newAngle = newValue
            
            if (newValue % 90 != 0) { newAngle = 0 }
            
            if !initialSetupPerformed {
                restoreAngle = newAngle
                return
            }
            
            // Negative values are allowed, so rotate clockwise or counter clockwise depending on direction
            if (newAngle >= 0) {
                while ( labs(angle) !=  labs(newAngle)) { rotateImageNinetyDegreesAnimated(false, clockwise: true ) }
            } else {
                while (-labs(angle) != -labs(newAngle)) { rotateImageNinetyDegreesAnimated(false, clockwise: false) }
            }
        }
    }
    
    /**
     In relation to the coordinate space of the image, the frame that the crop view is focusing on
     */
    public var imageCropFrame: CGRect {
        get {
            return Calculator.ImageCrop.computeFrame(given: imageSize, scrollView: scrollView, cropBox: cropBoxFrame)
        }
        set {
            
            guard initialSetupPerformed else { restoreImageCropFrame = newValue; return }
            
            let adjutsments = Calculator.ImageCrop.computeAdjutsments(for: self,
                                                                      scrollView: scrollView,
                                                                      content: contentBounds,
                                                                      newValue: newValue)
            
            cropBoxFrame = adjutsments.cropFrame
            
            applyCropFrameAdjutsments(to: scrollView, originPoint: newValue.origin, minimumScale: adjutsments.minimumZoomScale, adjustedZoom: adjutsments.adjustedZoomScale)
        }
    }
    
    /**
     Paddings of the crop rectangle.
     
     Default to 14.0
     */
    public var cropViewPadding: CGFloat
    
    /**
     Delay before crop frame is adjusted according new crop area.
     
     Default to 0.8
     */
    public var cropAdjustingDelay: TimeInterval
    
    /**
     The minimum croping aspect ratio. If set, user is prevented from setting cropping
     rectangle to lower aspect ratio than defined by the parameter.
     */
    public var minimumAspectRatio: CGFloat
    
    /**
     The maximum scale that user can apply to image by pinching to zoom. Small values
     are only recomended with aspectRatioLockEnabled set to true.
     
     Default to 15.0
     */
    public var maximumZoomScale: CGFloat
    
    /**
     Always show the cropping grid lines, even when the user isn't interacting.
     This also disables the fading animation.
     
     (Default is NO)
     */
    public var alwaysShowCroppingGrid: Bool {
        get { _alwaysShowCroppingGrid }
        set {
            if _alwaysShowCroppingGrid == newValue { return }
            _alwaysShowCroppingGrid = newValue
            gridOverlayView.setGridlines(hidden: !newValue, animted: true)
        }
    }
    
    /**
     Permanently hides the translucency effect covering the outside bounds of the
     crop box.
     
     Default is NO
     */
    public var translucencyAlwaysHidden: Bool {
        get { _translucencyAlwaysHidden }
        set {
            guard _translucencyAlwaysHidden != newValue else { return }
            _translucencyAlwaysHidden = newValue
            translucencyView.isHidden = newValue
        }
    }
    
    /**
     The image that the crop view is displaying. This cannot be changed once the crop view is instantiated.
     */
    public internal(set) var image : UIImage
    
    
    /* Views */
    /**
     The main image view, placed within the scroll view
     */
    internal var backgroundImageView: UIImageView!
    
    /**
     A view which contains the background image view, to separate its transforms from the scroll view.
     */
    internal var backgroundContainerView: UIView!
    
    /**
     A container view that clips the a copy of the image so it appears over the dimming view
     */
    public   private(set) var foregroundContainerView: UIView!
    
    /**
     A copy of the background image view, placed over the dimming views
     */
    internal var foregroundImageView: UIImageView!
    
    /**
     The scroll view in charge of panning/zooming the image.
     */
    internal private(set) var scrollView: CLDCropScrollView!
    
    /**
     The scroll view in charge of panning/zooming the image.
     */
    private var scrollViewDelegate: CLDCropScrollViewController!
    
    /**
     A semi-transparent grey view, overlaid on top of the background image
     */
    private var overlayView: UIView!
    
    /**
     A blur view that is made visible when the user isn't interacting with the crop view
     */
    internal var translucencyView: UIVisualEffectView!
    
    /**
     The dark blur visual effect applied to the visual effect view.
     */
    private var translucencyEffect: UIBlurEffect!
    
    /**
     A grid view overlaid on top of the foreground image view's container.
     */
    public  private(set) var gridOverlayView: CLDCropOverlayView!
    
    /* Gesture Recognizers */
    
    /**
     The gesture recognizer in charge of controlling the resizing of the crop view
     */
    private var gridPanGestureRecognizer: UIPanGestureRecognizer!
    
    /* Crop box handling */
    
    /**
     No by default, when setting initialCroppedImageFrame this will be set to YES, and set back to NO after first application - so it's only done once
     */
    private var applyInitialCroppedImageFrame: Bool
    
    /**
     The edge region that the user tapped on, to resize the cropping region
     */
    internal var tappedEdge: CLDCropViewOverlayEdge
    
    /**
     When resizing, this is the original frame of the crop box.
     */
    internal var cropOriginFrame : CGRect
    
    /**
     The initial touch point of the pan gesture recognizer
     */
    internal var  panOriginPoint : CGPoint
    
    /**
     The frame of the cropping box in the coordinate space of the crop view
     */
    public internal(set) var cropBoxFrame: CGRect {
        get { _cropBoxFrame }
        set {
            if _cropBoxFrame.equalTo(newValue) { return }
            
            guard newValue.isValidBoxSize else { return }
            
            // Clamp the cropping region to the inset boundaries of the screen
            _cropBoxFrame = Calculator.CropBox.clampFrame(given: contentBounds, cropBox: newValue,
                                                          minimumBoxSize: Constants.minimumBoxSize)
            
            applyDidSetCropBoxFrame(to: _cropBoxFrame)
        }
    }
    
    /**
     A manager for the crop view UI
     */
    fileprivate var cropUIManager: CLDCropViewUIManager!
    
    /**
     The timer used to reset the view after the user stops interacting with it
     */
    internal var resetTimer: Timer?
    
    /**
     Used to denote the active state of the user manipulating the content
     default is NO. setting is not animated.
     */
    private var isEditing: Bool {
        get { _isEditing }
        set {
            setEditing(newValue, resetCropBox: false, animated: false)
        }
    }
    
    internal func startEditing() {
        cancelResetTimer()
        setEditing(true, resetCropBox: false, animated: true)
    }
    
    internal func setEditing(_ editing: Bool, resetCropBox: Bool, animated: Bool) {
        
        if _isEditing == editing { return }
        _isEditing = editing
        
        // Toggle the visiblity of the gridlines when not editing
        var hidden = !editing
        if (alwaysShowCroppingGrid) { hidden = false } // Override this if the user requires
        gridOverlayView.setGridlines(hidden: hidden, animted: animated)
        
        if resetCropBox {
            moveCroppedContentToCenterAnimated(animated)
            captureStateForImageRotation()
            cropBoxLastEditedAngle = angle
        }
        
        switch animated {
        case false:
            toggleTranslucencyViewVisible(!editing)
            
        case true:
            let duration = editing ? 0.05 : 0.35
            let delay    = editing ? 0.00 : 0.35
            
            UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
                
                self.toggleTranslucencyViewVisible(!editing)
                
            }, completion: nil)
        }
    }
    
    /**
     At times during animation, disable matching the forground image view to the background
     */
    internal var disableForgroundMatching: Bool
    
    /* Pre-screen-rotation state information */
    private var rotationContentOffset: CGPoint
    private var rotationContentSize  : CGSize
    private var rotationBoundFrame   : CGRect
    
    /* View State information */
    /**
     Give the current screen real-estate, the frame that the scroll view is allowed to use
     */
    internal var contentBounds: CGRect {
        
        return Calculator.bounds(for: self.bounds, padding: cropViewPadding, cropRegion: cropRegionInsets)
    }
    
    /**
     Given the current rotation of the image, the size of the image
     */
    internal var imageSize: CGSize {
        
        if (angle ==  -90 || angle == -270 || angle ==   90 || angle ==  270 )
        {
            return CGSize(width: image.size.height, height: image.size.width )
        }
        else
        {
            return CGSize(width: image.size.width , height: image.size.height)
        }
    }
    
    /**
     True if an aspect ratio was explicitly applied to this crop view
     */
    internal var hasAspectRatio: Bool {
        
        return aspectRatio.width > CGFloat.ulpOfOne && aspectRatio.height > CGFloat.ulpOfOne
    }
    
    /* 90-degree rotation state data */
    /**
     When performing 90-degree rotations, remember what our last manual size was to use that as a base
     */
    internal var cropBoxLastEditedSize: CGSize
    
    /**
     Remember which angle we were at when we saved the editing size
     */
    internal var cropBoxLastEditedAngle: Int
    
    /**
     Remember the zoom size when we last edited
     */
    internal var cropBoxLastEditedZoomScale: CGFloat
    
    /**
     Remember the minimum size when we last edited.
     */
    internal var cropBoxLastEditedMinZoomScale: CGFloat
    
    /**
     Disallow any input while the rotation animation is playing
     */
    internal var rotateAnimationInProgress: Bool
    
    /* Reset state data */
    /**
     Save the original crop box size so we can tell when the content has been edited
     */
    private var originalCropBoxSize: CGSize
    
    /**
     Save the original content offset so we can tell if it's been scrolled.
     */
    private var originalContentOffset: CGPoint
    
    /**
     Whether the user has manipulated the crop view to the point where it can be reset
     */
    public internal(set) var isResettable: Bool {
        get{ _isResettableFlag }
        set{
            guard newValue != _isResettableFlag else { return }
            
            _isResettableFlag = newValue
            
            delegate?.cropView?(self, didChangeResettable: _isResettableFlag)
        }
    }
    
    /**
     In iOS 9, a new dynamic blur effect became available.
     */
    public internal(set) var dynamicBlurEffect: Bool
    
    // MARK: -                    ======================================================================================

    /**
     If restoring to a previous crop setting, these properties hang onto the
     values until the view is configured for the first time.
     */
    private var restoreAngle         : Int
    private var restoreImageCropFrame: CGRect
    
    /**
     Set to YES once `performInitialLayout` is called.
     This lets pending properties get queued until the view has been properly set up in its parent.
     */
    private var initialSetupPerformed: Bool
    
    // MARK: - Private properties ======================================================================================
    private var _cropBoxFrame            : CGRect
    private var _cropBoxResizeEnabled    : Bool
    private var _simpleRenderMode        : Bool
    private var _imageCropFrame          : CGRect
    private var _isEditing               : Bool
    private var _isResettableFlag        : Bool
    private var _aspectRatio             : CGSize
    private var _croppingViewsHidden     : Bool
    private var _gridOverlayHidden       : Bool
    private var _alwaysShowCroppingGrid  : Bool
    private var _translucencyAlwaysHidden: Bool
    
    var _angle                   : Int
    
    // MARK: - Initialized        ======================================================================================
    
    /**
     Create a new instance of the crop view with the specified image and cropping
     */
    public init(image: UIImage) {
        
        self.image = image
        
        self.aspectRatioLockDimensionSwapEnabled = true
        self.resetAspectRatioEnabled  = true
        self.cropViewPadding          = Constants.padding
        self.cropAdjustingDelay       = Constants.timerDuration
        
        self.cropBoxLastEditedSize         = CGSize.zero
        self.cropBoxLastEditedAngle        = 0
        self.cropBoxLastEditedZoomScale    = 0.0
        self.cropBoxLastEditedMinZoomScale = 0.0
        self.rotateAnimationInProgress     = false
        
        self.cropRegionInsets   = .zero
        self.minimumAspectRatio = CGFloat(0.0)
        self.internalLayoutDisabled = false
        self.aspectRatioLockEnabled = false
        
        self.tappedEdge = .none
        
        self.cropOriginFrame = CGRect.zero
        self.panOriginPoint  = CGPoint.zero
        
        self._angle       = 0
        self._isEditing   = false
        
        self._cropBoxFrame   = .zero
        self._aspectRatio    = .zero
        self._imageCropFrame = .zero
        
        self._isResettableFlag = false
        
        self._simpleRenderMode          = false
        self._cropBoxResizeEnabled      = false
        self._alwaysShowCroppingGrid    = false
        self._translucencyAlwaysHidden  = false
        self._gridOverlayHidden         = false
        self._croppingViewsHidden       = false
        
        self.disableForgroundMatching   = false
        
        self.rotationContentOffset = .zero
        self.rotationContentSize   = .zero
        self.rotationBoundFrame    = .zero
        self.originalCropBoxSize   = .zero
        self.originalContentOffset = .zero
        self.initialSetupPerformed = false
        self.maximumZoomScale      = Constants.maximumZoomScale
        self.applyInitialCroppedImageFrame = false
        
        self.dynamicBlurEffect = false
        
        self.restoreAngle           = 0
        self.restoreImageCropFrame  = .zero
        
        super.init(frame: .zero)
        
        // UI manager
        self.cropUIManager = CLDCropViewUIManager(cropView: self)
        
        // The pan controller to recognize gestures meant to resize the grid view
        self.gridPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gridPanGestureRecognized(_:)))
        
        self.cropBoxResizeEnabled     = true
        self.alwaysShowCroppingGrid   = false
        self.translucencyAlwaysHidden = false
        
        // View properties
        self.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.backgroundColor  = UIColor(white: 0.12, alpha: 1.0)
        self.cropBoxFrame = CGRect.zero
        self._isEditing   = false
        self._cropBoxResizeEnabled   = true
        self._aspectRatio            = CGSize.zero
        self.resetAspectRatioEnabled = true
        self.cropAdjustingDelay = Constants.timerDuration
        self.cropViewPadding    = Constants.padding
        
        
        /* Dynamic animation blurring is only possible on iOS 9, however since the API was available on iOS 8,
         we'll need to manually check the system version to ensure that it's available. */
        self.dynamicBlurEffect = UIDevice.current.systemVersion.compare("9.0", options: .numeric) != .orderedAscending
        
        // Scroll View
        self.scrollViewDelegate = CLDCropScrollViewController(cropView: self)
        
        self.scrollView = CLDCropScrollView(frame: bounds)
        self.scrollView.delegate = self.scrollViewDelegate
        
        self.addSubview(self.scrollView)
        
        // Disable smart inset behavior in iOS 11
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        self.scrollView.touchesBegan = { [weak self] in self?.startEditing() }
        self.scrollView.touchesEnded = { [weak self] in self?.startResetTimer() }
        
        // Background Image View
        self.backgroundImageView = UIImageView(image: self.image)
        self.backgroundImageView.layer.minificationFilter = CALayerContentsFilter.trilinear
        
        // Background container view
        self.backgroundContainerView = UIView(frame: self.backgroundImageView.frame)
        self.backgroundContainerView.addSubview(self.backgroundImageView)
        self.scrollView.addSubview(self.backgroundContainerView)
        
        // Grey transparent overlay view
        self.overlayView = UIView(frame: bounds)
        self.overlayView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.overlayView.backgroundColor  = self.backgroundColor?.withAlphaComponent(0.35)
        self.overlayView.isHidden = false
        self.overlayView.isUserInteractionEnabled = false
        self.addSubview(self.overlayView)
        
        // Translucency View
        self.translucencyEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        self.translucencyView   = UIVisualEffectView(effect: self.translucencyEffect)
        self.translucencyView.frame     = self.bounds
        self.translucencyView.isHidden  = self.translucencyAlwaysHidden
        self.translucencyView.isUserInteractionEnabled = false
        self.translucencyView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.addSubview(self.translucencyView)
        
        // The forground container that holds the foreground image view
        self.foregroundContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.foregroundContainerView.clipsToBounds = true
        self.foregroundContainerView.isUserInteractionEnabled = false
        self.addSubview(self.foregroundContainerView)
        
        self.foregroundImageView = UIImageView(image: self.image)
        self.foregroundImageView.layer.minificationFilter = CALayerContentsFilter.trilinear
        self.foregroundContainerView.addSubview(self.foregroundImageView)
        
        // Disable colour inversion for the image views
        if #available(iOS 11.0, *) {
            self.foregroundImageView.accessibilityIgnoresInvertColors = true
            self.backgroundImageView.accessibilityIgnoresInvertColors = true
        }
        
        // The white grid overlay view
        self.gridOverlayView = CLDCropOverlayView(frame: self.foregroundContainerView.frame)
        self.gridOverlayView.isUserInteractionEnabled = false
        self.gridOverlayView.isGridHidden = true
        self.addSubview(self.gridOverlayView)
        
        self.gridPanGestureRecognizer.delegate = self
        self.scrollView.panGestureRecognizer.require(toFail: self.gridPanGestureRecognizer)
        self.addGestureRecognizer(self.gridPanGestureRecognizer)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Layout
    
    /**
     Performs the initial set up, including laying out the image and applying any restore properties.
     This should be called once the crop view has been added to a parent that is in its final layout frame.
     */
    public func performInitialSetup() {
        
        // Calling this more than once is potentially destructive
        if initialSetupPerformed {
            return
        }
        
        // Disable from calling again
        initialSetupPerformed = true
        
        // Perform the initial layout of the image
        layoutInitialImage()
        
        // -- State Restoration --
        
        // If the angle value was previously set before this point, apply it now
        if (restoreAngle != 0) {
            angle = restoreAngle
            restoreAngle = 0
            cropBoxLastEditedAngle = angle
        }
        
        // If an image crop frame was also specified before creation, apply it now
        if !restoreImageCropFrame.isEmpty {
            imageCropFrame = restoreImageCropFrame
            restoreImageCropFrame = .zero
        }
        
        // Save the current layout state for later
        captureStateForImageRotation()
        
        // Check if we performed any resetabble modifications
        checkForCanReset()
    }
    
    private func layoutInitialImage() {
        
        let scaledImageSize = cropUIManager.manualLayout_initialImageAndGetScaledImageSize()
            
        // Save the current state for use with 90-degree rotations
        cropBoxLastEditedAngle = 0
        captureStateForImageRotation()
        
        //save the size for checking if we're in a resettable state
        originalCropBoxSize   = resetAspectRatioEnabled ? scaledImageSize : cropBoxFrame.size
        originalContentOffset = scrollView.contentOffset
        
        checkForCanReset()
        matchForegroundToBackground()
    }
    
    internal func matchForegroundToBackground() {
        if disableForgroundMatching { return }
        
        // We can't simply match the frames since if the images are rotated, the frame property becomes unusable
        if let view = backgroundContainerView.superview {
            foregroundImageView.frame = view.convert(backgroundContainerView.frame, to: foregroundContainerView)
        }
    }
    
    private func updateCropBoxFrame(withGesture point: CGPoint) {
        
        cropBoxFrame = Calculator.CropBox.calculateFrame(given: point, in: self)
        checkForCanReset()
    }
    
    private func toggleTranslucencyViewVisible(_ visible: Bool) {
        
        if dynamicBlurEffect == false {
            translucencyView.alpha  = visible ? 1.0 : 0.0
        } else {
            translucencyView.effect = visible ? translucencyEffect : nil
        }
    }
    
    // MARK: - Gesture Recognizer - ====================================================================================
    
    @objc private func gridPanGestureRecognized(_ recognizer: UIPanGestureRecognizer) {
        
        let point = recognizer.location(in: self)
        
        switch recognizer.state {
        case .began:
            startEditing()
            panOriginPoint  = point
            cropOriginFrame = cropBoxFrame
            tappedEdge = Calculator.overlayEdge(for: panOriginPoint, cropBoxFrame: cropBoxFrame)
            break
        case .ended:
            startResetTimer()
            break
        default:
            break
        }
        updateCropBoxFrame(withGesture: point)
    }
    
    // MARK: - Timer                ====================================================================================
    
    internal func startResetTimer() {
        
        if let _ = resetTimer {} else {
            resetTimer = Timer.scheduledTimer(timeInterval: cropAdjustingDelay, target: self, selector: #selector(timerTriggered), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func timerTriggered() {
        
        setEditing(false, resetCropBox: true, animated: true)
        resetTimer?.invalidate()
        resetTimer = nil
    }
    
    internal func cancelResetTimer() {
        
        resetTimer?.invalidate()
        resetTimer = nil
    }
    
    // MARK: - =========================================================================================================
    
    /**
     Changes the aspect ratio of the crop box to match the one specified
     
     - parameter aspectRatio The aspect ratio (For example 16:9 is 16.0f/9.0f). 'CGSizeZero' will reset it to the image's own ratio
     - parameter animated Whether the locking effect is animated
     */
    public func setAspectRatio(_ newValue: CGSize, animated: Bool) {
        
        _aspectRatio = newValue
        
        let adjustments = Calculator.AspectRatio.postChangeAdjustments(given: newValue, animated: animated, in: self)
        
        cropBoxLastEditedSize  = adjustments.cropBoxFrame.size
        cropBoxLastEditedAngle = angle
        
        let translateBlock : () -> Void = {

            self.scrollView.contentOffset = adjustments.scrollOffset
            self.cropBoxFrame = adjustments.cropBoxFrame
            
            if (adjustments.ShouldZoomOut) {
                self.scrollView.zoomScale = self.scrollView.minimumZoomScale
            }
            self.moveCroppedContentToCenterAnimated(false)
            self.checkForCanReset()
        }
        
        switch animated {
        case false:
            translateBlock()
            
        case true :
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.7, options: [.beginFromCurrentState],
                           animations: translateBlock, completion: nil)
        }
    }
    
    public func lockAspectRatio(to aspectRatio: CGSize) {
       
        if aspectRatioLockEnabled {
             _aspectRatio = aspectRatio
        }
    }
    
    /**
     Rotates the entire canvas to a 90-degree angle. The default rotation is counterclockwise.
     
     - parameter animated Whether the transition is animated
     */
    public func rotateImageNinetyDegreesAnimated(_ animated: Bool) {
        
        rotateImageNinetyDegreesAnimated(animated, clockwise: false)
    }
    
    /**
     Rotates the entire canvas to a 90-degree angle
     
     - parameter animated Whether the transition is animated
     - parameter clockwise Whether the rotation is clockwise. Passing 'NO' means counterclockwise
     */
    public func rotateImageNinetyDegreesAnimated(_ animated: Bool, clockwise: Bool) {
        
        cropUIManager.manualLayout_rotateImageNinetyDegreesAnimated(animated, clockwise: clockwise)
    }
    
    /**
     When triggered, the crop view will perform a relayout to ensure the crop box
     fills the entire crop view region
     */
    public func moveCroppedContentToCenterAnimated(_ animated: Bool) {
        cropUIManager.manualLayout_moveCroppedContentToCenterAnimated(animated)
    }
    
    // MARK: -- Editing Mode
    internal func captureStateForImageRotation() {
        
        cropBoxLastEditedSize         = cropBoxFrame.size
        cropBoxLastEditedZoomScale    = scrollView.zoomScale
        cropBoxLastEditedMinZoomScale = scrollView.minimumZoomScale
    }
    
    // MARK: -- Resettable State
    internal func checkForCanReset() {
        
        var resettable = false
        
        if angle != 0 { // Image has been rotated
            resettable = true
        }
        else if scrollView.zoomScale > scrollView.minimumZoomScale + CGFloat.ulpOfOne { // Image has been zoomed in
            resettable = true
        }
        else if
            Int(floor(cropBoxFrame.width )) != Int(floor(originalCropBoxSize.width )) ||
                Int(floor(cropBoxFrame.height)) != Int(floor(originalCropBoxSize.height)) // Crop box has been changed
        {
            resettable = true
        }
        else if
            Int(floor(scrollView.contentOffset.x)) != Int(floor(originalContentOffset.x)) ||
                Int(floor(scrollView.contentOffset.y)) != Int(floor(originalContentOffset.y))
        {
            resettable = true
        }
        
        isResettable = resettable
    }
    
    // MARK: -- fileprivate methods
    fileprivate func applyCropFrameAdjutsments(to scrollView: UIScrollView, originPoint: CGPoint, minimumScale: CGFloat, adjustedZoom scale: CGFloat) {
        
        let scaledOffset   = CGPoint(x: originPoint.x * minimumScale,
                                     y: originPoint.y * minimumScale)
        
        // Zoom into the scroll view to the appropriate size
        scrollView.zoomScale = scrollView.minimumZoomScale * scale
        
        scrollView.contentOffset = CGPoint(x: (scaledOffset.x * scale) - scrollView.contentInset.left,
                                           y: (scaledOffset.y * scale) - scrollView.contentInset.top)
    }
    
    fileprivate func applyDidSetCropBoxFrame(to rectangle: CGRect) {
        
        // Set the clipping view to match the new rect
        foregroundContainerView.frame = rectangle
        
        // Set the new overlay view to match the same region
        gridOverlayView.frame = rectangle
        
        Calculator.CropBox.updateScrollView(scrollView, given: backgroundContainerView.bounds.size,
                                            boundingRect: self.bounds, newCropBox: rectangle)
        
        // Re-align the background content to match
        matchForegroundToBackground()
    }
}
// MARK: - UIGestureRecognizerDelegate
extension CLDCropView : UIGestureRecognizerDelegate {
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer != gridPanGestureRecognizer {
            return true
        }
        
        let tapPoint = gestureRecognizer.location(in: self)
        
        let rectangle = gridOverlayView.frame
        let innerRectangle = rectangle.insetBy(dx:  22.0, dy:  22.0)
        let outerRectangle = rectangle.insetBy(dx: -22.0, dy: -22.0)
        
        if innerRectangle.contains(tapPoint) || !outerRectangle.contains(tapPoint) {
            return false
        }
        
        return true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if gridPanGestureRecognizer.state == .changed {
            return false
        }
        return true
    }
}

// MARK: - General extensions
fileprivate extension CGRect {
    
    var isValidBoxSize : Bool {
        // Upon init, sometimes the box size is still 0 (or NaN), which can result in CALayer issues
        let threashold = CGFloat.ulpOfOne
        if (width < threashold || height < threashold) { return false }
        if (width.isNaN        || height.isNaN       ) { return false }
        return true
    }
}
