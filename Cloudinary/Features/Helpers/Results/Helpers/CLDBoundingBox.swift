//
//  CLDBoundingBox.swift
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

@objcMembers open class CLDBoundingBox: CLDBaseResult {
    
    open var topLeft: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDBoundingBoxJsonKey.topLeft))
    }
    
    open var size: CGSize? {
        return CLDBoundingBox.parseSize(resultJson, key: String(describing: CLDBoundingBoxJsonKey.size))
    }
    
    internal static func parsePoint(_ json: [String : AnyObject], key: String) -> CGPoint? {
        guard let
            point = json[key] as? [String : Double],
            let x = point[CommonResultKeys.x.description],
            let y = point[CommonResultKeys.y.description] else {
                return nil
        }
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    internal static func parseSize(_ json: [String : AnyObject], key: String) -> CGSize? {
        guard let
            point = json[key] as? [String : Double],
            let width = point[CommonResultKeys.width.description],
            let height = point[CommonResultKeys.height.description] else {
                return nil
        }
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    // MARK: - Private Helpers
    
    fileprivate func getParam(_ param: CLDBoundingBoxJsonKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum CLDBoundingBoxJsonKey: CustomStringConvertible {
        case topLeft, size
        
        var description: String {
            switch self {
            case .topLeft:  return "tl"
            case .size:     return "size"
            }
        }
    }
}
