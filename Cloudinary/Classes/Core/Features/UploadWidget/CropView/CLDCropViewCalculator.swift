//
//  CLDCropViewCalculator.swift
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
import Foundation
import CoreGraphics

fileprivate extension CGSize {
    
    var floored : CGSize {
        
        return CGSize(width : floor(width ),
                      height: floor(height))
    }
}
internal extension CLDCropView.Calculator {
    
    static func bounds(for viewBounds: CGRect, padding: CGFloat, cropRegion insets: UIEdgeInsets) -> CGRect {
        
        var rectangle = CGRect.zero
        rectangle.origin.x = padding + insets.left
        rectangle.origin.y = padding + insets.top
        rectangle.size.width  = viewBounds.width  - ((padding * 2) + insets.left + insets.right)
        rectangle.size.height = viewBounds.height - ((padding * 2) + insets.top  + insets.bottom)
        return rectangle
    }
    static func overlayEdge(for point: CGPoint, cropBoxFrame: CGRect) -> CLDCropViewOverlayEdge {
        
        let     threashold = CGFloat(64)
        let halfThreashold = threashold / 2.0
        
        var rectangle = cropBoxFrame
        
        // Account for padding around the box
        rectangle = rectangle.insetBy(dx: -halfThreashold, dy: -halfThreashold)
        
        // Make sure the corners take priority
        let rectangleTopLeft = CGRect(origin: rectangle.origin, size: CGSize(width: threashold, height: threashold))
        if  rectangleTopLeft.contains(point) {
            return CLDCropViewOverlayEdge.topLeft
        }
        
        var rectangleTopRight = rectangleTopLeft
        rectangleTopRight.origin.x = rectangle.maxX - threashold
        if  rectangleTopRight.contains(point) {
            return CLDCropViewOverlayEdge.topRight
        }
        
        var rectangleBottomLeft = rectangleTopLeft
        rectangleBottomLeft.origin.y = rectangle.maxY - threashold
        if  rectangleBottomLeft.contains(point) {
            return CLDCropViewOverlayEdge.bottomLeft
        }
        
        var rectangleBottomRight = rectangleTopRight
        rectangleBottomRight.origin.y = rectangleBottomLeft.origin.y
        if  rectangleBottomRight.contains(point) {
            return CLDCropViewOverlayEdge.bottomRight
        }
        
        // Check for edges
        let topRect = CGRect(origin: rectangle.origin, size: CGSize(width: rectangle.width, height: threashold))
        if  topRect.contains(point) {
            return CLDCropViewOverlayEdge.top
        }
        
        var bottomRect = topRect
        bottomRect.origin.y = rectangle.maxY - threashold
        if  bottomRect.contains(point) {
            return CLDCropViewOverlayEdge.bottom
        }
        
        let leftRect = CGRect(origin: rectangle.origin, size: CGSize(width: threashold, height: rectangle.height))
        if  leftRect.contains(point) {
            return CLDCropViewOverlayEdge.left
        }
        
        var rightRect = leftRect
        rightRect.origin.x = rectangle.maxX - threashold
        if  rightRect.contains(point) {
            return CLDCropViewOverlayEdge.right
        }
        
        return CLDCropViewOverlayEdge.none
    }
}
internal extension CLDCropView.Calculator.ImageCrop   {
    /**
     In relation to the coordinate space of the image, the frame that the crop view is focusing on
     */
    static func computeFrame(given imageSize: CGSize, scrollView: UIScrollView, cropBox: CGRect) -> CGRect {
        
        let  targetSize = imageSize
        let contentSize = scrollView.contentSize
        
        let cropRectangle = cropBox
        
        let offset = scrollView.contentOffset
        let insets = scrollView.contentInset
        
        let scale = min(targetSize.width / contentSize.width, targetSize.height / contentSize.height)
        
        var rectangle = CGRect.zero
        
        // Calculate the normalized origin
        rectangle.origin.x = floor( (floor(offset.x) + insets.left) * (targetSize.width  / contentSize.width ) )
        rectangle.origin.x = max(0, rectangle.origin.x)
        
        rectangle.origin.y = floor( (floor(offset.y) + insets.top ) * (targetSize.height / contentSize.height) )
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
    
    static func computeAdjutsments(for cropView: CLDCropView, scrollView: UIScrollView, content contentBounds: CGRect, newValue: CGRect) -> (cropFrame:CGRect, minimumZoomScale: CGFloat, adjustedZoomScale: CGFloat) {
        
        // Convert the image crop frame's size from image space to the screen space
        let minimumScale    = scrollView.minimumZoomScale
        let scaledCropSize = CGSize(width : newValue.width  * minimumScale,
                                    height: newValue.height * minimumScale)
        
        // Work out the scale necessary to upscale the crop size to fit the content bounds of the crop bound
        let boundsRectangle  = contentBounds
        
        let scale = min(boundsRectangle.width  / scaledCropSize.width,
                        boundsRectangle.height / scaledCropSize.height)
        
        // Work out the size and offset of the upscaled crop box
        var frameRectangle = CGRect.zero
        frameRectangle.size = CGSize(width : scaledCropSize.width  * scale,
                                     height: scaledCropSize.height * scale)
        
        //set the crop box
        var cropBoxRectangle = CGRect.zero
        cropBoxRectangle.size = frameRectangle.size
        cropBoxRectangle.origin.x = boundsRectangle.midX - (frameRectangle.width  * 0.5)
        cropBoxRectangle.origin.y = boundsRectangle.midY - (frameRectangle.height * 0.5)
        
        return (cropFrame: cropBoxRectangle, minimumZoomScale: minimumScale, adjustedZoomScale: scale)
    }
}
internal extension CLDCropView.Calculator.CropBox     {
    
