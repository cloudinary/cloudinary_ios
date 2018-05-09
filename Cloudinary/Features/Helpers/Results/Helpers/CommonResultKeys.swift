//
//  CommonResultKeys.swift
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

internal enum CommonResultKeys: CustomStringConvertible {
    case publicId, format, version, resourceType, urlType, createdAt, length, width, height, x, y, url, secureUrl, exif, metadata, faces, colors, tags, moderation, context, phash, info, accessControl, eager
    
    var description: String {
        switch self {
        case .publicId:         return "public_id"
        case .format:           return "format"
        case .version:          return "version"
        case .resourceType:     return "resource_type"
        case .urlType:          return "type"
        case .createdAt:        return "created_at"
        case .length:           return "bytes"
        case .width:            return "width"
        case .height:           return "height"
        case .x:                return "x"
        case .y:                return "y"
        case .url:              return "url"
        case .secureUrl:        return "secure_url"
        case .exif:             return "exif"
        case .metadata:         return "image_metadata"
        case .faces:            return "faces"
        case .colors:           return "colors"
        case .tags:             return "tags"
        case .moderation:       return "moderation"
        case .context:          return "context"
        case .phash:            return "phash"
        case .info:             return "info"
        case .eager:            return "eager"
        case .accessControl:    return "access_control"
        }
    }
}
