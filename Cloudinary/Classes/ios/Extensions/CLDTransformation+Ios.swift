//
//  CLDTransformation+Ios.swift
//  Cloudinary
//
//  Created by Ido Meirov on 23/02/2020.
//

import Foundation
import UIKit

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
