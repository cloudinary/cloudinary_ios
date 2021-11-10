//
//  CLDError.swift
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

internal struct CLDError {
    
    fileprivate static let domain = "com.cloudinary.error"
    
    enum CloudinaryErrorCode: Int {
        case generalErrorCode                       = -7000
        case failedCreatingImageFromData            = -7001
        case failedDownloadingImage                 = -7002
        case failedRetrievingFileInfo               = -7003
        case preprocessingError                     = -7004
        case failedDownloadingAsset                 = -7005
        case unacceptableStatusCode                 = -7006
    }
    
    static func generalError(userInfo: [AnyHashable: Any?]? = nil) -> NSError {
        return error(code: .generalErrorCode, message: "Something went wrong.", userInfo: userInfo)
    }
    
    static func error(domain: String = CLDError.domain, code: CloudinaryErrorCode, message: String) -> NSError {
        let userInfo = [NSLocalizedFailureReasonErrorKey: message]
        return error(domain: domain, code: code.rawValue, userInfo: userInfo)
    }
    
    static func error(code: CloudinaryErrorCode, message: String, userInfo: [AnyHashable: Any?]?) -> NSError {
        var _userInfo = userInfo
        _userInfo?[NSLocalizedFailureReasonErrorKey] = message
        return error(code: code.rawValue, userInfo: userInfo)
    }
    
    static func error(domain: String? = CLDError.domain, code: Int, userInfo: [AnyHashable: Any?]?) -> NSError {
        var info = [String: Any]()
        var _domain = CLDError.domain
        if let domain = domain {
            _domain = domain
        }
        if let userInfo = userInfo {
            userInfo.forEach {key, value in
                if let value = value {
                    info[String(describing: key)] = value
                }
                
            }
        }
        
        return NSError(domain: _domain, code: code, userInfo: info)
    }
}