    /**
     Clamp the cropping region to the inset boundaries of the screen
     */
    static func clampFrame(given rectangle: CGRect, cropBox: CGRect, minimumBoxSize: CGFloat) -> CGRect {
        
        func clampValueToRange(input value: CGFloat, maximumValue: CGFloat, minimumValue: CGFloat) -> CGFloat {
        
            var temp = value
            temp = floor( min(temp, maximumValue) )
            temp = ceil ( max(temp, minimumValue) )
            return temp
        }
        func clampedValues(contentOrigin: CGFloat, clampedOrigin: CGFloat, side: CGFloat) -> (origin:CGFloat, side: CGFloat) {
            
            var internalVariable      = side
            let internalClampedOrigin = floor( max(clampedOrigin, ceil(contentOrigin)) )
            
            // If we clamp the value, ensure we compensate for the subsequent delta
            // generated in the width (Or else, the box will keep growing)
            let delta  = clampedOrigin - ceil(contentOrigin)
            if (delta < -CGFloat.ulpOfOne) {
                internalVariable += delta
            }
            return (internalClampedOrigin,internalVariable)
        }
        
        let xValues = clampedValues(contentOrigin: rectangle.origin.x, clampedOrigin: cropBox.origin.x, side: cropBox.width)
        let yValues = clampedValues(contentOrigin: rectangle.origin.y, clampedOrigin: cropBox.origin.y, side: cropBox.height)
        
        // Given the clamped X values, make sure we can't extend the crop box beyond the edge of the screen in the current state
        // Make sure we can't make the crop box too small
        let maxWidth  = (rectangle.origin.x + rectangle.width) - xValues.origin
        let clampedWidth = clampValueToRange(input: xValues.side, maximumValue: maxWidth, minimumValue: minimumBoxSize)
        
        // Given the clamped Y values, make sure we can't extend the crop box beyond the edge of the screen in the current state
        // Make sure we can't make the crop box too small
        let maxHeight = (rectangle.origin.y + rectangle.height) - yValues.origin
        let clampedHeight = clampValueToRange(input: yValues.side, maximumValue: maxHeight, minimumValue: minimumBoxSize)
        
        return CGRect(x: xValues.origin, y: yValues.origin, width: clampedWidth, height: clampedHeight)
    }
    
