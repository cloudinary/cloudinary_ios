//
//  CLDResponsiveParams.swift
//  Cloudinary
//
//  Created by Nitzan Jaitman on 16/01/2018.
//  Copyright © 2018 Cloudinary. All rights reserved.
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


