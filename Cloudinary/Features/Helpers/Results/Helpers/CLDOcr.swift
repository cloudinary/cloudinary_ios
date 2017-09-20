//
//  CLDOcr.swift
//  Cloudinary
//
//  Created by Sergey Glushchenko on 8/22/17.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import UIKit

@objc open class CLDOcr: CLDBaseResult {
    open var status: String? {
        return getParam(.status) as? String
    }
    
    open var data: Any? {
        return getParam(.data)
    }
    
    // MARK: - Private Helpers
    
    fileprivate func getParam(_ param: CLDOcrKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum CLDOcrKey: CustomStringConvertible {
        case status, data
        
        var description: String {
            switch self {
            case .status:           return "status"
            case .data:             return "data"
            }
        }
    }
}
