//
//  UIButton+Cloudinary.swift
//
//  Copyright (c) 2016 Cloudinary (http://cloudinary.com)
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

public extension UIButton {
    
    /**
     Download an image asynchronously from the specified URL and set it to the UIButton's image.
     The image is retrieved from the cache if it exists, otherwise its downloaded and cached.
     
     - parameter url:               The image URL to download.
     - parameter state:             The UIButton's UIControlState state that uses the specified image.
     - parameter placeholder:       A placeholder image to be set as the image untill the asynchronus download request finishes.
     - parameter networkAdapter:    A network adapter that implements `CLDNetworkAdapter`.
     CLDNetworkDelegate() by default.
     
     */
    @objc public func cldSetImage(_ url: String, forState state: UIControlState, cloudinary: CLDCloudinary, placeholder: UIImage? = nil) {
        
        let setImageOnMainQueue = { [weak self] (image: UIImage) in
            DispatchQueue.main.async {
                self?.setImage(image, for: state)
            }
        }
        
        fetchImageForUIElement(url, placeholder: placeholder, cloudinary: cloudinary, fetchedImageHandler: setImageOnMainQueue)
    }
    
    /**
     Download an image asynchronously from the specified URL and set it to the UIButton's image.
     The image is retrieved from the cache if it exists, otherwise its downloaded and cached.
     
     - parameter publicId:          The remote asset's name (e.g. the public id of an uploaded image).
     - parameter cloudinary:        An instance of CLDCloudinary.
     - parameter state:             The UIButton's UIControlState state that uses the specified image.
     - parameter signUrl:           A boolean parameter indicating whether or not to generate a signiture out of the API secret and add it to the generated URL. Default is false.
     - parameter transformation:    An instance of CLDTransformation.
     - parameter placeholder:       A placeholder image to be set as the background image untill the asynchronus download request finishes.
     
     */
    @objc public func cldSetImage(publicId: String, cloudinary: CLDCloudinary, forState state: UIControlState, signUrl: Bool = false, transformation: CLDTransformation? = nil, placeholder: UIImage? = nil) {
        
        let urlGen = cloudinary.createUrl()
        
        if let transformation = transformation {
            urlGen.setTransformation(transformation)
        }
        
        func setImageOnMainQueue(_ image: UIImage) {
            DispatchQueue.main.async { [weak self] in
                self?.setImage(image, for: state)
            }
        }
        
        guard let url = urlGen.generate(publicId, signUrl: signUrl) else {
            if let placeholder = placeholder {
                setImageOnMainQueue(placeholder)
            }
            return
        }
        
        let fetchedImageHandler = { (image: UIImage) in
            setImageOnMainQueue(image)
        }
        
        fetchImageForUIElement(url, placeholder: placeholder, cloudinary: cloudinary, fetchedImageHandler: fetchedImageHandler)
    }
    
    /**
     Download an image asynchronously from the specified URL and set it to the UIButton's background image.
     The image is retrieved from the cache if it exists, otherwise its downloaded and cached.
     
     - parameter url:               The image URL to download.
     - parameter state:             The UIButton's UIControlState state that uses the specified image.
     - parameter placeholder:       A placeholder image to be set as the background image untill the asynchronus download request finishes.
     - parameter networkAdapter:    A network adapter that implements `CLDNetworkAdapter`.
                                    CLDNetworkDelegate() by default.
     
    */
    @objc public func cld_setBackgroundImage(_ url: String, forState state: UIControlState, cloudinary: CLDCloudinary, placeholder: UIImage? = nil) {
        
        let setImageOnMainQueue = { [weak self] (image: UIImage) in
            DispatchQueue.main.async {
                self?.setBackgroundImage(image, for: state)
            }
        }
        
        fetchImageForUIElement(url, placeholder: placeholder, cloudinary: cloudinary, fetchedImageHandler: setImageOnMainQueue)
    }
    
    /**
     Download an image asynchronously from the specified URL and set it to the UIButton's image.
     The image is retrieved from the cache if it exists, otherwise its downloaded and cached.
     
     - parameter publicId:          The remote asset's name (e.g. the public id of an uploaded image).
     - parameter cloudinary:        An instance of CLDCloudinary.
     - parameter state:             The UIButton's UIControlState state that uses the specified image.
     - parameter signUrl:           A boolean parameter indicating whether or not to generate a signiture out of the API secret and add it to the generated URL. Default is false.
     - parameter transformation:    An instance of CLDTransformation.
     - parameter placeholder:       A placeholder image to be set as the background image untill the asynchronus download request finishes.
     
     */
    @objc public func cld_setBackgroundImage(publicId: String, cloudinary: CLDCloudinary, forState state: UIControlState, signUrl: Bool = false, transformation: CLDTransformation? = nil, placeholder: UIImage? = nil) {
        
        let urlGen = cloudinary.createUrl()
        
        if let transformation = transformation {
            urlGen.setTransformation(transformation)
        }
        
        func setImageOnMainQueue(_ image: UIImage) {
            DispatchQueue.main.async { [weak self] in
                self?.setBackgroundImage(image, for: state)
            }
        }
        
        guard let url = urlGen.generate(publicId, signUrl: signUrl) else {
            if let placeholder = placeholder {
                setImageOnMainQueue(placeholder)
            }
            return
        }
        
        let fetchedImageHandler = { (image: UIImage) in
            setImageOnMainQueue(image)
        }
        
        fetchImageForUIElement(url, placeholder: placeholder, cloudinary: cloudinary, fetchedImageHandler: fetchedImageHandler)
    }
    
}
