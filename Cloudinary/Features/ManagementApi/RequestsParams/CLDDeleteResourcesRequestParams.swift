//
//  CLDDeleteResourcesRequestParams.swift
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
 This class represents the different parameters that can be passed when performing a `delete by token` request.
 */
open class CLDDeleteResourcesRequestParams: CLDRequestParams {

    
    // MARK: Init
    
    fileprivate override init() {
        super.init()
    }
    
    /**
    Initializes a CLDDeleteResourcesRequestParams instance.
    
    - parameter transformation:      The delete transformation received in the upload response.
    
    - returns:              A new instance of CLDDeleteResourcesRequestParams.
    */
    public init(transformation: CLDTransformation) {
        super.init()
        method = "DELETE"
        setTransformation(transformation)
    }
    
    public init(prefix: String) {
        super.init()
        method = "DELETE"
        setPrefix(prefix)
    }
    
    /**
     Initializes a CLDDeleteResourcesRequestParams instance.
     
     - parameter params:    A dictionary of the request parameters.
     
     - returns:             A new instance of CLDDeleteResourcesRequestParams.
     */
    public init(params: [String : Any]) {
        super.init()
        method = "DELETE"
        self.params = params
    }
    
    // MARK: Set Params
    
    /**
     Set a transformation to run on all the individual images before creating the sprite.
     
     - parameter transformation:     The transformation to run.
     
     - returns:                      A new instance of CLDDeleteResourcesRequestParams.
     */
    @discardableResult
    open func setTransformation(_ transformation: CLDTransformation) -> Self {
        if let trans = transformation.asString() {
            super.setParam(DeleteResourcesParams.Transformation.rawValue, value: trans)
        }
        return self
    }
    
    /**
     Delete all resources, including derived resources, where the public ID starts with the given prefix (up to a maximum of 1000 original resources).
     
     - parameter prefix:     prefix resource name.
     
     - returns:                      A new instance of CLDDeleteResourcesRequestParams.
     */
    @discardableResult
    open func setPrefix(_ prefix: String) -> Self {
        super.setParam(DeleteResourcesParams.Prefix.rawValue, value: prefix)
        return self
    }
    
    /**
     Delete all resources with the given public IDs (array of up to 100 public_ids).
     
     - parameter publicIDs:     public IDs.
     
     - returns:                      A new instance of CLDDeleteResourcesRequestParams.
     */
    @discardableResult
    open func setPublicIDs(_ publicIDs: [String]) -> Self {
        super.setParam(DeleteResourcesParams.PublicIDs.rawValue, value: publicIDs)
        return self
    }
    
    /**
      Delete all resources (of the relevant resource type and type), including derived resources (up to a maximum of 1000 original resources).
     
     - parameter all:     Optional (Boolean, default: false)
     
     - returns:                      A new instance of CLDDeleteResourcesRequestParams.
     */
    @discardableResult
    open func setAll(_ all: Bool) -> Self {
        super.setParam(DeleteResourcesParams.All.rawValue, value: all)
        return self
    }
    
    /**
     Optional (Boolean, default: false). If true, delete only the derived resources
     
     - parameter keepOriginal:     Optional (Boolean, default: false). If true, delete only the derived resources
     
     - returns:                      A new instance of CLDDeleteResourcesRequestParams.
     */
    @discardableResult
    open func setKeepOriginal(_ keepOriginal: Bool) -> Self {
        super.setParam(DeleteResourcesParams.KeepOriginal.rawValue, value: keepOriginal)
        return self
    }
    
    /**
     Optional (Boolean, default: false). Whether to also invalidate the copies of the resource on the CDN. It usually takes a few minutes (although it might take up to an hour) for the invalidation to fully propagate through the CDN. There are also a number of other important considerations to keep in mind when invalidating files. Note that by default this parameter is not enabled: if you need this parameter enabled, please open a support request.
     
     - parameter invalidate:     Optional (Boolean, default: false)
     
     - returns:                      A new instance of CLDDeleteResourcesRequestParams.
     */
    @discardableResult
    open func setInvalidate(_ invalidate: Bool) -> Self {
        super.setParam(DeleteResourcesParams.Invalidate.rawValue, value: invalidate)
        return self
    }
    
    /**
     Optional. When a deletion request has more than 1000 resources to delete, the response includes the partial boolean parameter set to true, as well as a next_cursor value. You can then specify this returned next_cursor value as the next_cursor parameter of the following deletion request.
     
     - parameter nextCursor:     Optional (Boolean, default: false)
     
     - returns:                      A new instance of CLDDeleteResourcesRequestParams.
     */
    @discardableResult
    open func setNextCursor(_ nextCursor: Bool) -> Self {
        super.setParam(DeleteResourcesParams.NextCursor.rawValue, value: nextCursor)
        return self
    }
    
    // MARK: Params
    
    fileprivate enum DeleteResourcesParams: String {
        case Transformation =   "transformation"
        case Prefix =           "prefix"
        case PublicIDs =        "public_ids"
        case All =              "all"
        case KeepOriginal =     "keep_original"
        case Invalidate =       "invalidate"
        case NextCursor =       "next_cursor"
        
    }
    
}
