//
//  ExtensionCLDTransformation.swift
//  Cloudinary
//
//  Created on 23/02/2020.
//

#if SWIFT_PACKAGE
    import Cloudinary_Core
#endif

#if os(iOS)
import UIKit
import Foundation

extension CLDTransformation
{
    /**
     Deliver the image in the correct device pixel ratio, according to the used device.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setDprAuto() -> Self {
        let scale = Float(UIScreen.main.scale)
        return setDpr(scale)
    }
}

#endif
