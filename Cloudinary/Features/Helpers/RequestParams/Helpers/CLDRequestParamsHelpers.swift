//
//  CLDRequestParamsHelpers.swift
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

// MARK: - CLDSignature

/**
The CLDSignature class represents a signature used to sign a URL request.
*/
@objc open class CLDSignature: NSObject {
        
    open let signature: String
    open let timestamp: NSNumber
    
    public init(signature: String, timestamp: NSNumber) {
        self.signature = signature
        self.timestamp = timestamp
        super.init()
    }
    
    
    internal enum SignatureParam: String, CustomStringConvertible {
        case Signature =        "signature"
        case Timestamp =        "timestamp"
        
        var description: String {
            get {
                switch self {
                case .Signature: return "signature"
                case .Timestamp: return "timestamp"
                }
            }
        }
    }
}


// MARK: - CLDCoordinate

/**
The CLDCoordinate class represents a rectangle area on an asset.
*/
@objc open class CLDCoordinate: NSObject {
    
    let rect: CGRect
    
    var x: Float {
        return Float(rect.origin.x)
    }
    
    var y: Float {
        return Float(rect.origin.y)
    }
    
    var width: Float {
        return Float(rect.width)
    }
    
    var height: Float {
        return Float(rect.height)
    }
    
    // MARK: Init
    
    /**
    Initializes the CLDCoordinate using a CGRect.
    
    - parameter rect:   The rectangle representing an area on the asset.
    
    - returns:          A new CLDCoordinate instance.
    */
    public init(rect: CGRect) {
        self.rect = rect
    }
    
    open override var description: String {
        get {
            var components: [String] = []
            components.append(x.cldFormat(f: ".0"))
            components.append(y.cldFormat(f: ".0"))
            components.append(width.cldFormat(f: ".0"))
            components.append(height.cldFormat(f: ".0"))
            return components.joined(separator: ",")
        }
    }
}



// MARK: - CLDResponsiveBreakpoints

/**
The CLDResponsiveBreakpoints class describe the settings available for configuring responsive breakpoints.
Responsive breakpoints is used to request Cloudinary to automatically find the best breakpoints.
*/
@objc open class CLDResponsiveBreakpoints: NSObject {
    
    internal var params: [String: AnyObject] = [:]
    
    // MARK - Init
    
    /**
    Initializes a CLDResponsiveBreakpoints instance.
    
    - parameter createDerived:      If true, create and keep the derived assets of the selected breakpoints during the API call.
                                    If false, assets generated during the analysis process are thrown away.
    
    - returns:                      A new CLDResponsiveBreakpoints instance.
    */
    public init(createDerived: Bool) {
        super.init()
        setParam(ResponsiveBreakpointsParams.CreateDerived.rawValue, value: createDerived as AnyObject?)
    }
    
    // MARK - Set Param
    
    /**
    Set the base transformation to first apply to the image before finding the best breakpoints.
    
    - parameter transformation:     The transformation to apply.
    
    - returns:                      The same CLDResponsiveBreakpoints instance.
    */
    open func setTransformations(_ transformation: CLDTransformation) -> Self {
        if let trans = transformation.asString() {
            setParam(ResponsiveBreakpointsParams.Transformation.rawValue, value: trans as AnyObject?)
        }
        return self
    }
    
    /**
     Set the maximum width needed for this asset. 
     If specifying a width bigger than the original asset, the width of the original asset is used instead. default is 1000.
     
     - parameter maxWidth:          The max width to set.
     
     - returns:                      The same CLDResponsiveBreakpoints instance.
     */
    open func setMaxWidth(_ maxWidth: Int) -> Self {
        return setParam(ResponsiveBreakpointsParams.MaxWidth.rawValue, value: maxWidth as AnyObject?)
    }
    
    /**
     Set the minimum width needed for this asset. default is 50.
     
     - parameter minWidth:          The min width to set.
     
     - returns:                      The same CLDResponsiveBreakpoints instance.
     */
    open func setMinWidth(_ minWidth: Int) -> Self {
        return setParam(ResponsiveBreakpointsParams.MinWidth.rawValue, value: minWidth as AnyObject?)
    }
    
    /**
     Set the minimum number of bytes between two consecutive breakpoints (assets). default is 20000.
     
     - parameter bytesStep:          The bytes step to set.
     
     - returns:                      The same CLDResponsiveBreakpoints instance.
     */
    open func setBytesStep(_ bytesStep: Int) -> Self {
        return setParam(ResponsiveBreakpointsParams.BytesStep.rawValue, value: bytesStep as AnyObject?)
    }
    
    /**
     Set the maximum number of breakpoints to find, between 3 and 200. 
     This means that there might be size differences bigger than the given bytes_step value between consecutive assets. default is 20.
     
     - parameter maxImages:          The max images to set.
     
     - returns:                      The same CLDResponsiveBreakpoints instance.
     */
    open func setMaxImages(_ maxImages: Int) -> Self {
        return setParam(ResponsiveBreakpointsParams.MaxImages.rawValue, value: maxImages as AnyObject?)
    }
    
    @discardableResult
    open func setParam(_ key: String, value: AnyObject?) -> Self {
        params[key] = value
        return self
    }
    
    
    fileprivate enum ResponsiveBreakpointsParams: String, CustomStringConvertible {
        case CreateDerived =                "create_derived"
        case Transformation =               "transformation"
        case MaxWidth =                     "max_width"
        case MinWidth =                     "min_width"
        case BytesStep =                    "bytes_step"
        case MaxImages =                    "max_images"
        
        var description: String {
            get {
                switch self {
                case .CreateDerived:         return "create_derived"
                case .Transformation:        return "transformation"
                case .MaxWidth:              return "max_width"
                case .MinWidth:              return "min_width"
                case .BytesStep:             return "bytes_step"
                case .MaxImages:             return "max_images"
                }
            }
        }
    }
    
}

