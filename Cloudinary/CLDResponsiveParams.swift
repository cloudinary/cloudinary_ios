//
//  CLDResponsiveParams.swift
//
//  Copyright (c) 2018 Cloudinary (http://cloudinary.com)
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

@objc open class CLDResponsiveParams: NSObject {
    public static let defaultStepSize = 50
    public static let defaultMaxDimension = 350
    public static let defaultMinDimension = 50
    public static let defaultReloadOnSizeChange = false
    
    internal let autoWidth: Bool
    internal let autoHeight: Bool
    internal let cropMode: CLDTransformation.CLDCrop?
    internal let gravity: CLDTransformation.CLDGravity?
    internal var reloadOnSizeChange = defaultReloadOnSizeChange
    internal var stepSize = defaultStepSize
    internal var maxDimension = defaultMaxDimension
    internal var minDimension = defaultMinDimension
    
    // MARK: - Init
    public init(autoWidth: Bool, autoHeight: Bool, cropMode: CLDTransformation.CLDCrop?, gravity: CLDTransformation.CLDGravity?) {
        self.autoWidth = autoWidth
        self.autoHeight = autoHeight
        self.cropMode = cropMode
        self.gravity = gravity
    }
    
    // MARK: - Presets
    public static func fit () -> CLDResponsiveParams {
        return CLDResponsiveParams(autoWidth: true, autoHeight: true, cropMode: CLDTransformation.CLDCrop.fit, gravity: nil)
    }

    public static func autoFill () -> CLDResponsiveParams {
        return CLDResponsiveParams(autoWidth: true, autoHeight: true, cropMode: CLDTransformation.CLDCrop.fill, gravity: CLDTransformation.CLDGravity.auto)
    }
    
    // MARK: - Setters
    public func setStepSize(_ stepSize:Int) -> Self {
        self.stepSize = stepSize
        return self
    }
    
    public func setMaxDimension(_ maxDimension:Int) -> Self {
        self.maxDimension = maxDimension
        return self
    }
    
    public func setMinDimension(_ minDimension:Int) -> Self {
        self.minDimension = minDimension
        return self
    }
    
    public func setReloadOnSizeChange(_ reload: Bool) -> Self {
        self.reloadOnSizeChange = reload
        return self
    }
}


