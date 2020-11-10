//
//  CLDCropViewUIManager.swift
//  Cloudinary
//
//  Created by Oz Deutsch on 04/10/2020.
//

import UIKit

internal class CLDCropViewUIManager {
    
    internal weak var cropView: CLDCropView!
    
    internal init(cropView: CLDCropView) {
        
        self.cropView = cropView
    }
    
    /**
    layout the initial image and returns the scaled image size
    */
    internal func manualLayout_initialImageAndGetScaledImageSize() -> CGSize {
        
        cropView.scrollView.contentSize = cropView.imageSize
        
        let boundsRectangle = cropView.contentBounds
        let boundsSize      = boundsRectangle.size
        
        // Work out the minimum scale of the object
        var scale = CGFloat(0.0)
        
        // Work out the size of the image to fit into the content bounds
        scale = min(boundsRectangle.width / cropView.imageSize.width, boundsRectangle.height / cropView.imageSize.height)
        
        let scaledImageSize = CGSize(width : floor(cropView.imageSize.width  * scale),
                                     height: floor(cropView.imageSize.height * scale))
        
        // If an aspect ratio was pre-applied to the crop view, use that to work out the minimum scale the image needs to be to fit
        var cropBoxSize = CGSize.zero
        
        if (cropView.hasAspectRatio) {
            
            let    ratioScale = cropView.aspectRatio.width / cropView.aspectRatio.height // Work out the size of the width in relation to height
            let fullSizeRatio = CGSize(width: boundsSize.height * ratioScale, height: boundsSize.height)
            
            let fitScale = min(boundsSize.width / fullSizeRatio.width, boundsSize.height / fullSizeRatio.height)
            
            cropBoxSize  = CGSize(width: fullSizeRatio.width * fitScale, height: fullSizeRatio.height * fitScale)
            scale        = max(cropBoxSize.width / cropView.imageSize.width, cropBoxSize.height / cropView.imageSize.height)
        }
        
        //Whether aspect ratio, or original, the final image size we'll base the rest of the calculations off
        let scaledSize = CGSize(width: floor(cropView.imageSize.width * scale), height: floor(cropView.imageSize.height * scale))
        
        // Configure the scroll view
        cropView.scrollView.minimumZoomScale = scale
        cropView.scrollView.maximumZoomScale = scale * cropView.maximumZoomScale
        
        // Set the crop box to the size we calculated and align in the middle of the screen
        var rectangle  = CGRect.zero
        rectangle.size = cropView.hasAspectRatio ? cropBoxSize : scaledSize
        rectangle.origin.x = boundsRectangle.origin.x + floor((boundsRectangle.width  - rectangle.width ) * 0.5)
        rectangle.origin.y = boundsRectangle.origin.y + floor((boundsRectangle.height - rectangle.height) * 0.5)
        cropView.cropBoxFrame = rectangle
        
        // Set the fully zoomed out state initially
        cropView.scrollView.zoomScale   = cropView.scrollView.minimumZoomScale
        cropView.scrollView.contentSize = scaledSize
        
        // If we ended up with a smaller crop box than the content, line up the content so its center
        // is in the center of the cropbox
        if (rectangle.width < scaledSize.width - CGFloat.ulpOfOne || rectangle.height < scaledSize.height - CGFloat.ulpOfOne) {
            
            var offset = CGPoint.zero
            offset.x = -floor(boundsRectangle.midX - (scaledSize.width  * 0.5))
            offset.y = -floor(boundsRectangle.midY - (scaledSize.height * 0.5))
            cropView.scrollView.contentOffset = offset
        }
        
        return scaledImageSize
    }
    
