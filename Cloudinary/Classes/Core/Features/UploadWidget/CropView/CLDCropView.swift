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

/**
 The shape of the cropping region of this crop view controller
 */
@objc
public enum CLDCropViewCroppingStyle : Int {
    case `default` // The regular, rectangular crop box
    case circular  // A fixed, circular crop box
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
 Whether the control toolbar is placed at the bottom or the top
 */
@objc
public enum CLDCropViewControllerToolbarPosition : Int {
    case bottom // Bar is placed along the bottom in portrait
    case top    // Bar is placed along the top in portrait (Respects the status bar)
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
    struct Constants {
        static let            padding : CGFloat      = CGFloat(14.0)     // kTOCropViewPadding
        static let      timerDuration : TimeInterval = TimeInterval(0.8) // kTOCropTimerDuration
        static let     minimumBoxSize : CGFloat      = CGFloat(42.0)     // kTOCropViewMinimumBoxSize
        static let circularPathRadius : CGFloat      = CGFloat(300.0)    // kTOCropViewCircularPathRadius
        static let   maximumZoomScale : CGFloat      = CGFloat(15.0)     // kTOMaximumZoomScale
    }
    
    // MARK: - =========================================================================================================
    
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
     The frame of the entire image in the backing scroll view
     */
    public var imageViewFrame: CGRect {
        
        var rectangle = CGRect.zero
        rectangle.origin.x = -scrollView.contentOffset.x
        rectangle.origin.y = -scrollView.contentOffset.y
        rectangle.size = scrollView.contentSize
        return rectangle
    }
    
    /**
     Inset the workable region of the crop view in case in order to make space for accessory views
     */
    public var cropRegionInsets: UIEdgeInsets
    
    /**
     Disable the dynamic translucency in order to smoothly relayout the view
     */
    public var simpleRenderMode: Bool {
        get { _simpleRenderMode }
        set { setSimpleRenderMode(newValue, animated: false) }
    }
    
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
     True when the height of the crop box is bigger than the width
     */
    public var cropBoxAspectRatioIsPortrait: Bool {
        return cropBoxFrame.width < cropBoxFrame.height
    }
    
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
     Hide all of the crop elements for transition animations
     */
    public var croppingViewsHidden: Bool {
        get { _croppingViewsHidden }
        set { setCroppingViewsHidden(newValue, animated: false) }
    }
    
    /**
     In relation to the coordinate space of the image, the frame that the crop view is focusing on
     */
    public var imageCropFrame: CGRect {
        get {
            let  targetSize = imageSize
            let contentSize = scrollView.contentSize
            
            let cropRectangle = cropBoxFrame
            
            let offset = scrollView.contentOffset
            let insets = scrollView.contentInset
            
            let scale = min(targetSize.width / contentSize.width, targetSize.height / contentSize.height)
            
            var rectangle = CGRect.zero
            
            // Calculate the normalized origin
            rectangle.origin.x = floor((floor(offset.x) + insets.left) * (targetSize.width  / contentSize.width ))
            rectangle.origin.x = max(0, rectangle.origin.x)
            
            rectangle.origin.y = floor((floor(offset.y) + insets.top ) * (targetSize.height / contentSize.height))
            rectangle.origin.y = max(0, rectangle.origin.y)
               
            // Calculate the normalized width
            rectangle.size.width = ceil(cropRectangle.width * scale)
            rectangle.size.width = min(targetSize.width, rectangle.width)
            
            // Calculate normalized height
            if floor(cropRectangle.width) == floor(cropRectangle.height) {
                rectangle.size.height = rectangle.size.width
            } else {
                rectangle.size.height = ceil(cropRectangle.height * scale)
                rectangle.size.height = min(targetSize.height, rectangle.size.height)
            }
            rectangle.size.height = min(targetSize.height, rectangle.size.height)
            
            return rectangle
        }
        set {
            
            if !initialSetupPerformed {
                restoreImageCropFrame = newValue
                return
            }
            
            //Convert the image crop frame's size from image space to the screen space
            let minimumSize    = scrollView.minimumZoomScale
            
            let scaledOffset   = CGPoint(x: newValue.origin.x * minimumSize,
                                         y: newValue.origin.y * minimumSize)
            
            let scaledCropSize = CGSize(width : newValue.width  * minimumSize,
                                        height: newValue.height * minimumSize)
            
            // Work out the scale necessary to upscale the crop size to fit the content bounds of the crop bound
            let boundsRectangle  = contentBounds
            
            let scale = min(boundsRectangle.width  / scaledCropSize.width,
                            boundsRectangle.height / scaledCropSize.height)
            
            // Zoom into the scroll view to the appropriate size
            scrollView.zoomScale = scrollView.minimumZoomScale * scale
            
            // Work out the size and offset of the upscaled crop box
            var frameRectangle = CGRect.zero
            frameRectangle.size = CGSize(width : scaledCropSize.width  * scale,
                                         height: scaledCropSize.height * scale)
            
            //set the crop box
            var cropBoxRectangle = CGRect.zero
            cropBoxRectangle.size = frameRectangle.size
            cropBoxRectangle.origin.x = boundsRectangle.midX - (frameRectangle.width  * 0.5)
            cropBoxRectangle.origin.y = boundsRectangle.midY - (frameRectangle.height * 0.5)
            cropBoxFrame = cropBoxRectangle
            
            frameRectangle.origin.x = (scaledOffset.x * scale) - scrollView.contentInset.left
            frameRectangle.origin.y = (scaledOffset.y * scale) - scrollView.contentInset.top
            scrollView.contentOffset = frameRectangle.origin
        }
    }
    
    /**
     Set the grid overlay graphic to be hidden
     */
    public var gridOverlayHidden: Bool {
        get { _gridOverlayHidden }
        set { setGridOverlayHidden(newValue, animated: false) }
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
            if _translucencyAlwaysHidden == newValue { return }
            _translucencyAlwaysHidden = newValue
            translucencyView.isHidden = newValue
        }
    }
    
    /**
     The image that the crop view is displaying. This cannot be changed once the crop view is instantiated.
     */
    public internal(set) var image : UIImage
    
    /**
     The cropping style of the crop view (eg, rectangular or circular)
     */
    public internal(set) var croppingStyle : CLDCropViewCroppingStyle
    
    /* Views */
    /**
     The main image view, placed within the scroll view
     */
    private var backgroundImageView: UIImageView!
    
    /**
     A view which contains the background image view, to separate its transforms from the scroll view.
     */
    private var backgroundContainerView: UIView!
    
    /**
     A container view that clips the a copy of the image so it appears over the dimming view
     */
    private(set) public var foregroundContainerView: UIView!
    
    /**
     A copy of the background image view, placed over the dimming views
     */
    private var foregroundImageView: UIImageView!
    
    /**
     The scroll view in charge of panning/zooming the image.
     */
    private var scrollView: CLDCropScrollView!
    
    /**
     A semi-transparent grey view, overlaid on top of the background image
     */
    private var overlayView: UIView!
    
    /**
     A blur view that is made visible when the user isn't interacting with the crop view
     */
    private var translucencyView: UIVisualEffectView!
    
    /**
     The dark blur visual effect applied to the visual effect view.
     */
    private var translucencyEffect: UIBlurEffect!
    
    /**
     A grid view overlaid on top of the foreground image view's container.
     */
    private(set) public var gridOverlayView: CLDCropOverlayView!
    
