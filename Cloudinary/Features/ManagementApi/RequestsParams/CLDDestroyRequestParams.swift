//
//  CLDDestroyRequestParams.swift
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
 This class represents the different parameters that can be passed when performing a destroy request.
 */
@objc open class CLDDestroyRequestParams: CLDRequestParams {
    
    //MARK: Init
    
    public override init() {
        super.init()
    }
    
    /**
    Initializes a CLDDestroyRequestParams instance.
    
    - parameter publicId:           The identifier of the asset to remove.
    
    - returns:                       A new instance of CLDDestroyRequestParams.
    */
    internal init(publicId: String) {
        super.init()
        setParam(DestroyParams.PublicId.rawValue, value: publicId)
    }
    
    /**
     Initializes a CLDDestroyRequestParams instance.
     
     - parameter params:    A dictionary of the request parameters.
     
     - returns:             A new instance of CLDDestroyRequestParams.
     */
    public init(params: [String : AnyObject]) {
        super.init()
        self.params = params
    }
    
    //MARK: Set Params
    
    /**
    Set the specific file type of the resource using one of the available options from CLDType.
    
    - parameter type:       The file type to set.
    
    - returns:              The same instance of CLDDestroyRequestParams.
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
        super.setParam(DestroyParams.CloudType.rawValue, value: type)
        return self
    }
    
    /**
     Set boolean parameter indicating whether or not the asset should be invalidated through the CDN. default is false.
     
     - parameter invalidate:    The boolean parameter.
     
    - returns:              The same instance of CLDDestroyRequestParams.
    */
    @discardableResult
    open func setInvalidate(_ invalidate: Bool) -> Self {
        super.setParam(DestroyParams.Invalidate.rawValue, value: invalidate)
        return self
    }
    
    fileprivate enum DestroyParams: String {
        case PublicId =             "public_id"
        case CloudType =            "type"
        case Invalidate =           "invalidate"
    }
}
