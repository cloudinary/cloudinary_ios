//
//  CLDRenameRequestParams.swift
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
 This class represents the different parameters that can be passed when performing a rename request.
 */
@objcMembers open class CLDRenameRequestParams: CLDRequestParams {

    
    // MARK: Init
    
    public override init() {
        super.init()
    }
    
    /**
    Initializes a CLDRenameRequestParams instance.
    
    - parameter fromPublicId:       The current identifier of the uploaded asset.
    - parameter toPublicId:         The new identifier to assign to the uploaded asset.
    - parameter overwrite:          A boolean parameter indicating whether or not to overwrite an existing image with the target Public ID. Default: false.
    - parameter invalidate:         A boolean parameter whether to invalidate CDN cached copies of the image (and all its transformed versions). Default: false.
    
    - returns:                       A new instance of CLDRenameRequestParams.
    */
    internal init(fromPublicId: String, toPublicId: String, overwrite: Bool? = nil, invalidate: Bool? = nil) {
        super.init()
        setParam(RenameParams.FromPublicId.rawValue, value: fromPublicId)
        setParam(RenameParams.ToPublicId.rawValue, value: toPublicId)        
        setParam(RenameParams.Overwrite.rawValue, value: overwrite)
        setParam(RenameParams.Invalidate.rawValue, value: invalidate)
    }
    
    /**
     Initializes a CLDRenameRequestParams instance.
     
     - parameter params:    A dictionary of the request parameters.
     
     - returns:             A new instance of CLDRenameRequestParams.
     */
    public init(params: [String : AnyObject]) {
        super.init()
        self.params = params
    }
    
    // MARK: - Rename Params
    
    fileprivate enum RenameParams: String {
        case FromPublicId =         "from_public_id"
        case ToPublicId =           "to_public_id"
        case Overwrite =            "overwrite"
        case Invalidate =           "invalidate"
    }
}
