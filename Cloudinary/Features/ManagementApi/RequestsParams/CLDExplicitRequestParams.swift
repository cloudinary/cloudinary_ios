//
//  CLDExplicitRequestParams.swift
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
 This class represents the different parameters that can be passed when performing an `explicit` request.
 */
@objc open class CLDExplicitRequestParams: CLDUploadRequestParams {

    
    //MARK: Init
    
    public override init() {
        super.init()
    }
    
    /**
    Initializes a CLDExplicitRequestParams instance.
    
    - parameter publicId:           The identifier of the uploaded asset.
    - parameter type:               The specific file type of the resource.
    
    - returns:                       A new instance of CLDExplicitRequestParams.
    */
    internal convenience init(publicId: String, type: CLDType) {
        self.init(publicId: publicId, type: String(describing: type))
    }
    
    /**
     Initializes a CLDExplicitRequestParams instance.
     
     - parameter publicId:           The identifier of the uploaded asset.
     - parameter type:               The specific file type of the resource.
     
     - returns:                       A new instance of CLDExplicitRequestParams.
     */
    @objc(initWithPublicId:andType:)
    internal init(publicId: String, type: String) {
        super.init()
        setPublicId(publicId)
        setType(type)
    }
    
    /**
     Initializes a CLDExplicitRequestParams instance.
     
     - parameter params:    A dictionary of the request parameters.
     
     - returns:             A new instance of CLDExplicitRequestParams.
     */
    public override init(params: [String : AnyObject]) {
        super.init(params: params)
    }
}