    internal func manualLayout_moveCroppedContentToCenterAnimated(_ animated: Bool) {
        
        if cropView.internalLayoutDisabled { return }
        
        let contentRect  = cropView.contentBounds
        var    cropFrame = cropView.cropBoxFrame
        
        // Ensure we only proceed after the crop frame has been setup for the first time
        if (cropFrame.width < CGFloat.ulpOfOne || cropFrame.height < CGFloat.ulpOfOne) {
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
        contentTargetPoint.x = ((focusPoint.x + cropView.scrollView.contentOffset.x) * scale)
        contentTargetPoint.y = ((focusPoint.y + cropView.scrollView.contentOffset.y) * scale)
        
        // Work out where the crop box is focusing, so we can re-align to center that point
        var offset = CGPoint.zero
        offset.x = -midPoint.x + contentTargetPoint.x
        offset.y = -midPoint.y + contentTargetPoint.y
        
        // Clamp the content so it doesn't create any seams around the grid
        offset.x = max(-cropFrame.origin.x, offset.x)
        offset.y = max(-cropFrame.origin.y, offset.y)
        
        let translateBlock : () -> Void = {
            
            var offsetHelper = offset
            
            // Setting these scroll view properties will trigger
            // the foreground matching method via their delegates,
            // multiple times inside the same animation block, resulting
            // in glitchy animations.
            //
            // Disable matching for now, and explicitly update at the end.
            
            self.cropView.disableForgroundMatching = true
            
            // Slight hack. This method needs to be called during `[UIViewController viewDidLayoutSubviews]`
            // in order for the crop view to resize itself during iPad split screen events.
            // On the first run, even though scale is exactly 1.0f, performing this multiplication introduces
            // a floating point noise that zooms the image in by about 5 pixels. This fixes that issue.
            if scale < 1.0 - CGFloat.ulpOfOne || scale > 1.0 + CGFloat.ulpOfOne {
                
                self.cropView.scrollView.zoomScale *= scale
                self.cropView.scrollView.zoomScale = min(self.cropView.scrollView.maximumZoomScale, self.cropView.scrollView.zoomScale)
            }
            
            // If it turns out the zoom operation would have exceeded the minizum zoom scale, don't apply
            // the content offset
            if (self.cropView.scrollView.zoomScale < self.cropView.scrollView.maximumZoomScale - CGFloat.ulpOfOne) {
                
                offsetHelper.x = min(-cropFrame.maxX + self.cropView.scrollView.contentSize.width , offset.x)
                offsetHelper.y = min(-cropFrame.maxY + self.cropView.scrollView.contentSize.height, offset.y)
                self.cropView.scrollView.contentOffset = offsetHelper
            }
            
            self.cropView.cropBoxFrame = cropFrame
            
            self.cropView.disableForgroundMatching = false
            
            // Explicitly update the matching at the end of the calculations
            self.cropView.matchForegroundToBackground()
        }
        
        switch animated {
        case false:
            translateBlock()
            
        case true:
            cropView.matchForegroundToBackground()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.beginFromCurrentState], animations: translateBlock, completion: nil)
            }
        }
    }
    
    internal func manualLayout_rotateImageNinetyDegreesAnimated(_ animated: Bool, clockwise: Bool) {
        
        // Only allow one rotation animation at a time
        if cropView.rotateAnimationInProgress { return }
        
        // Cancel any pending resizing timers
        if cropView.resetTimer != nil {
            
            cropView.cancelResetTimer()
            cropView.setEditing(false, resetCropBox: true, animated: false)
            
            cropView.cropBoxLastEditedAngle = cropView.angle
            cropView.captureStateForImageRotation()
        }
        
        // Work out the new angle, and wrap around once we exceed 360s
        var newAngle = cropView.angle
        newAngle = clockwise ? newAngle + 90 : newAngle - 90
        
        if (newAngle <= -360 || newAngle >= 360) {
            newAngle = 0
        }
        
        cropView._angle = newAngle
        
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
        let contentBounds = cropView.contentBounds
        let cropBoxFrame  = cropView.cropBoxFrame
        let scale = min(contentBounds.width / cropBoxFrame.height, contentBounds.height / cropBoxFrame.width)
        
        // Work out which section of the image we're currently focusing at
        let    cropMidPoint = CGPoint(x: cropBoxFrame.midX,
                                      y: cropBoxFrame.midY)
        var cropTargetPoint = CGPoint(x: cropMidPoint.x + cropView.scrollView.contentOffset.x,
                                      y: cropMidPoint.y + cropView.scrollView.contentOffset.y)
        
        // Work out the dimensions of the crop box when rotated
        var newCropFrame = CGRect.zero
        
        if (labs(cropView.angle) *  1) == ((labs(cropView.cropBoxLastEditedAngle)      )      ) ||
           (labs(cropView.angle) * -1) == ((labs(cropView.cropBoxLastEditedAngle) - 180) % 360)
        {
            newCropFrame.size = cropView.cropBoxLastEditedSize
            cropView.scrollView.minimumZoomScale = cropView.cropBoxLastEditedMinZoomScale
            cropView.scrollView.zoomScale = cropView.cropBoxLastEditedZoomScale
        }
        else
        {
            newCropFrame.size = CGSize(width : floor(cropBoxFrame.height * scale),
                                       height: floor(cropBoxFrame.width  * scale))
            
            // Re-adjust the scrolling dimensions of the scroll view to match the new size
            cropView.scrollView.minimumZoomScale *= scale
            cropView.scrollView.zoomScale *= scale
        }
        
        newCropFrame.origin.x = floor(contentBounds.midX - (newCropFrame.width  * 0.5))
        newCropFrame.origin.y = floor(contentBounds.midY - (newCropFrame.height * 0.5))
        
        // If we're animated, generate a snapshot view that we'll animate in place of the real view
        var snapshotView: UIView? = nil
        if (animated) {
            snapshotView = cropView.foregroundContainerView.snapshotView(afterScreenUpdates: false)
            cropView.rotateAnimationInProgress = true
        }
        
        // Rotate the background image view, inside its container view
        cropView.backgroundImageView.transform = rotation
        
        // Flip the width/height of the container view so it matches the rotated image view's size
        let containerSize = cropView.backgroundContainerView.frame.size
        cropView.backgroundContainerView.frame   = CGRect(origin: .zero, size: CGSize(width: containerSize.height, height: containerSize.width))
        cropView.backgroundImageView.frame       = CGRect(origin: .zero, size: cropView.backgroundImageView.frame.size)
        
        
        // Rotate the foreground image view to match
        cropView.foregroundContainerView.transform = CGAffineTransform.identity
        cropView.foregroundImageView.transform = rotation
        
        // Flip the content size of the scroll view to match the rotated bounds
        cropView.scrollView.contentSize = cropView.backgroundContainerView.frame.size
        
        // Assign the new crop box frame and re-adjust the content to fill it
        cropView.cropBoxFrame = newCropFrame
        cropView.moveCroppedContentToCenterAnimated(false)
        newCropFrame = cropView.cropBoxFrame
        
        // Work out how to line up out point of interest into the middle of the crop box
        cropTargetPoint.x *= scale
        cropTargetPoint.y *= scale
        
        // Swap the target dimensions to match a 90 degree rotation (clockwise or counterclockwise)
        let swapValue = cropTargetPoint.x
        
        if (clockwise) {
            cropTargetPoint.x = cropView.scrollView.contentSize.width  - cropTargetPoint.y
            cropTargetPoint.y = swapValue
        } else {
            cropTargetPoint.x = cropTargetPoint.y
            cropTargetPoint.y = cropView.scrollView.contentSize.height - swapValue
        }
        
        // Reapply the translated scroll offset to the scroll view
        let midPoint = CGPoint(x: newCropFrame.midX, y: newCropFrame.midY)
        
        var offset = CGPoint.zero
        offset.x = floor(-midPoint.x + cropTargetPoint.x)
        offset.y = floor(-midPoint.y + cropTargetPoint.y)
        
        offset.x = max(-cropView.scrollView.contentInset.left, offset.x)
        offset.y = max(-cropView.scrollView.contentInset.top , offset.y)
        
        offset.x = min(cropView.scrollView.contentSize.width  - (newCropFrame.width  - cropView.scrollView.contentInset.right ), offset.x)
        offset.y = min(cropView.scrollView.contentSize.height - (newCropFrame.height - cropView.scrollView.contentInset.bottom), offset.y)
        
        // If the scroll view's new scale is 1 and the new offset is equal to the old, will not trigger the delegate 'scrollViewDidScroll:'
        // so we should call the method manually to update the foregroundImageView's frame
        if (offset.x == cropView.scrollView.contentOffset.x && offset.y == cropView.scrollView.contentOffset.y && scale == 1) {
            
            cropView.matchForegroundToBackground()
        }
        
        cropView.scrollView.contentOffset = offset
        
        // If we're animated, play an animation of the snapshot view rotating,
        // then fade it out over the live content
        if (animated) {
            
            if let snapshotView = snapshotView {
                snapshotView.center = CGPoint(x: contentBounds.midX, y: contentBounds.midY)
                cropView.addSubview(snapshotView)
            }
            
            cropView.backgroundContainerView.isHidden = true
            cropView.foregroundContainerView.isHidden = true
            cropView.translucencyView.isHidden = true
            cropView.gridOverlayView.isHidden  = true
            
            UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: [.beginFromCurrentState], animations: {
                
                let target = CGAffineTransform.identity
                    .rotated(by: clockwise ? CGFloat(Double.pi / 2) : -CGFloat(Double.pi / 2))
                    .scaledBy(x: scale, y: scale)
                                
                if let snapshotView = snapshotView {
                    snapshotView.transform = target
                }
                
            }, completion: { (complete) in
                
                self.cropView.backgroundContainerView.isHidden = false
                self.cropView.foregroundContainerView.isHidden = false
                self.cropView.translucencyView.isHidden = self.cropView.translucencyAlwaysHidden
                self.cropView.gridOverlayView.isHidden  = false
                
                self.cropView.backgroundContainerView.alpha = 0.0
                self.cropView.gridOverlayView.alpha  = 0.0
                self.cropView.translucencyView.alpha = 1.0
                
                UIView.animate(withDuration: 0.45, animations: {
                    
                    snapshotView?.alpha = 0.0
                    self.cropView.backgroundContainerView.alpha = 1.0
                    self.cropView.gridOverlayView.alpha = 1.0
                    
                }, completion: { (complete) in
                    
                    self.cropView.rotateAnimationInProgress = false
                    
                    snapshotView?.removeFromSuperview()
                    
                    // If the aspect ratio lock is not enabled, allow a swap
                    // If the aspect ratio lock is on, allow a aspect ratio swap
                    // only if the allowDimensionSwap option is specified.
                    let aspectRatioCanSwapDimensions =
                        (!self.cropView.aspectRatioLockEnabled) || (self.cropView.aspectRatioLockEnabled && self.cropView.aspectRatioLockDimensionSwapEnabled)
                    
                    if (!aspectRatioCanSwapDimensions) {
                        //This will animate the aspect ratio back to the desired locked ratio after the image is rotated.
                        self.cropView.setAspectRatio(self.cropView.aspectRatio, animated: animated)
                    }
                })
            })
        }
        
        cropView.checkForCanReset()
    }
}
