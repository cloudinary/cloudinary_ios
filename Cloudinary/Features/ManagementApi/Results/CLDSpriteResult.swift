//
//  CLDSpriteResult.swift
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

@objc open class CLDSpriteResult: CLDBaseResult {
    
    // MARK: - Getters
    
    open var cssUrl: String? {
        return getParam(.cssUrl) as? String
    }
    
    open var secureCssUrl: String? {
        return getParam(.secureCssUrl) as? String
    }
    
    open var imageUrl: String? {
        return getParam(.imageUrl) as? String
    }
    
    open var jsonUrl: String? {
        return getParam(.jsonUrl) as? String
    }
    
    open var publicId: String? {
        return getParam(.publicId) as? String
    }
    
    open var version: String? {
        guard let version = getParam(.version) else {
            return nil
        }
        return String(describing: version)
    }
    
    open var imageInfos: [String : CLDImageInfo]? {
        guard let imageInfosDic = getParam(.imageInfos) as? [String : AnyObject] else {
            return nil
        }
        var imageInfos: [String : CLDImageInfo] = [:]
        for key in imageInfosDic.keys {
            if let imgInfo = imageInfosDic[key] as? [String : AnyObject] {
                imageInfos[key] = CLDImageInfo(json: imgInfo)
            }
        }
        return imageInfos
    }
    
    
    // MARK: - Private Helpers
    
    fileprivate func getParam(_ param: SpriteResultKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum SpriteResultKey: CustomStringConvertible {
        case cssUrl, secureCssUrl, imageUrl, jsonUrl, imageInfos
        
        var description: String {
            switch self {
            case .cssUrl:               return "css_url"
            case .secureCssUrl:         return "secure_css_url"
            case .imageUrl:             return "image_url"
            case .jsonUrl:              return "json_url"
            case .imageInfos:           return "image_infos"
            }
        }
    }
}


@objc open class CLDImageInfo: CLDBaseResult {
    
    open var x: Int? {
        return getParam(.x) as? Int
    }
    
    open var y: Int? {
        return getParam(.y) as? Int
    }
    
    open var width: Int? {
        return getParam(.width) as? Int
    }
    
    open var height: Int? {
        return getParam(.height) as? Int
    }    
}

