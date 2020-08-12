//
//
//  CLDPreprocessHelpers.swift
//
//  Copyright (c) 2017 Cloudinary (http://cloudinary.com)
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


import Foundation
import UIKit

/**
 This class contains ready-to-use encoders and processing steps to be used with CLDPreprocessChain
 */
public class CLDPreprocessHelpers {
    
    static let defaultImageEncoder: CLDResourceEncoder<UIImage> = CLDPreprocessHelpers.customImageEncoder(format: EncodingFormat.PNG, quality: 100)
    
    /**
     Get a CLDPreprocessStep closure to send to CLDPreprocessChain. Scales down any image larger than width/height
     params while retaining the original aspect ratio. If the original image is already within bounds it will be
     returned unchanged (i.e. a smaller image won't be enlarged).
     
     - parameter width:             Maximum allowed width
     - parameter height:            Maximum allowed height
     
     - returns:                     A closure to use in a preprocessing chain.
     */
    public static func limit(width: CGFloat, height: CGFloat) -> CLDPreprocessStep<UIImage> {
        
        return { image in
            
            if (image.size.width > width || image.size.height > height) {
                return resizeImage(image: image, requiredSize: CGSize(width: width, height: height))
            }
            return image
        }
    }
    
    /**
     Get a CLDPreprocessStep closure to send to CLDPreprocessChain. Returns the image cropped to the requested rectangle. This step will validate that the chosen rectangle is within the image's dimensions, otherwise an exception is thrown and the CLDUploadRequest fails.
     
     - parameter cropRect:          The requested crop rectangle.
     
     - returns:                     A closure to use in a preprocessing chain.
     */
    public static func crop(cropRect: CGRect) -> CLDPreprocessStep<UIImage> {
        
        return { image in
            
            let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            guard imageRect.contains(cropRect) else {
                throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Crop dimensions out of bounds")
            }
            
            if let croppedImage = image.cld_crop(cropRect) {
                return croppedImage
            }
            else {
                throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Image cropping failed")
            }
        }
    }
    /**
     Get a CLDPreprocessStep closure to send to CLDPreprocessChain. Rotates any image to the requested degree.
     
     - parameter degrees:           The requested rotation degree
     
     - returns:                     A closure to use in a preprocessing chain.
     */
    public static func rotate(degrees: Float) -> CLDPreprocessStep<UIImage> {
        
        return { image in
            
            if let rotatedImage = image.cld_rotate(degrees) {
                return rotatedImage
            }
            return image
        }
    }
    
    /**
     Get a CLDResourceEncoder to use in CLDPreprocessChain. This encoder saves the image with the
     chosen format and quality.
     
     - parameter format:   Image format to encode the image
     - parameter height:   Quality to save the image (ignored if the chosen
     format doesn't support quality)
     
     - returns:            A closure to use as encoder in a preprocessing chain
     */
    public static func customImageEncoder(format: EncodingFormat, quality: CGFloat) -> CLDResourceEncoder<UIImage> {
        
        return { image in
            
            if let data = encodeAs(image: image, format: format, quality: quality) {
                
                let (_, url) = CLDFileUtils.getTempFileUrl(fileName: NSUUID().uuidString, baseFolder:"imageEncoder")
                try? data.write(to: url)
                return url
                
            }
            return nil
        }
    }
    
    /**
     Get a CLDPreprocessStep to send to CLDPreprocessChain. This step will validate that a given image's
     dimensions are within the chosen bounds, otherwise an exception is throw and the CLDUploadRequest fails.
     
     - parameter minWidth:         Minimum width allowed.
     - parameter maxWidth:         Maximum width allowed.
     - parameter minHeight:        Minimum height allowed.
     - parameter maxHeight:        Maximum height allowed.
     
     - returns:                     A closure to use in a preprocessing chain.
     */
    public static func dimensionsValidator(minWidth: Int, maxWidth: Int, minHeight: Int, maxHeight: Int) -> CLDPreprocessStep<UIImage> {
        
        return { image in
            
            if let width = image.cgImage?.width, let height = image.cgImage?.height {
                if (width  > maxWidth  || width  < minWidth ||
                    height > maxHeight || height < minHeight) {
                    throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Image dimensions invalid")
                }
            }
            return image
        }
    }
    
    internal static func encodeAs(image: UIImage, format: EncodingFormat, quality: CGFloat) -> Data? {
        
        switch format {
        case EncodingFormat.JPEG:
            return image.jpegData(compressionQuality: quality)
        case EncodingFormat.PNG:
            return image.pngData()
        }
    }
    
    internal static func resizeImage(image: UIImage, requiredSize: CGSize) -> UIImage {
        
        let widthRatio = requiredSize.width / image.size.width
        let heightRatio = requiredSize.height / image.size.height
        
        let newSize: CGSize
        if (heightRatio > widthRatio) {
            newSize = CGSize(width: requiredSize.width, height: round(widthRatio * image.size.height))
        } else {
            newSize = CGSize(width: round(heightRatio * image.size.width), height: requiredSize.height)
        }
        
        var newImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

internal extension UIImage
{
    func cld_crop(_ rect: CGRect) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
        self.draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
    
    fileprivate func cld_radians(from degrees: Double) -> CGFloat {
        return CGFloat(degrees * Double.pi / 180.0);
    }
    
    func cld_rotate(_ degree: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: cld_radians(from: Double(degree)))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: cld_radians(from: Double(degree)))
        // Draw the image at its center
        draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

public enum EncodingFormat {
    case JPEG
    case PNG
}
