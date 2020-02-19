//
// Created by Nitzan Jaitman on 09/05/2018.
// Copyright (c) 2018 Cloudinary. All rights reserved.
//

import Foundation

open class CLDEagerTransformation: CLDTransformation {
    /**
     Set the format for the eager transformation
    */
    fileprivate var eagerFormat: String?

    open func setFormat(_ format: String?) -> Self{
        self.eagerFormat = format
        return self;
    }

    override func getStringRepresentationFromParams(_ params: [String: String]) -> String? {
        // return the original transformation string with a /format if set.
        var result = ""
        if let baseTransformation = super.getStringRepresentationFromParams(params) {
            result += baseTransformation
        }

        if let format = eagerFormat {
            result += "/\(format)"
        }

        return result
    }
}
