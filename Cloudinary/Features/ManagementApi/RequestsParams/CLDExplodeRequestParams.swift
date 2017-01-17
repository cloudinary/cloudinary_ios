//
//  CLDExplodeRequestParams.swift
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
 This class represents the different parameters that can be passed when performing an `explode` request.
 */
@objc open class CLDExplodeRequestParams: CLDRequestParams {

    
    // MARK: Init
    
    public override init() {
        super.init()
    }
    
    /**
    Initializes a CLDExplodeRequestParams instance.
    
    - parameter publicId:           The identifier of the uploaded asset.
    - parameter transformation:     A transformation to run on all the pages before storing them as derived images. This parameter is given as an array (using the SDKs) or comma-separated list (for direct API calls) of transformations, and separated with a slash for chained transformations.
        At minimum, you must pass the page transformation with the value all. If you supply additional transformations, you must deliver the image using the same relative order of the page and the other transformations. If you use a different order when you deliver, then it is considered a different transformation, and will be generated on-the-fly as a new derived image.
    
    - returns:                       A new instance of CLDExplodeRequestParams.
    */
    internal init(publicId: String, transformation: CLDTransformation) {
        super.init()
        setParam(ExplodeParams.PublicId.rawValue, value: publicId)
        setParam(ExplodeParams.Transformation.rawValue, value: transformation.asString())
    }
    
    /**
     Initializes a CLDExplodeRequestParams instance.
     
     - parameter params:    A dictionary of the request parameters.
     
     - returns:             A new instance of CLDExplodeRequestParams.
     */
    public init(params: [String : AnyObject]) {
        super.init()
        self.params = params
    }
    
    // MARK: Set Params
    
    /**
    Set the specific file type of the resource.
    
    - parameter type:       The specific file type of the resource.
    
    - returns:              The same instance of CLDExplodeRequestParams.
    */
    @discardableResult
    @objc(setTypeWithType:)
    open func setType(_ type: CLDType) -> Self {
        return setType(String(describing: type))
    }
    
    /**
     Set the specific file type of the resource.
     
     - parameter type:       The specific file type of the resource.
     
     - returns:              The same instance of CLDExplodeRequestParams.
     */
    @discardableResult
    open func setType(_ type: String) -> Self {
        setParam(ExplodeParams.CloudType.rawValue, value: type)
        return self
    }
    
    /**
     Set a format to convert the images before storing them in your Cloudinary account. default is jpg.
     
     - parameter format:        The format to convert to.
     
     - returns:                 The same instance of CLDExplodeRequestParams.
     */
    @discardableResult
    open func setFormat(_ format: String) -> Self {
        setParam(ExplodeParams.Format.rawValue, value: format)
        return self
    }
    
    /**
     Set a boolean parameter indicating whether to perform the image generation in the background (asynchronously). default is false.
     
     - parameter async:         The boolean parameter.
     
     - returns:                 The same instance of CLDExplodeRequestParams.
     */
    @discardableResult
    open func setAsync(_ async: Bool) -> Self {
        setParam(ExplodeParams.Async.rawValue, value: async)
        return self
    }
    
    /**
     Set an HTTP or HTTPS URL to notify your application (a webhook) when the process has completed.
     
     - parameter notificationUrl:       The URL.
     
     - returns:                         The same instance of CLDExplodeRequestParams.
     */
    @discardableResult
    open func setNotificationUrl(_ notificationUrl: String) -> Self {
        setParam(ExplodeParams.NotificationUrl.rawValue, value: notificationUrl)
        return self
    }
    
    
    
    fileprivate enum ExplodeParams: String {
        case PublicId =             "public_id"
        case CloudType =            "type"
        case Transformation =       "transformation"
        case Format =               "format"
        case Async =                "async"
        case NotificationUrl =      "notification_url"
    }
}