    /**
     Managing the clipping of the foreground container into a circle
     */
    private var circularMaskLayer: CAShapeLayer?
    
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
    private var tappedEdge: CLDCropViewOverlayEdge
    
    /**
     When resizing, this is the original frame of the crop box.
     */
    private var cropOriginFrame : CGRect
    
    /**
     The initial touch point of the pan gesture recognizer
     */
    private var  panOriginPoint : CGPoint
    
    /**
     The frame of the cropping box in the coordinate space of the crop view
     */
    public internal(set) var cropBoxFrame: CGRect {
        get { _cropBoxFrame }
        set {
            if _cropBoxFrame.equalTo(newValue) { return }
            
            // Upon init, sometimes the box size is still 0 (or NaN), which can result in CALayer issues
            if (newValue.width  < CGFloat(Float.ulpOfOne) || newValue.height < CGFloat(Float.ulpOfOne)) { return }
            if (newValue.width.isNaN || newValue.height.isNaN) { return }
            
            _cropBoxFrame = clampedCropRect(given: contentBounds, cropBox: newValue)
            
            didSet(cropBoxFrame: _cropBoxFrame)
        }
    }
    
    /**
     Clamp the cropping region to the inset boundaries of the screen
     */
    fileprivate func clampedCropRect(given contentRectangle: CGRect, cropBox rectangle: CGRect) -> CGRect {
        
        var clamped = rectangle
        
        let xOrigin = ceil(contentRectangle.origin.x)
        let xDelta = clamped.origin.x - xOrigin
        clamped.origin.x = floor(max(clamped.origin.x, xOrigin))
        // If we clamp the x value, ensure we compensate for the subsequent delta generated in the width (Or else, the box will keep growing)
        if (xDelta < -CGFloat(Float.ulpOfOne)) { clamped.size.width  += xDelta }
        
        let yOrigin = ceil(contentRectangle.origin.y)
        let yDelta = clamped.origin.y - yOrigin
        clamped.origin.y = floor(max(clamped.origin.y, yOrigin))
        // If we clamp the y value, ensure we compensate for the subsequent delta generated in the width (Or else, the box will keep growing)
        if (yDelta < -CGFloat(Float.ulpOfOne)) { clamped.size.height += yDelta }
        
        // Given the clamped X / Y values, make sure we can't extend the crop box beyond the edge of the screen in the current state
        let maxWidth  = (contentRectangle.width  + contentRectangle.origin.x) - clamped.origin.x
        clamped.size.width  = floor(min(clamped.width , maxWidth))
        
        let maxHeight = (contentRectangle.height + contentRectangle.origin.y) - clamped.origin.y
        clamped.size.height = floor(min(clamped.height, maxHeight))
        
        // Make sure we can't make the crop box too small
        clamped.size.width  = max(clamped.width , Constants.minimumBoxSize)
        clamped.size.height = max(clamped.height, Constants.minimumBoxSize)
        
        return clamped
    }
    
    fileprivate func didSet(cropBoxFrame rectangle: CGRect) {
        
        // Set the clipping view to match the new rect
        foregroundContainerView.frame = rectangle
        
        // Set the new overlay view to match the same region
        gridOverlayView.frame = rectangle
        
        // If the mask layer is present, adjust its transform to fit the new container view size
        if let layer = circularMaskLayer {
            let scale = rectangle.width / Constants.circularPathRadius
            layer.transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1.0)
        }
        
        // Reset the scroll view insets to match the region of the new crop rect
        scrollView.contentInset = UIEdgeInsets(top : rectangle.minY,
                                               left: rectangle.minX,
                                               bottom: bounds.maxY - rectangle.maxY,
                                               right : bounds.maxX - rectangle.maxX)
        
        // if necessary, work out the new minimum size of the scroll view so it fills the crop box
        let imageSize = backgroundContainerView.bounds.size
        let scale = max(rectangle.height / imageSize.height,
                        rectangle.width  / imageSize.width)
        
        scrollView.minimumZoomScale = scale
        
        // Make sure content isn't smaller than the crop box
        var size = scrollView.contentSize
        size.width  = floor(size.width )
        size.height = floor(size.height)
        scrollView.contentSize = size
        
        // IMPORTANT: Force the scroll view to update its content after changing the zoom scale
        let zoomScale = scrollView.zoomScale
        scrollView.zoomScale = zoomScale
        
