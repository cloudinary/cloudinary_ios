//
//  CLDRenameResult.swift
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

@objcMembers open class CLDRenameResult: CLDBaseResult {
    
    // MARK: - Getters
    
    open var publicId: String? {
        return getParam(.publicId) as? String
    }
    
    open var format: String? {
        return getParam(.format) as? String
    }
    
    open var version: String? {
        guard let version = getParam(.version) else {
            return nil
        }
        return String(describing: version)
    }
    
    open var resourceType: String? {
        return getParam(.resourceType) as? String
    }
    
    open var type: String? {
        return getParam(.urlType) as? String
    }
    
    open var createdAt: String? {
        return getParam(.createdAt) as? String
    }
    
    open var length: Double? {
        return getParam(.length) as? Double
    }
    
    open var width: Int? {
        return getParam(.width) as? Int
    }
    
    open var height: Int? {
        return getParam(.height) as? Int
    }
    
    open var url: String? {
        return getParam(.url) as? String
    }
    
    open var secureUrl: String? {
        return getParam(.secureUrl) as? String
    }
    
    open var nextCursor: String? {
        return getParam(.nextCursor) as? String
    }
    
    open var exif: [String : String]? {
        return getParam(.exif) as? [String : String]
    }
    
    open var metadata: [String : String]? {
        return getParam(.metadata) as? [String : String]
    }
    
    open var faces: AnyObject? {
        return getParam(.faces)
    }
    
    open var colors: AnyObject? {
        return getParam(.colors)
    }
    
    open var derived: CLDDerived? {
        guard let derived = getParam(.derived) as? [String : AnyObject] else {
            return nil
        }
        return CLDDerived(json: derived)
    }
    
    open var tags: [String]? {
        return getParam(.tags) as? [String]
    }
    
    open var moderation: AnyObject? {
        return getParam(.moderation)
    }
    
    open var context: AnyObject? {
        return getParam(.context)
    }
    
    open var phash: String? {
        return getParam(.phash) as? String
    }
    
    open var predominant: CLDPredominant? {
        guard let predominant = getParam(.predominant) as? [String : AnyObject] else {
            return nil
        }
        return CLDPredominant(json: predominant)
    }
    
    open var coordinates: CLDCoordinates? {
        guard let coordinates = getParam(.coordinates) as? [String : AnyObject] else {
            return nil
        }
        return CLDCoordinates(json: coordinates)
    }
    
    open var info: CLDInfo? {
        guard let info = getParam(.info) as? [String : AnyObject] else {
            return nil
        }
        return CLDInfo(json: info)
    }
    
    // MARK: - Private Helpers
    
    fileprivate func getParam(_ param: RenameResultKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }

    fileprivate enum RenameResultKey: CustomStringConvertible {
        case nextCursor, derived, predominant, coordinates
        
        var description: String {
            switch self {
            case .nextCursor:       return "next_cursor"
            case .derived:          return "derived"            
            case .predominant:      return "predominant"
            case .coordinates:      return "coordinates"
            }
        }
    }
}


// MARK: - CLDCoordinates

@objcMembers open class CLDCoordinates: CLDBaseResult {
    
    open var custom: AnyObject? {
        return getParam(.custom)
    }
    
    open var faces: AnyObject? {
        return getParam(.faces)
    }
    
    // MARK: Private Helpers
    
    fileprivate func getParam(_ param: CLDCoordinatesKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum CLDCoordinatesKey: CustomStringConvertible {
        case custom
        
        var description: String {
            switch self {
            case .custom:           return "custom"
            }
        }
    }
}


// MARK: - CLDPredominant

@objcMembers open class CLDPredominant: CLDBaseResult {
    
    open var google: AnyObject? {
        return getParam(.google)
    }
    
    // MARK: - Private Helpers
    
    fileprivate func getParam(_ param: CLDPredominantKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum CLDPredominantKey: CustomStringConvertible {
        case google
        
        var description: String {
            switch self {
            case .google:           return "google"
            }
        }
    }
}


// MARK: - CLDDerived

@objcMembers open class CLDDerived: CLDBaseResult {
    
    open var transformation: String? {
        return getParam(.transformation) as? String
    }
    
    open var format: String? {
        return getParam(.format) as? String
    }
    
    open var length: Double? {
        return getParam(.length) as? Double
    }
    
    open var identifier: String? {
        return getParam(.id) as? String
    }
    
    open var url: String? {
        return getParam(.url) as? String
    }
    
    open var secureUrl: String? {
        return getParam(.secureUrl) as? String
    }
    
    // MARK: - Private Helpers
    
    fileprivate func getParam(_ param: CLDDerivedKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum CLDDerivedKey: CustomStringConvertible {
        case transformation, id
        
        var description: String {
            switch self {
            case .transformation:           return "transformation"
            case .id:                       return "id"
            }
        }
    }
}
