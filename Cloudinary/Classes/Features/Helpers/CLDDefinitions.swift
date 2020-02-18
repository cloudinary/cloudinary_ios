//
//  CLDDefinitions.swift
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

// MARK: URL Type

@objc public enum CLDType: Int, CustomStringConvertible {
    case upload, fetch, facebook, twitter, twitterName, sprite, `private`, authenticated
    
    public var description: String {
        get {
            switch self {
            case .upload:               return "upload"
            case .facebook:             return "facebook"
            case .fetch:                return "fetch"
            case .twitter:              return "twitter"
            case .twitterName:          return "twitter_name"
            case .sprite:               return "sprite"
            case .private:              return "private"
            case .authenticated:        return "authenticated"
            }
        }
    }
}

// MARK: Resource Type

@objc public enum CLDUrlResourceType: Int, CustomStringConvertible {
    case image, raw, video, auto
    
    public var description: String {
        get {
            switch self {
            case .image:        return "image"
            case .raw:          return "raw"
            case .video:        return "video"
            case .auto:         return "auto"
            }
        }
    }
}

// MARK: - Upload Params

@objc public enum CLDModeration: Int, CustomStringConvertible {
    case manual, webpurify
    
    public var description: String {
        get {
            switch self {
            case .manual:           return "manual"
            case .webpurify:        return "webpurify"
            }
        }
    }
}

// MARK: - Text Params

@objc public enum CLDFontWeight: Int, CustomStringConvertible {
    case normal, bold
    
    public var description: String {
        get {
            switch self {
            case .normal:           return "normal"
            case .bold:             return "bold"
            }
        }
    }
}

@objc public enum CLDFontStyle: Int, CustomStringConvertible {
    case normal, italic
    
    public var description: String {
        get {
            switch self {
            case .normal:           return "normal"
            case .italic:           return "italic"
            }
        }
    }
}

@objc public enum CLDTextDecoration: Int, CustomStringConvertible {
    case none, underline
    
    public var description: String {
        get {
            switch self {
            case .none:             return "none"
            case .underline:        return "underline"
            }
        }
    }
}