        // Re-align the background content to match
        matchForegroundToBackground()
    }
    
    /**
     The timer used to reset the view after the user stops interacting with it
     */
    private var resetTimer: Timer?
    
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
    
    private func startEditing() {
        cancelResetTimer()
        setEditing(true, resetCropBox: false, animated: true)
    }
    
    private func setEditing(_ editing: Bool, resetCropBox: Bool, animated: Bool) {
        
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
            var delay    = editing ? 0.00 : 0.35
            
            if croppingStyle == .circular {
                delay = 0.0
            }
            
            UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
                
                self.toggleTranslucencyViewVisible(!editing)
                
            }, completion: nil)
        }
    }
    
    /**
     At times during animation, disable matching the forground image view to the background
     */
    private var disableForgroundMatching: Bool
    
    /* Pre-screen-rotation state information */
    private var rotationContentOffset: CGPoint
    private var rotationContentSize  : CGSize
    private var rotationBoundFrame   : CGRect
    
    /* View State information */
    /**
     Give the current screen real-estate, the frame that the scroll view is allowed to use
     */
    private var contentBounds: CGRect {
        
        var rectangle = CGRect.zero
        rectangle.origin.x = cropViewPadding + cropRegionInsets.left
        rectangle.origin.y = cropViewPadding + cropRegionInsets.top
        rectangle.size.width  = bounds.width  - ((cropViewPadding * 2) + cropRegionInsets.left + cropRegionInsets.right)
        rectangle.size.height = bounds.height - ((cropViewPadding * 2) + cropRegionInsets.top  + cropRegionInsets.bottom)
        return rectangle
    }
    
    /**
     Given the current rotation of the image, the size of the image
     */
    private var imageSize: CGSize {
        
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
    private var hasAspectRatio: Bool {
        
        return aspectRatio.width > CGFloat(Float.ulpOfOne) && aspectRatio.height > CGFloat(Float.ulpOfOne)
    }
    
    /* 90-degree rotation state data */
    /**
     When performing 90-degree rotations, remember what our last manual size was to use that as a base
     */
    private var cropBoxLastEditedSize: CGSize
    
    /**
     Remember which angle we were at when we saved the editing size
     */
    private var cropBoxLastEditedAngle: Int
    
    /**
     Remember the zoom size when we last edited
     */
    private var cropBoxLastEditedZoomScale: CGFloat
    
    /**
     Remember the minimum size when we last edited.
     */
    private var cropBoxLastEditedMinZoomScale: CGFloat
    
    /**
     Disallow any input while the rotation animation is playing
     */
    private var rotateAnimationInProgress: Bool
    
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
    private var _angle                   : Int
    
    // MARK: - Initialized        ======================================================================================
    
    /**
     Create a new instance of the crop view with the specified image and cropping
     */
    public init(image: UIImage, croppingStyle style: CLDCropViewCroppingStyle = .default) {
        
        self.image = image
        self.croppingStyle = style
        
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
        
        // The pan controller to recognize gestures meant to resize the grid view
        self.gridPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gridPanGestureRecognized(_:)))
        
        self.cropBoxResizeEnabled     = true
        self.alwaysShowCroppingGrid   = false
        self.translucencyAlwaysHidden = false
        
        // __weak typeof(self) weakSelf = self
        
        let circularMode = style == .circular
        
        // View properties
        self.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.backgroundColor  = UIColor(white: 0.12, alpha: 1.0)
        self.cropBoxFrame = CGRect.zero
        self._isEditing   = false
        self._cropBoxResizeEnabled   = !circularMode
        self._aspectRatio            = circularMode ? CGSize(width: 1.0, height: 1.0) : CGSize.zero
        self.resetAspectRatioEnabled = !circularMode
        self.cropAdjustingDelay = Constants.timerDuration
        self.cropViewPadding    = Constants.padding
        
        
        /* Dynamic animation blurring is only possible on iOS 9, however since the API was available on iOS 8,
         we'll need to manually check the system version to ensure that it's available. */
        self.dynamicBlurEffect = UIDevice.current.systemVersion.compare("9.0", options: .numeric) != .orderedAscending
        
        // Scroll View properties
        self.scrollView = CLDCropScrollView(frame: bounds)
        self.scrollView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.scrollView.alwaysBounceHorizontal = true
        self.scrollView.alwaysBounceVertical   = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator   = false
        self.scrollView.delegate = self
        
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
        
        // The following setup isn't needed during circular cropping
        if (circularMode) {
            
            let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width : Constants.circularPathRadius,
                                                                               height: Constants.circularPathRadius)))
            
            let layer  = CAShapeLayer()
            layer.path = path.cgPath
            
            self.circularMaskLayer = layer
            self.foregroundContainerView.layer.mask = layer
            
            return
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
        
        scrollView.contentSize = imageSize
        
        let boundsRectangle = contentBounds
        let boundsSize      = boundsRectangle.size
        
        // Work out the minimum scale of the object
        var  scale = CGFloat(0.0)
        
        // Work out the size of the image to fit into the content bounds
        scale = min(boundsRectangle.width / imageSize.width, boundsRectangle.height / imageSize.height)
        
        let scaledImageSize = CGSize(width : floor(imageSize.width  * scale),
                                     height: floor(imageSize.height * scale))
        
        // If an aspect ratio was pre-applied to the crop view, use that to work out the minimum scale the image needs to be to fit
        var cropBoxSize = CGSize.zero
        
        if (hasAspectRatio) {
            
            let    ratioScale = aspectRatio.width / aspectRatio.height // Work out the size of the width in relation to height
            let fullSizeRatio = CGSize(width: boundsSize.height * ratioScale, height: boundsSize.height)
            
            let fitScale = min(boundsSize.width / fullSizeRatio.width, boundsSize.height / fullSizeRatio.height)
            
            cropBoxSize  = CGSize(width: fullSizeRatio.width * fitScale, height: fullSizeRatio.height * fitScale)
            scale        = max(cropBoxSize.width / imageSize.width, cropBoxSize.height / imageSize.height)
        }
        
        //Whether aspect ratio, or original, the final image size we'll base the rest of the calculations off
        let scaledSize = CGSize(width: floor(imageSize.width * scale), height: floor(imageSize.height * scale))
        
        // Configure the scroll view
        scrollView.minimumZoomScale = scale
        scrollView.maximumZoomScale = scale * maximumZoomScale
        
        // Set the crop box to the size we calculated and align in the middle of the screen
        var rectangle  = CGRect.zero
        rectangle.size = hasAspectRatio ? cropBoxSize : scaledSize
        rectangle.origin.x = boundsRectangle.origin.x + floor((boundsRectangle.width  - rectangle.width ) * 0.5)
        rectangle.origin.y = boundsRectangle.origin.y + floor((boundsRectangle.height - rectangle.height) * 0.5)
        cropBoxFrame = rectangle
        
        // Set the fully zoomed out state initially
        scrollView.zoomScale   = scrollView.minimumZoomScale
        scrollView.contentSize = scaledSize
        
        // If we ended up with a smaller crop box than the content, line up the content so its center
        // is in the center of the cropbox
        if (rectangle.width < scaledSize.width - CGFloat(Float.ulpOfOne) || rectangle.height < scaledSize.height - CGFloat(Float.ulpOfOne)) {
            
            var offset = CGPoint.zero
            offset.x = -floor(boundsRectangle.midX - (scaledSize.width  * 0.5))
            offset.y = -floor(boundsRectangle.midY - (scaledSize.height * 0.5))
            scrollView.contentOffset = offset
        }
        
        // Save the current state for use with 90-degree rotations
        cropBoxLastEditedAngle = 0
        captureStateForImageRotation()
        
        //save the size for checking if we're in a resettable state
        originalCropBoxSize   = resetAspectRatioEnabled ? scaledImageSize : cropBoxFrame.size
        originalContentOffset = scrollView.contentOffset
        
        checkForCanReset()
        matchForegroundToBackground()
    }
    
    /**
     When performing large size transitions (eg, orientation rotation),
     set simple mode to YES to temporarily graphically heavy effects like translucency.
     
     - parameter simpleMode Whether simple mode is enabled or not
     */
    public func setSimpleRenderMode(_ simpleMode: Bool, animated: Bool) {
        
        if _simpleRenderMode == simpleMode { return }
        _simpleRenderMode = simpleMode
        
        isEditing = false
        
        switch animated {
        case true:
            
            UIView.animate(withDuration: 0.25) {
                self.toggleTranslucencyViewVisible(!simpleMode)
            }
            
        case false:
            toggleTranslucencyViewVisible(!simpleMode)
        }
    }
    
    /**
     When performing a screen rotation that will change the size of the scroll view, this takes
     a snapshot of all of the scroll view data before it gets manipulated by iOS.
     Please call this in your view controller, before the rotation animation block is committed.
     */
    public func prepareforRotation() {
        
        rotationContentOffset = scrollView.contentOffset
        rotationContentSize   = scrollView.contentSize
        rotationBoundFrame    = contentBounds
    }
    
    /**
     Performs the realignment of the crop view while the screen is rotating.
     Please call this inside your view controller's screen rotation animation block.
     */
    public func performRelayoutForRotation()
    {
        var    cropFrame = self.cropBoxFrame
        let contentFrame = self.contentBounds
        
        let scale = min(contentFrame.width / cropFrame.width, contentFrame.height / cropFrame.height)
        scrollView.minimumZoomScale *= scale
        scrollView.zoomScale *= scale
        
        // Work out the centered, upscaled version of the crop rectangle
        cropFrame.size.width  = floor(cropFrame.width * scale)
        cropFrame.size.height = floor(cropFrame.height * scale)
        cropFrame.origin.x    = floor(contentFrame.origin.x + ((contentFrame.width  - cropFrame.width ) * 0.5))
        cropFrame.origin.y    = floor(contentFrame.origin.y + ((contentFrame.height - cropFrame.height) * 0.5))
        cropBoxFrame = cropFrame
        
        captureStateForImageRotation()
        
        // Work out the center point of the content before we rotated
        let   oldMidPoint = CGPoint(x: rotationBoundFrame.midX                , y: rotationBoundFrame.midY                )
        let contentCenter = CGPoint(x: rotationContentOffset.x + oldMidPoint.x, y: rotationContentOffset.y + oldMidPoint.y)
        
        // Normalize it to a percentage we can apply to different sizes
        var normalizedCenter = CGPoint.zero
        normalizedCenter.x   = contentCenter.x / rotationContentSize.width
        normalizedCenter.y   = contentCenter.y / rotationContentSize.height
        
        // Work out the new content offset by applying the normalized values to the new layout
        
        let newMidPoint = CGPoint(x: contentBounds.midX, y: contentBounds.midY)
        
        var translatedContentOffset = CGPoint.zero
        translatedContentOffset.x   = scrollView.contentSize.width  * normalizedCenter.x
        translatedContentOffset.y   = scrollView.contentSize.height * normalizedCenter.y
        
        var offset = CGPoint.zero
        offset.x = floor(translatedContentOffset.x - newMidPoint.x)
        offset.y = floor(translatedContentOffset.y - newMidPoint.y)
        
        // Make sure it doesn't overshoot the top left corner of the crop box
        offset.x = max(-scrollView.contentInset.left, offset.x)
        offset.y = max(-scrollView.contentInset.top , offset.y)
        
        // Nor undershoot the bottom right corner
        var maximumOffset = CGPoint.zero
        maximumOffset.x   = (bounds.width  - scrollView.contentInset.right ) + scrollView.contentSize.width
        maximumOffset.y   = (bounds.height - scrollView.contentInset.bottom) + scrollView.contentSize.height
        offset.x = min(offset.x, maximumOffset.x)
        offset.y = min(offset.y, maximumOffset.y)
        scrollView.contentOffset = offset
        
        // Line up the background instance of the image
        matchForegroundToBackground()
    }
    
    private func matchForegroundToBackground() {
        if disableForgroundMatching { return }
        
        // We can't simply match the frames since if the images are rotated, the frame property becomes unusable
        if let view = backgroundContainerView.superview {
            foregroundImageView.frame = view.convert(backgroundContainerView.frame, to: foregroundContainerView)
        }
    }
    private func updateCropBoxFrame(withGesture point: CGPoint) {
        
        var    rectangle = cropBoxFrame
        let  originFrame = cropOriginFrame
        let contentFrame = contentBounds
        
        var point = point
        point.x = max(contentFrame.origin.x - cropViewPadding, point.x)
        point.y = max(contentFrame.origin.y - cropViewPadding, point.y)
        
        //The delta between where we first tapped, and where our finger is now
        var xDelta = ceil(point.x - panOriginPoint.x)
        var yDelta = ceil(point.y - panOriginPoint.y)
        
        //Current aspect ratio of the crop box in case we need to clamp it
        let aspectRatio = (originFrame.width / originFrame.height)
        
        //Note whether we're being aspect transformed horizontally or vertically
        var aspectHorizontal = false
        var aspectVertical   = false
        
        // Depending on which corner we drag from, set the appropriate min flag to
        // ensure we can properly clamp the XY value of the box if it overruns the minimum size
        // (Otherwise the image itself will slide with the drag gesture)
        var clampMinFromTop  = false
        var clampMinFromLeft = false
        
        switch tappedEdge {
        case .left:
            
            if aspectRatioLockEnabled {
                aspectHorizontal = true
                xDelta = max(xDelta, 0)
                
                let scaleOrigin = CGPoint(x: originFrame.maxX, y: originFrame.midY)
                rectangle.size.height = rectangle.width / aspectRatio
                rectangle.origin.y    = scaleOrigin.y - (rectangle.height * 0.5)
            }
            
            let newWidth  = originFrame.width - xDelta
            let newHeight = originFrame.height
            
            if min(newHeight, newWidth) / max(newHeight, newWidth) >= minimumAspectRatio {
                rectangle.origin.x   = originFrame.origin.x + xDelta
                rectangle.size.width = originFrame.width - xDelta
            }
            clampMinFromLeft = true
            
        case .right:
            
            if aspectRatioLockEnabled {
                aspectHorizontal = true
                
                let scaleOrigin = CGPoint(x: originFrame.minX, y: originFrame.midY)
                rectangle.size.height = rectangle.width / aspectRatio
                rectangle.origin.y    = scaleOrigin.y - (rectangle.height * 0.5)
                rectangle.size.width  = originFrame.size.width + xDelta
                rectangle.size.width  = min(rectangle.width, contentFrame.height * aspectRatio)
                
            } else {
                
                let newWidth  = originFrame.width + xDelta
                let newHeight = originFrame.height
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= minimumAspectRatio {
                    rectangle.size.width = originFrame.width + xDelta
                }
            }
            
        case .bottom:
            
            if aspectRatioLockEnabled {
                
                aspectVertical = true
                
                let scaleOrigin = CGPoint(x: originFrame.midX, y: originFrame.minY)
                rectangle.size.width  = rectangle.height * aspectRatio
                rectangle.origin.x    = scaleOrigin.x - (rectangle.size.width * 0.5)
                rectangle.size.height = originFrame.height + yDelta
                rectangle.size.height = min(rectangle.height, contentFrame.width / aspectRatio)
                
            } else {
                
                let newWidth  = originFrame.width
                let newHeight = originFrame.height + yDelta
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= minimumAspectRatio {
                    rectangle.size.height = originFrame.height + yDelta
                }
            }
            
        case .top:
            
            if aspectRatioLockEnabled {
                aspectVertical = true
                yDelta = max(0,yDelta)
                
                let scaleOrigin = CGPoint(x: originFrame.midX, y: originFrame.midY)
                rectangle.origin.x    = scaleOrigin.x - (rectangle.size.width * 0.5)
                rectangle.origin.y    = originFrame.origin.y + yDelta
                rectangle.size.width  = rectangle.height * aspectRatio
                rectangle.size.height = originFrame.height - yDelta
                
            } else {
                
                let  newWidth = originFrame.width
                let newHeight = originFrame.height - yDelta
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= minimumAspectRatio {
                    rectangle.origin.y    = originFrame.origin.y + yDelta
                    rectangle.size.height = originFrame.height   - yDelta
                }
            }
            
            clampMinFromTop = true
            
        case .topLeft:
            
            if aspectRatioLockEnabled {
                xDelta = max(xDelta, 0)
                yDelta = max(yDelta, 0)
                
                var distance = CGPoint.zero
                distance.x = 1.0 - (xDelta / originFrame.width )
                distance.y = 1.0 - (yDelta / originFrame.height)
                
                let scale = (distance.x + distance.y) * 0.5
                
                rectangle.size.width  = ceil(originFrame.width  * scale)
                rectangle.size.height = ceil(originFrame.height * scale)
                rectangle.origin.x = originFrame.origin.x + (originFrame.width  - rectangle.width )
                rectangle.origin.y = originFrame.origin.y + (originFrame.height - rectangle.height)
                
                aspectHorizontal = true
                aspectVertical   = true
                
            } else {
                
                let newWidth  = originFrame.width  - xDelta
                let newHeight = originFrame.height - yDelta
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= minimumAspectRatio {
                    rectangle.origin.x    = originFrame.origin.x + xDelta
                    rectangle.origin.y    = originFrame.origin.y + yDelta
                    rectangle.size.width  = originFrame.width    - xDelta
                    rectangle.size.height = originFrame.height   - yDelta
                }
            }
            clampMinFromTop  = true
            clampMinFromLeft = true
            
        case .topRight:
            
            if aspectRatioLockEnabled {
                
                xDelta = min(xDelta, 0)
                yDelta = max(yDelta, 0)
                
                var distance = CGPoint.zero
                distance.x = 1.0 - ((-xDelta) / originFrame.width )
                distance.y = 1.0 - (( yDelta) / originFrame.height)
                
                let scale = (distance.x + distance.y) * 0.5
                
                rectangle.size.width  = ceil(originFrame.width  * scale)
                rectangle.size.height = ceil(originFrame.height * scale)
                rectangle.origin.y    = originFrame.origin.y + (originFrame.height - rectangle.height)
                
                aspectHorizontal = true
                aspectVertical   = true
                
            } else {
                
                let newWidth  = originFrame.width  + xDelta
                let newHeight = originFrame.height - yDelta
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= minimumAspectRatio {
                    rectangle.size.width  = originFrame.width    + xDelta
                    rectangle.size.height = originFrame.height   - yDelta
                    rectangle.origin.y    = originFrame.origin.y + yDelta
                }
            }
            clampMinFromTop = true
            
        case .bottomLeft:
            
            if aspectRatioLockEnabled {
                
                var distance = CGPoint.zero
                distance.x = 1.0 - ( xDelta / originFrame.width )
                distance.y = 1.0 - (-yDelta / originFrame.height)
                
                let scale = (distance.x + distance.y) * 0.5
                rectangle.size.width  = ceil(originFrame.width  * scale)
                rectangle.size.height = ceil(originFrame.height * scale)
                rectangle.origin.x  = originFrame.maxX - rectangle.width
                
                aspectHorizontal = true
                aspectVertical   = true
                
            } else {
                
                let newWidth  = originFrame.width  - xDelta
                let newHeight = originFrame.height + yDelta
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= minimumAspectRatio {
                    rectangle.origin.x    = originFrame.origin.x + xDelta
                    rectangle.size.height = originFrame.height   + yDelta
                    rectangle.size.width  = originFrame.width    - xDelta
                }
            }
            clampMinFromLeft = true
            
            
        case .bottomRight:
            
            if aspectRatioLockEnabled {
                
                var distance = CGPoint.zero
                distance.x = 1.0 - ((-1 * xDelta) / originFrame.width )
                distance.y = 1.0 - ((-1 * yDelta) / originFrame.height)
                
                let scale = (distance.x + distance.y) * 0.5
                rectangle.size.width  = ceil(originFrame.width  * scale)
                rectangle.size.height = ceil(originFrame.height * scale)
                
                aspectHorizontal = true
                aspectVertical   = true
                
            } else {
                
                let newWidth  = originFrame.width  + xDelta
                let newHeight = originFrame.height + yDelta
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= minimumAspectRatio {
                    rectangle.size.height = originFrame.height + yDelta
                    rectangle.size.width  = originFrame.width  + xDelta
                }
            }
            
        case .none:
            break
        }
        
        //The absolute max/min size the box may be in the bounds of the crop view
        
        var minSize = CGSize(width: Constants.minimumBoxSize, height: Constants.minimumBoxSize)
        var maxSize = CGSize(width: contentFrame.width      , height: contentFrame.height     )
        
        //clamp the box to ensure it doesn't go beyond the bounds we've set
        if (aspectRatioLockEnabled && aspectHorizontal) {
            minSize.width  = Constants.minimumBoxSize * aspectRatio
            maxSize.height = contentFrame.width / aspectRatio
        }
        
        if (aspectRatioLockEnabled && aspectVertical) {
            maxSize.width  = contentFrame.height * aspectRatio
            minSize.height = Constants.minimumBoxSize / aspectRatio
        }
        
        // Clamp the width if it goes over
        if (clampMinFromLeft) {
            let maxWidth  = cropOriginFrame.maxX - contentFrame.origin.x
            rectangle.size.width = min(rectangle.width, maxWidth)
        }
        
        if (clampMinFromTop) {
            let maxHeight = cropOriginFrame.maxY - contentFrame.origin.y
            rectangle.size.height = min(rectangle.height, maxHeight)
        }
        
        // Clamp the minimum size
        rectangle.size.width  = max(rectangle.width , minSize.width )
        rectangle.size.height = max(rectangle.height, minSize.height)
        
        // Clamp the maximum size
        rectangle.size.width  = min(rectangle.width , maxSize.width )
        rectangle.size.height = min(rectangle.height, maxSize.height)
        
        //Clamp the X position of the box to the interior of the cropping bounds
        rectangle.origin.x = max(rectangle.origin.x, contentFrame.minX)
        rectangle.origin.x = min(rectangle.origin.x, contentFrame.maxX - minSize.width)
        
        //Clamp the Y postion of the box to the interior of the cropping bounds
        rectangle.origin.y = max(rectangle.origin.y, contentFrame.minY)
        rectangle.origin.y = min(rectangle.origin.y, contentFrame.maxY - minSize.height)
        
        //Once the box is completely shrunk, clamp its ability to move
        if (clampMinFromLeft && rectangle.width <= minSize.width + CGFloat(Float.ulpOfOne)) {
            rectangle.origin.x = originFrame.maxX - minSize.width
        }
        
        //Once the box is completely shrunk, clamp its ability to move
        if (clampMinFromTop && rectangle.height <= minSize.height + CGFloat(Float.ulpOfOne)) {
            rectangle.origin.y = originFrame.maxY - minSize.height
        }
        
        cropBoxFrame = rectangle
        
        checkForCanReset()
    }
    
    /**
     Reset the crop box and zoom scale back to the initial layout
     
     - parameter animated The reset is animated
     */
    public func resetLayoutToDefaultAnimated(_ animated: Bool) {
        
        // If resetting the crop view includes resetting the aspect ratio,
        // reset it to zero here. But set the ivar directly since there's no point
        // in performing the relayout calculations right before a reset.
        if (hasAspectRatio && resetAspectRatioEnabled) {
            _aspectRatio = CGSize.zero
        }
        
        if (angle != 0) {
            
            // Reset all of the rotation transforms
            _angle = 0
            
            UIView.animate(withDuration: 0.3) {
                
                // Set the scroll to 1.0f to reset the transform scale
                self.scrollView.zoomScale = 1.0
                
                let imageRect = CGRect(origin: .zero, size: self.image.size)
                
                // Reset everything about the background container and image views
                self.backgroundImageView.transform     = CGAffineTransform.identity
                self.backgroundContainerView.transform = CGAffineTransform.identity
                self.backgroundImageView.frame     = imageRect
                self.backgroundContainerView.frame = imageRect
                
                // Reset the transform ans size of just the foreground image
                self.foregroundImageView.transform = CGAffineTransform.identity
                self.foregroundImageView.frame     = imageRect
                
                // Reset the layout
                
                self.layoutInitialImage()
            }
            
            // Enable / Disable the reset button
            checkForCanReset()
            
            return
        }
        
        // If we were in the middle of a reset timer, cancel it as we'll
        // manually perform a restoration animation here
        if resetTimer != nil {
            cancelResetTimer()
            setEditing(false, resetCropBox: false, animated: false)
        }
        
        setSimpleRenderMode(true, animated: false)
        
        // Perform an animation of the image zooming back out to its original size
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState], animations: {
                
                self.layoutInitialImage()
                
            }, completion: { (complete) in
                
                self.setSimpleRenderMode(false, animated: true)
            })
        }
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
            tappedEdge = cropEdge(for: panOriginPoint)
            break
        case .ended:
            startResetTimer()
            break
        default:
            break
        }
        updateCropBoxFrame(withGesture: point)
    }
    
    @objc private func longPressGestureRecognized(_ recognizer: UILongPressGestureRecognizer) {
        
        switch recognizer.state {
        case .began: gridOverlayView.setGridlines(hidden: false, animted: true)
        case .ended: gridOverlayView.setGridlines(hidden: true , animted: true)
        default: break
        }
    }
    
    // MARK: - Timer                ====================================================================================
    
    private func startResetTimer() {
        
        if let _ = resetTimer {} else {
            resetTimer = Timer.scheduledTimer(timeInterval: cropAdjustingDelay, target: self, selector: #selector(timerTriggered), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func timerTriggered() {
        
        setEditing(false, resetCropBox: true, animated: true)
        resetTimer?.invalidate()
        resetTimer = nil
    }
    
    private func cancelResetTimer() {
        
        resetTimer?.invalidate()
        resetTimer = nil
    }
    
    private func cropEdge(for point: CGPoint) -> CLDCropViewOverlayEdge {
        
        var rectangle = cropBoxFrame
        
        // Account for padding around the box
        rectangle = rectangle.insetBy(dx: -32.0, dy: -32.0)
        
        // Make sure the corners take priority
        let rectangleTopLeft = CGRect(origin: rectangle.origin, size: CGSize(width: 64, height: 64))
        if  rectangleTopLeft.contains(point) {
            return CLDCropViewOverlayEdge.topLeft
        }
        
        var rectangleTopRight = rectangleTopLeft
        rectangleTopRight.origin.x = rectangle.maxX - 64.0
        if  rectangleTopRight.contains(point) {
            return CLDCropViewOverlayEdge.topRight
        }
        
        var rectangleBottomLeft = rectangleTopLeft
        rectangleBottomLeft.origin.y = rectangle.maxY - 64.0
        if  rectangleBottomLeft.contains(point) {
            return CLDCropViewOverlayEdge.bottomLeft
        }
        
        var rectangleBottomRight = rectangleTopRight
        rectangleBottomRight.origin.y = rectangleBottomLeft.origin.y
        if  rectangleBottomRight.contains(point) {
            return CLDCropViewOverlayEdge.bottomRight
        }
        
        // Check for edges
        let topRect = CGRect(origin: rectangle.origin, size: CGSize(width: rectangle.width, height: 64.0))
        if  topRect.contains(point) {
            return CLDCropViewOverlayEdge.top
        }
        
        var bottomRect = topRect
        bottomRect.origin.y = rectangle.maxY - 64.0
        if  bottomRect.contains(point) {
            return CLDCropViewOverlayEdge.bottom
        }
        
        let leftRect = CGRect(origin: rectangle.origin, size: CGSize(width: 64.0, height: rectangle.height))
        if  leftRect.contains(point) {
            return CLDCropViewOverlayEdge.left
        }
        
        var rightRect = leftRect
        rightRect.origin.x = rectangle.maxX - 64.0
        if  rightRect.contains(point) {
            return CLDCropViewOverlayEdge.right
        }
        
        return CLDCropViewOverlayEdge.none
    }
    
    // MARK: - =========================================================================================================
    
    /**
     Changes the aspect ratio of the crop box to match the one specified
     
     - parameter aspectRatio The aspect ratio (For example 16:9 is 16.0f/9.0f). 'CGSizeZero' will reset it to the image's own ratio
     - parameter animated Whether the locking effect is animated
     */
    public func setAspectRatio(_ newValue: CGSize, animated: Bool) {
        
        _aspectRatio = newValue
        var newAspectRatio = newValue
        
        // Will be executed automatically when added to a super view
        if !initialSetupPerformed { return }
        
        // Passing in an empty size will revert back to the image aspect ratio
        if (newAspectRatio.width < CGFloat(Float.ulpOfOne) && newAspectRatio.height < CGFloat(Float.ulpOfOne) ) {
            newAspectRatio = CGSize(width: imageSize.width, height: imageSize.height)
        }
        
        let  boundsFrame = contentBounds
        var cropBoxFrame = self.cropBoxFrame
        var offset = scrollView.contentOffset
        
        var cropBoxIsPortrait = false
        if (Int(newAspectRatio.width) == 1 && Int(newAspectRatio.height) == 1) {
            cropBoxIsPortrait = image.size.width > image.size.height
        } else {
            cropBoxIsPortrait = newAspectRatio.width < newAspectRatio.height
        }
        
        var zoomOut = false
        switch cropBoxIsPortrait {
        case true :
            
            let newWidth = floor(cropBoxFrame.height * (newAspectRatio.width / newAspectRatio.height) )
            var delta = cropBoxFrame.width  - newWidth
            cropBoxFrame.size.width  = newWidth
            offset.x += (delta * 0.5)
            
            // Set to 0 to avoid accidental clamping by the crop frame sanitizer
            if (delta < CGFloat(Float.ulpOfOne) ) {
                cropBoxFrame.origin.x = contentBounds.origin.x
            }
            
            // If the aspect ratio causes the new width to extend
            // beyond the content width, we'll need to zoom the image out
            let boundsWidth = boundsFrame.width
            if (newWidth > boundsWidth) {
                let scale = boundsWidth / newWidth
                
                // Scale the new height
                let newHeight = cropBoxFrame.height * scale
                delta = cropBoxFrame.height - newHeight
                cropBoxFrame.size.height = newHeight
                
                // Offset the Y position so it stays in the middle
                offset.y += (delta * 0.5)
                
                // Clamp the width to the bounds width
                cropBoxFrame.size.width = boundsWidth
                zoomOut = true
            }
            
        case false:
            let newHeight = floor(cropBoxFrame.width * (newAspectRatio.height/newAspectRatio.width) )
            var delta = cropBoxFrame.height - newHeight
            cropBoxFrame.size.height = newHeight
            offset.y += (delta * 0.5)
            
            if delta < CGFloat(Float.ulpOfOne) {
                cropBoxFrame.origin.y = contentBounds.origin.y
            }
            
            // If the aspect ratio causes the new height to extend
            // beyond the content width, we'll need to zoom the image out
            let boundsHeight = boundsFrame.height
            if (newHeight > boundsHeight) {
                let scale = boundsHeight / newHeight
                
                // Scale the new width
                let newWidth = cropBoxFrame.width * scale
                delta = cropBoxFrame.size.width - newWidth
                cropBoxFrame.size.width = newWidth
                
                // Offset the Y position so it stays in the middle
                offset.x += (delta * 0.5)
                
                // Clamp the width to the bounds height
                cropBoxFrame.size.height = boundsHeight
                zoomOut = true
            }
        }
        
        cropBoxLastEditedSize  = cropBoxFrame.size
        cropBoxLastEditedAngle = angle
        
        let translateBlock : () -> Void = { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.scrollView.contentOffset = offset
            strongSelf.cropBoxFrame = cropBoxFrame
            
            if (zoomOut) {
                strongSelf.scrollView.zoomScale = strongSelf.scrollView.minimumZoomScale
            }
            strongSelf.moveCroppedContentToCenterAnimated(false)
            strongSelf.checkForCanReset()
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
    
    func lockAspectRatio(to aspectRatio: CGSize) {
       
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
        
        // Only allow one rotation animation at a time
        if rotateAnimationInProgress { return }
        
        // Cancel any pending resizing timers
        if resetTimer != nil {
            
            cancelResetTimer()
            setEditing(false, resetCropBox: true, animated: false)
            
            cropBoxLastEditedAngle = angle
            captureStateForImageRotation()
        }
        
        // Work out the new angle, and wrap around once we exceed 360s
        var newAngle = angle
        newAngle = clockwise ? newAngle + 90 : newAngle - 90
        
        if (newAngle <= -360 || newAngle >= 360) {
            newAngle = 0
        }
        
        _angle = newAngle
        
        // Convert the new angle to radians
        var angleInRadians = CGFloat(0.0)
        switch (newAngle) {
        case   90: angleInRadians =  CGFloat(Double.pi / 2)
        case  -90: angleInRadians = -CGFloat(Double.pi / 2)
        case  180: angleInRadians =  CGFloat(Double.pi)
        case -180: angleInRadians = -CGFloat(Double.pi)
        case  270: angleInRadians =  CGFloat(Double.pi + (Double.pi / 2))
        case -270: angleInRadians = -CGFloat(Double.pi + (Double.pi / 2))
        default: break
        }
        
        // Set up the transformation matrix for the rotation
        let rotation = CGAffineTransform.identity.rotated(by: angleInRadians)
        
        // Work out how much we'll need to scale everything to fit to the new rotation
        let contentBounds = self.contentBounds
        let cropBoxFrame  = self.cropBoxFrame
        let scale = min(contentBounds.width / cropBoxFrame.height, contentBounds.height / cropBoxFrame.width)
        
        // Work out which section of the image we're currently focusing at
        let    cropMidPoint = CGPoint(x: cropBoxFrame.midX,
                                      y: cropBoxFrame.midY)
        var cropTargetPoint = CGPoint(x: cropMidPoint.x + scrollView.contentOffset.x,
                                      y: cropMidPoint.y + scrollView.contentOffset.y)
        
        // Work out the dimensions of the crop box when rotated
        var newCropFrame = CGRect.zero
        
        if (labs(angle) *  1) == ((labs(cropBoxLastEditedAngle)      )      ) ||
           (labs(angle) * -1) == ((labs(cropBoxLastEditedAngle) - 180) % 360)
        {
            newCropFrame.size = cropBoxLastEditedSize
            scrollView.minimumZoomScale = cropBoxLastEditedMinZoomScale
            scrollView.zoomScale = cropBoxLastEditedZoomScale
        }
        else
        {
            newCropFrame.size = CGSize(width : floor(cropBoxFrame.height * scale),
                                       height: floor(cropBoxFrame.width  * scale))
            
            // Re-adjust the scrolling dimensions of the scroll view to match the new size
            scrollView.minimumZoomScale *= scale
            scrollView.zoomScale *= scale
        }
        
        newCropFrame.origin.x = floor(contentBounds.midX - (newCropFrame.width  * 0.5))
        newCropFrame.origin.y = floor(contentBounds.midY - (newCropFrame.height * 0.5))
        
        // If we're animated, generate a snapshot view that we'll animate in place of the real view
        var snapshotView: UIView? = nil
        if (animated) {
            snapshotView = foregroundContainerView.snapshotView(afterScreenUpdates: false)
            rotateAnimationInProgress = true
        }
        
        // Rotate the background image view, inside its container view
        backgroundImageView.transform = rotation
        
        // Flip the width/height of the container view so it matches the rotated image view's size
        let containerSize = backgroundContainerView.frame.size
        backgroundContainerView.frame   = CGRect(origin: .zero, size: CGSize(width: containerSize.height, height: containerSize.width))
        backgroundImageView.frame       = CGRect(origin: .zero, size: backgroundImageView.frame.size)
        
        
        // Rotate the foreground image view to match
        foregroundContainerView.transform = CGAffineTransform.identity
        foregroundImageView.transform = rotation
        
        // Flip the content size of the scroll view to match the rotated bounds
        scrollView.contentSize = backgroundContainerView.frame.size
        
        // Assign the new crop box frame and re-adjust the content to fill it
        self.cropBoxFrame = newCropFrame
        moveCroppedContentToCenterAnimated(false)
        newCropFrame = self.cropBoxFrame
        
        // Work out how to line up out point of interest into the middle of the crop box
        cropTargetPoint.x *= scale
        cropTargetPoint.y *= scale
        
        // Swap the target dimensions to match a 90 degree rotation (clockwise or counterclockwise)
        let swapValue = cropTargetPoint.x
        
        if (clockwise) {
            cropTargetPoint.x = scrollView.contentSize.width  - cropTargetPoint.y
            cropTargetPoint.y = swapValue
        } else {
            cropTargetPoint.x = cropTargetPoint.y
            cropTargetPoint.y = scrollView.contentSize.height - swapValue
        }
        
        // Reapply the translated scroll offset to the scroll view
        let midPoint = CGPoint(x: newCropFrame.midX, y: newCropFrame.midY)
        
        var offset = CGPoint.zero
        offset.x = floor(-midPoint.x + cropTargetPoint.x)
        offset.y = floor(-midPoint.y + cropTargetPoint.y)
        
        offset.x = max(-scrollView.contentInset.left, offset.x)
        offset.y = max(-scrollView.contentInset.top , offset.y)
        
        offset.x = min(scrollView.contentSize.width  - (newCropFrame.width  - scrollView.contentInset.right ), offset.x)
        offset.y = min(scrollView.contentSize.height - (newCropFrame.height - scrollView.contentInset.bottom), offset.y)
        
        // If the scroll view's new scale is 1 and the new offset is equal to the old, will not trigger the delegate 'scrollViewDidScroll:'
        // so we should call the method manually to update the foregroundImageView's frame
        if (offset.x == scrollView.contentOffset.x && offset.y == scrollView.contentOffset.y && scale == 1) {
            
            matchForegroundToBackground()
        }
        
        scrollView.contentOffset = offset
        
        // If we're animated, play an animation of the snapshot view rotating,
        // then fade it out over the live content
        if (animated) {
            
            if let snapshotView = snapshotView {
                snapshotView.center = CGPoint(x: contentBounds.midX, y: contentBounds.midY)
                addSubview(snapshotView)
            }
            
            backgroundContainerView.isHidden = true
            foregroundContainerView.isHidden = true
            translucencyView.isHidden = true
            gridOverlayView.isHidden  = true
            
            UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: [.beginFromCurrentState], animations: {
                
                let target = CGAffineTransform.identity
                    .rotated(by: clockwise ? CGFloat(Double.pi / 2) : -CGFloat(Double.pi / 2))
                    .scaledBy(x: scale, y: scale)
                                
                if let snapshotView = snapshotView {
                    snapshotView.transform = target
                }
                
            }, completion: { (complete) in
                
                self.backgroundContainerView.isHidden = false
                self.foregroundContainerView.isHidden = false
                self.translucencyView.isHidden = self.translucencyAlwaysHidden
                self.gridOverlayView.isHidden  = false
                
                self.backgroundContainerView.alpha = 0.0
                self.gridOverlayView.alpha  = 0.0
                self.translucencyView.alpha = 1.0
                
                UIView.animate(withDuration: 0.45, animations: {
                    
                    snapshotView?.alpha = 0.0
                    self.backgroundContainerView.alpha = 1.0
                    self.gridOverlayView.alpha = 1.0
                    
                }, completion: { (complete) in
                    
                    self.rotateAnimationInProgress = false
                    
                    snapshotView?.removeFromSuperview()
                    
                    // If the aspect ratio lock is not enabled, allow a swap
                    // If the aspect ratio lock is on, allow a aspect ratio swap
                    // only if the allowDimensionSwap option is specified.
                    let aspectRatioCanSwapDimensions =
                        (!self.aspectRatioLockEnabled) || (self.aspectRatioLockEnabled && self.aspectRatioLockDimensionSwapEnabled)
                    
                    if (!aspectRatioCanSwapDimensions) {
                        //This will animate the aspect ratio back to the desired locked ratio after the image is rotated.
                        self.setAspectRatio(self.aspectRatio, animated: animated)
                    }
                })
            })
        }
        
        checkForCanReset()
    }
    
    /**
     Animate the grid overlay graphic to be visible
     */
    public func setGridOverlayHidden(_ hidden: Bool, animated: Bool) {
        
        _gridOverlayHidden = hidden
        
        gridOverlayView.alpha = hidden ? 1.0 : 0.0
        
        UIView.animate(withDuration: 0.4) {
            self.gridOverlayView.alpha = hidden ? 0.0 : 1.0
        }
    }
    
    /**
     Animate the cropping component views to become visible
     */
    public func setCroppingViewsHidden(_ hidden: Bool, animated: Bool) {
        
        if _croppingViewsHidden == hidden { return }
        
        _croppingViewsHidden = hidden
        
        let alpha = hidden ? CGFloat(0.0) : CGFloat(1.0)
        
        switch animated {
        case true:
            backgroundImageView.alpha     = alpha
            foregroundContainerView.alpha = alpha
            
            UIView.animate(withDuration: 0.4) {
                self.gridOverlayView.alpha = alpha
                self.toggleTranslucencyViewVisible(!hidden)
            }
            
        case false:
            backgroundImageView.alpha     = alpha
            foregroundContainerView.alpha = alpha
            
            gridOverlayView.alpha = alpha
            toggleTranslucencyViewVisible(hidden)
        }
    }
    
    /**
     Animate the background image view to become visible
     */
    public func setBackgroundImageViewHidden(_ hidden: Bool, animated: Bool) {
        
        switch animated {
        case false:
            backgroundImageView.isHidden = hidden
            
        case true:
            
            let beforeAlpha = hidden ? CGFloat(1.0) : CGFloat(0.0)
            let     toAlpha = hidden ? CGFloat(0.0) : CGFloat(1.0)
            
            backgroundImageView.isHidden = false
            backgroundImageView.alpha = beforeAlpha
            
            UIView .animate(withDuration: 0.5, animations: {
                
                self.backgroundImageView.alpha = toAlpha
                
            }, completion: { (complete) in
                
                if (hidden) {
                    self.backgroundImageView.isHidden = true
                }
            })
        }
    }
    
    /**
     When triggered, the crop view will perform a relayout to ensure the crop box
     fills the entire crop view region
     */
    public func moveCroppedContentToCenterAnimated(_ animated: Bool) {
        
        if internalLayoutDisabled { return }
        
        let contentRect  = contentBounds
        var    cropFrame = cropBoxFrame
        
        // Ensure we only proceed after the crop frame has been setup for the first time
        if (cropFrame.width < CGFloat(Float.ulpOfOne) || cropFrame.height < CGFloat(Float.ulpOfOne)) {
            return
        }
        
        // The scale we need to scale up the crop box to fit full screen
        let scale = min(contentRect.width / cropFrame.width, contentRect.height / cropFrame.height)
        
        let focusPoint = CGPoint(x:   cropFrame.midX, y:   cropFrame.midY)
        let   midPoint = CGPoint(x: contentRect.midX, y: contentRect.midY)
        
        cropFrame.size.width  = ceil(cropFrame.width  * scale)
        cropFrame.size.height = ceil(cropFrame.height * scale)
        
        cropFrame.origin.x = contentRect.origin.x + ceil(0.5 * (contentRect.width  - cropFrame.width ))
        cropFrame.origin.y = contentRect.origin.y + ceil(0.5 * (contentRect.height - cropFrame.height))
        
        // Work out the point on the scroll content that the focusPoint is aiming at
        var contentTargetPoint = CGPoint.zero
        contentTargetPoint.x = ((focusPoint.x + scrollView.contentOffset.x) * scale)
        contentTargetPoint.y = ((focusPoint.y + scrollView.contentOffset.y) * scale)
        
        // Work out where the crop box is focusing, so we can re-align to center that point
        var offset = CGPoint.zero
        offset.x = -midPoint.x + contentTargetPoint.x
        offset.y = -midPoint.y + contentTargetPoint.y
        
        // Clamp the content so it doesn't create any seams around the grid
        offset.x = max(-cropFrame.origin.x, offset.x)
        offset.y = max(-cropFrame.origin.y, offset.y)
        
        let translateBlock : () -> Void = { [weak self] in
            
            guard let strongSelf = self else { return }
            var offsetHelper = offset
            
            // Setting these scroll view properties will trigger
            // the foreground matching method via their delegates,
            // multiple times inside the same animation block, resulting
            // in glitchy animations.
            //
            // Disable matching for now, and explicitly update at the end.
            
            strongSelf.disableForgroundMatching = true
            
            // Slight hack. This method needs to be called during `[UIViewController viewDidLayoutSubviews]`
            // in order for the crop view to resize itself during iPad split screen events.
            // On the first run, even though scale is exactly 1.0f, performing this multiplication introduces
            // a floating point noise that zooms the image in by about 5 pixels. This fixes that issue.
            if scale < 1.0 - CGFloat(Float.ulpOfOne) || scale > 1.0 + CGFloat(Float.ulpOfOne) {
                
                strongSelf.scrollView.zoomScale *= scale
                strongSelf.scrollView.zoomScale = min(strongSelf.scrollView.maximumZoomScale, strongSelf.scrollView.zoomScale)
            }
            
            // If it turns out the zoom operation would have exceeded the minizum zoom scale, don't apply
            // the content offset
            if (strongSelf.scrollView.zoomScale < strongSelf.scrollView.maximumZoomScale - CGFloat(Float.ulpOfOne)) {
                
                offsetHelper.x = min(-cropFrame.maxX + strongSelf.scrollView.contentSize.width , offset.x)
                offsetHelper.y = min(-cropFrame.maxY + strongSelf.scrollView.contentSize.height, offset.y)
                strongSelf.scrollView.contentOffset = offsetHelper
            }
            
            strongSelf.cropBoxFrame = cropFrame
            
            strongSelf.disableForgroundMatching = false
            
            // Explicitly update the matching at the end of the calculations
            strongSelf.matchForegroundToBackground()
        }
        
        switch animated {
        case false:
            translateBlock()
            
        case true:
            matchForegroundToBackground()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                               options: [.beginFromCurrentState], animations: translateBlock, completion: nil)
            }
        }
    }
    
    // MARK: -- Editing Mode
    private func captureStateForImageRotation() {
        
        cropBoxLastEditedSize         = cropBoxFrame.size
        cropBoxLastEditedZoomScale    = scrollView.zoomScale
        cropBoxLastEditedMinZoomScale = scrollView.minimumZoomScale
    }
    
    // MARK: -- Resettable State
    private func checkForCanReset() {
        
        var resettable = false
        
        if angle != 0 { // Image has been rotated
            resettable = true
        }
        else if scrollView.zoomScale > scrollView.minimumZoomScale + CGFloat(Float.ulpOfOne) { // Image has been zoomed in
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
}
extension CLDCropView : UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return backgroundContainerView
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        matchForegroundToBackground()
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        startEditing()
        isResettable = true
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
        startEditing()
        isResettable = true
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        startResetTimer()
        checkForCanReset()
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        startResetTimer()
        checkForCanReset()
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if scrollView.isTracking {
            cropBoxLastEditedZoomScale    = scrollView.zoomScale
            cropBoxLastEditedMinZoomScale = scrollView.minimumZoomScale
        }
        matchForegroundToBackground()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            startResetTimer()
        }
    }
}
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
