//
//  CLDSpriteRequestParams.swift
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

/**
 This class represents the different parameters that can be passed when performing a request to generate a sprite.
 */
@objcMembers open class CLDSpriteRequestParams: CLDRequestParams {

    
    // MARK: Init
    
    public override init() {
        super.init()
    }
    
    /**
    Initializes a CLDSpriteRequestParams instance.
    
    - parameter tag:        The sprite is created from all images with this tag.
    
    - returns:              A new instance of CLDSpriteRequestParams.
    */
    internal init(tag: String) {
        super.init()
        setParam(SpriteParams.Tag.rawValue, value: tag)
    }
    
    /**
     Initializes a CLDSpriteRequestParams instance.
     
     - parameter params:    A dictionary of the request parameters.
     
     - returns:             A new instance of CLDSpriteRequestParams.
     */
    public init(params: [String : AnyObject]) {
        super.init()
        self.params = params
    }
    
    // MARK: Set Params
    
    /**
    Set a transformation to run on all the individual images before creating the sprite.
    
    - parameter transformation:     The transformation to run.
    
    - returns:                      A new instance of CLDSpriteRequestParams.
    */
    @discardableResult
    open func setTransformation(_ transformation: CLDTransformation) -> Self {
        if let stringRep = transformation.asString() {
            setParam(SpriteParams.Transformation.rawValue, value: stringRep)
        }
        return self
    }
    
    /**
     Set a format to convert the images before storing them in your Cloudinary account. default is jpg.
     
     - parameter format:        The format to convert to.
     
     - returns:                      A new instance of CLDSpriteRequestParams.
     */
    @discardableResult
    open func setFormat(_ format: String) -> Self {
        super.setParam(SpriteParams.Format.rawValue, value: format)
        return self
    }
    
    /**
     Set a boolean parameter indicating whether to perform the image generation in the background (asynchronously). default is false.
     
     - parameter async:         The boolean parameter.
     
     - returns:                      A new instance of CLDSpriteRequestParams.
     */
    @discardableResult
    open func setAsync(_ async: Bool) -> Self {
        super.setParam(SpriteParams.Async.rawValue, value: async)
        return self
    }
    
    /**
     Set an HTTP or HTTPS URL to notify your application (a webhook) when the process has completed.
     
     - parameter notificationUrl:       The URL.
     
     - returns:                      A new instance of CLDSpriteRequestParams.
     */
    @discardableResult
    open func setNotificationUrl(_ notificationUrl: String) -> Self {
        super.setParam(SpriteParams.NotificationUrl.rawValue, value: notificationUrl)
        return self
    }
    
    
    
    fileprivate enum SpriteParams: String {
        case Tag =                  "tag"
        case Transformation =       "transformation"
        case Format =               "format"
        case Async =                "async"
        case NotificationUrl =      "notification_url"
    }
}
