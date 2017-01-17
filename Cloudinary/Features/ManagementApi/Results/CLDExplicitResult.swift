//
//  CLDExplicitResult.swift
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

@objc open class CLDExplicitResult: CLDUploadResult {
        
    
    // MARK: - Getters    
    
    open var type: String? {
        return getParam(.urlType) as? String
    }
    
    open var eager: [CLDEagerResult]? {
        guard let eagerArr = getParam(.eager) as? [[String : AnyObject]] else {
            return nil
        }
        var eager: [CLDEagerResult] = []
        for singleEeager in eagerArr {
            eager.append(CLDEagerResult(json: singleEeager))
        }
        return eager
    }
    
    // MARK: - Private Helpers
    
    fileprivate func getParam(_ param: ExplicitResultKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum ExplicitResultKey: CustomStringConvertible {
        case eager
        
        var description: String {
            switch self {
            case .eager:            return "eager"
            }
        }
    }
}

@objc open class CLDEagerResult: CLDBaseResult {
    
    // MARK: - Getters
    
    open var url: String? {
        return getParam(.url) as? String
    }
    
    open var secureUrl: String? {
        return getParam(.secureUrl) as? String
    }        
}
