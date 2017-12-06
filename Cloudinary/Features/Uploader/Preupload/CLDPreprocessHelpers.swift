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

/**
 This class contains ready-to-use encoders and processing steps to be used in conjunction with CLDPreprocessChain
*/
public class CLDPreprocessHelpers {
    static let defaultImageEncoder: CLDResourceEncoder<UIImage> = CLDPreprocessHelpers.customImageEncoder(format: EncodingFormat.PNG, quality: 100)

    /**
     Get a CLDPreprocessStep to send to CLDPreprocessChain. This step will scale down an image so that it's dimensions
     are never larger than the request width and height. Aspect ratio will be retained. If the image is already within
     dimensions it is returned as is without any processing.

      - parameter width:             Maximum allowed width
      - parameter height:            Maximum allowed height

      - returns:                     A closure to use in a preprocessing chain.
    */
    public static func scaleDownIfLargerThan(width: CGFloat, height: CGFloat) -> CLDPreprocessStep<UIImage>{
        return {image in
            if (image.size.width > width){
                return resizeImage(image: image, newSize: CGSize(width: width, height: height))
            }
            
            return image
        }
    }

    /**
     Get a CLDResourceEncoder to use in LDPreprocessChain. This encoder saves the image with the
     chosen format and quality.

      - parameter format:   Image format to encode the image
      - parameter height:   Quality to save the image (ignored if the chosen
                            format doesn't support quality)

      - returns:            A closure to use as encoder in a preprocessing chain
    */
    public static func customImageEncoder(format: EncodingFormat, quality: CGFloat) -> CLDResourceEncoder<UIImage> {
        return { image in
            if let data = encodeAs(image:image, format: format, quality: quality) {
                let url = CLDFileUtils.getTempFileUrl(fileName: NSUUID().uuidString)
                try? data.write(to: url)
                return url
            }
        
            return nil
        }
    }


    /**
     Get a CLDPreprocessStep to send to CLDPreprocessChain. This step will validate a given image's dimensions are
     within chosen bounds. If it's not an exception is throw and the CLDUploadRequest fails.

      - parameter minWidth:         Minimum width allowed.
      - parameter maxWidth:         Maximum width allowed.
      - parameter minHeight:        Minimum height allowed.
      - parameter maxHeight:        Maximum height allowed.

      - returns:                     A closure to use in a preprocessing chain.
    */
    public static func dimensionsValidator(minWidth:Int, maxWidth:Int, minHeight:Int, maxHeight:Int) -> CLDPreprocessStep<UIImage>{
        return {image in
            if let width = image.cgImage?.width, let height = image.cgImage?.height {
                if (width > maxWidth || width < minWidth ||
                    height > maxHeight || height < minHeight){
                    throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Image dimensions invalid")
                }
            }
            
            return image
        }
    }

    static func encodeAs(image:UIImage, format: EncodingFormat, quality: CGFloat) -> Data? {
        
        switch format {
        case EncodingFormat.JPEG:
            return UIImageJPEGRepresentation(image, quality)
        case EncodingFormat.PNG:
            return UIImagePNGRepresentation(image)
        }
    }

    static func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        let newWidth: CGFloat
        let newHeight: CGFloat
        if (image.size.width > image.size.height) {
            newHeight = (image.size.height / image.size.width) * newSize.width
            newWidth = newSize.width;
        } else {
            newWidth = (image.size.width / image.size.height) * newSize.height
            newHeight = newSize.height;
        }
        
        let newSize = CGSize(width: newWidth/image.scale, height: newHeight/image.scale)
        var newImage: UIImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

public enum EncodingFormat {
    case JPEG
    case PNG
}