    static func updateScrollView(_ scrollView: UIScrollView, given imageSize : CGSize, boundingRect: CGRect, newCropBox cropBox: CGRect) {
        
        // if necessary, work out the new minimum size of the scroll view so it fills the crop box
        let scale = max(cropBox.height / imageSize.height,
                        cropBox.width  / imageSize.width)
        
        // Reset the scroll view insets to match the region of the new crop rect
        scrollView.contentInset = UIEdgeInsets(top : cropBox.minY,
                                               left: cropBox.minX,
                                               bottom: boundingRect.maxY - cropBox.maxY,
                                               right : boundingRect.maxX - cropBox.maxX)
        
        scrollView.minimumZoomScale = scale
        
        // Make sure content isn't smaller than the crop box
        scrollView.contentSize = scrollView.contentSize.floored
        
        // IMPORTANT: Force the scroll view to update its content after changing the zoom scale
        let zoomScale = scrollView.zoomScale
        scrollView.zoomScale = zoomScale
    }
    
    /**
     Calculates the new crop box frame by the users gesture
     */
    static func calculateFrame(given gesturePoint: CGPoint, in cropView: CLDCropView) -> CGRect {
        
        var    rectangle = cropView.cropBoxFrame
        let  originFrame = cropView.cropOriginFrame
        let contentFrame = cropView.contentBounds
        
        var point = gesturePoint
        point.x = max(contentFrame.origin.x - cropView.cropViewPadding, point.x)
        point.y = max(contentFrame.origin.y - cropView.cropViewPadding, point.y)
        
        // The delta between where we first tapped, and where our finger is now
        var xDelta = ceil(point.x - cropView.panOriginPoint.x)
        var yDelta = ceil(point.y - cropView.panOriginPoint.y)
        
        // Current aspect ratio of the crop box in case we need to clamp it
        let aspectRatio = (originFrame.width / originFrame.height)
        
        // Note whether we're being aspect transformed horizontally or vertically
        var aspectHorizontal = false
        var aspectVertical   = false
        
        // Depending on which corner we drag from, set the appropriate min flag to
        // ensure we can properly clamp the XY value of the box if it overruns the minimum size
        // (Otherwise the image itself will slide with the drag gesture)
        var clampMinFromTop  = false
        var clampMinFromLeft = false
        
        switch cropView.tappedEdge {
        case .left:
            
            if cropView.aspectRatioLockEnabled {
                aspectHorizontal = true
                xDelta = max(xDelta, 0)
                
                let scaleOrigin = CGPoint(x: originFrame.maxX, y: originFrame.midY)
                rectangle.size.height = rectangle.width / aspectRatio
                rectangle.origin.y    = scaleOrigin.y - (rectangle.height * 0.5)
            }
            
            let newWidth  = originFrame.width - xDelta
            let newHeight = originFrame.height
            
            if min(newHeight, newWidth) / max(newHeight, newWidth) >= cropView.minimumAspectRatio {
                rectangle.origin.x   = originFrame.origin.x + xDelta
                rectangle.size.width = originFrame.width - xDelta
            }
            clampMinFromLeft = true
            
        case .right:
            
            if cropView.aspectRatioLockEnabled {
                aspectHorizontal = true
                
                let scaleOrigin = CGPoint(x: originFrame.minX, y: originFrame.midY)
                rectangle.size.height = rectangle.width / aspectRatio
                rectangle.origin.y    = scaleOrigin.y - (rectangle.height * 0.5)
                rectangle.size.width  = originFrame.size.width + xDelta
                rectangle.size.width  = min(rectangle.width, contentFrame.height * aspectRatio)
                
            } else {
                
                let newWidth  = originFrame.width + xDelta
                let newHeight = originFrame.height
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= cropView.minimumAspectRatio {
                    rectangle.size.width = originFrame.width + xDelta
                }
            }
            
        case .bottom:
            
            if cropView.aspectRatioLockEnabled {
                
                aspectVertical = true
                
                let scaleOrigin = CGPoint(x: originFrame.midX, y: originFrame.minY)
                rectangle.size.width  = rectangle.height * aspectRatio
                rectangle.origin.x    = scaleOrigin.x - (rectangle.size.width * 0.5)
                rectangle.size.height = originFrame.height + yDelta
                rectangle.size.height = min(rectangle.height, contentFrame.width / aspectRatio)
                
            } else {
                
                let newWidth  = originFrame.width
                let newHeight = originFrame.height + yDelta
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= cropView.minimumAspectRatio {
                    rectangle.size.height = originFrame.height + yDelta
                }
            }
            
        case .top:
            
            if cropView.aspectRatioLockEnabled {
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
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= cropView.minimumAspectRatio {
                    rectangle.origin.y    = originFrame.origin.y + yDelta
                    rectangle.size.height = originFrame.height   - yDelta
                }
            }
            
            clampMinFromTop = true
            
        case .topLeft:
            
            if cropView.aspectRatioLockEnabled {
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
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= cropView.minimumAspectRatio {
                    rectangle.origin.x    = originFrame.origin.x + xDelta
                    rectangle.origin.y    = originFrame.origin.y + yDelta
                    rectangle.size.width  = originFrame.width    - xDelta
                    rectangle.size.height = originFrame.height   - yDelta
                }
            }
            clampMinFromTop  = true
            clampMinFromLeft = true
            
        case .topRight:
            
            if cropView.aspectRatioLockEnabled {
                
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
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= cropView.minimumAspectRatio {
                    rectangle.size.width  = originFrame.width    + xDelta
                    rectangle.size.height = originFrame.height   - yDelta
                    rectangle.origin.y    = originFrame.origin.y + yDelta
                }
            }
            clampMinFromTop = true
            
        case .bottomLeft:
            
            if cropView.aspectRatioLockEnabled {
                
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
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= cropView.minimumAspectRatio {
                    rectangle.origin.x    = originFrame.origin.x + xDelta
                    rectangle.size.height = originFrame.height   + yDelta
                    rectangle.size.width  = originFrame.width    - xDelta
                }
            }
            clampMinFromLeft = true
            
            
        case .bottomRight:
            
            if cropView.aspectRatioLockEnabled {
                
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
                
                if min(newHeight, newWidth) / max(newHeight, newWidth) >= cropView.minimumAspectRatio {
                    rectangle.size.height = originFrame.height + yDelta
                    rectangle.size.width  = originFrame.width  + xDelta
                }
            }
            
        case .none:
            break
        }
        
        //The absolute max/min size the box may be in the bounds of the crop view
        
        var minSize = CGSize(width: CLDCropView.Constants.minimumBoxSize, height: CLDCropView.Constants.minimumBoxSize)
        var maxSize = CGSize(width: contentFrame.width                  , height: contentFrame.height                 )
        
        //clamp the box to ensure it doesn't go beyond the bounds we've set
        if (cropView.aspectRatioLockEnabled && aspectHorizontal) {
            minSize.width  = CLDCropView.Constants.minimumBoxSize * aspectRatio
            maxSize.height = contentFrame.width / aspectRatio
        }
        
        if (cropView.aspectRatioLockEnabled && aspectVertical) {
            maxSize.width  = contentFrame.height * aspectRatio
            minSize.height = CLDCropView.Constants.minimumBoxSize / aspectRatio
        }
        
        // Clamp the width if it goes over
        if (clampMinFromLeft) {
            let maxWidth  = cropView.cropOriginFrame.maxX - contentFrame.origin.x
            rectangle.size.width = min(rectangle.width, maxWidth)
        }
        
        if (clampMinFromTop) {
            let maxHeight = cropView.cropOriginFrame.maxY - contentFrame.origin.y
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
        if (clampMinFromLeft && rectangle.width <= minSize.width + CGFloat.ulpOfOne) {
            rectangle.origin.x = originFrame.maxX - minSize.width
        }
        
        //Once the box is completely shrunk, clamp its ability to move
        if (clampMinFromTop && rectangle.height <= minSize.height + CGFloat.ulpOfOne) {
            rectangle.origin.y = originFrame.maxY - minSize.height
        }
        
        return rectangle
    }
}
internal extension CLDCropView.Calculator.AspectRatio {
    static func postChangeAdjustments(given newValue: CGSize, animated: Bool, in cropView: CLDCropView) -> (scrollOffset: CGPoint, cropBoxFrame: CGRect , ShouldZoomOut: Bool){
        
        var newAspectRatio = newValue
        
        // Passing in an empty size will revert back to the image aspect ratio
        if (newAspectRatio.width < CGFloat.ulpOfOne && newAspectRatio.height < CGFloat.ulpOfOne ) {
            newAspectRatio = CGSize(width: cropView.imageSize.width, height: cropView.imageSize.height)
        }
        
        let  boundsFrame = cropView.contentBounds
        var rectangle = cropView.cropBoxFrame
        var offset = cropView.scrollView.contentOffset
        
        var cropBoxIsPortrait = false
        if (Int(newAspectRatio.width) == 1 && Int(newAspectRatio.height) == 1) {
            cropBoxIsPortrait = cropView.image.size.width > cropView.image.size.height
        } else {
            cropBoxIsPortrait = newAspectRatio.width < newAspectRatio.height
        }
        
        var shouldZoomOut = false
        switch cropBoxIsPortrait {
        case true :
            
            let newWidth = floor(rectangle.height * (newAspectRatio.width / newAspectRatio.height) )
            var delta = rectangle.width  - newWidth
            rectangle.size.width  = newWidth
            offset.x += (delta * 0.5)
            
            // Set to 0 to avoid accidental clamping by the crop frame sanitizer
            if (delta < CGFloat.ulpOfOne ) {
                rectangle.origin.x = boundsFrame.origin.x
            }
            
            // If the aspect ratio causes the new width to extend
            // beyond the content width, we'll need to zoom the image out
            let boundsWidth = boundsFrame.width
            if (newWidth > boundsWidth) {
                let scale = boundsWidth / newWidth
                
                // Scale the new height
                let newHeight = rectangle.height * scale
                delta = rectangle.height - newHeight
                rectangle.size.height = newHeight
                
                // Offset the Y position so it stays in the middle
                offset.y += (delta * 0.5)
                
                // Clamp the width to the bounds width
                rectangle.size.width = boundsWidth
                shouldZoomOut = true
            }
            
        case false:
            let newHeight = floor(rectangle.width * (newAspectRatio.height/newAspectRatio.width) )
            var delta = rectangle.height - newHeight
            rectangle.size.height = newHeight
            offset.y += (delta * 0.5)
            
            if delta < CGFloat.ulpOfOne {
                rectangle.origin.y = boundsFrame.origin.y
            }
            
            // If the aspect ratio causes the new height to extend
            // beyond the content width, we'll need to zoom the image out
            let boundsHeight = boundsFrame.height
            if (newHeight > boundsHeight) {
                let scale = boundsHeight / newHeight
                
                // Scale the new width
                let newWidth = rectangle.width * scale
                delta = rectangle.size.width - newWidth
                rectangle.size.width = newWidth
                
                // Offset the Y position so it stays in the middle
                offset.x += (delta * 0.5)
                
                // Clamp the width to the bounds height
                rectangle.size.height = boundsHeight
                shouldZoomOut = true
            }
        }
        
        return (scrollOffset: offset, cropBoxFrame: rectangle , ShouldZoomOut: shouldZoomOut)
    }
}
