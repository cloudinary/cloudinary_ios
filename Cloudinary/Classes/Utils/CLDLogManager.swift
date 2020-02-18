//
//  CLDLogManager.swift
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

private let prefix = "[Cloudinary]"

@objc public enum CLDLogLevel: Int {
    case trace, debug, info, warning, error, none
}

private enum LevelText: String {
    case Trace, Debug, Info, Warning, Error, None
}

private func levelTextForLevel(_ logLevel: CLDLogLevel) -> LevelText {
    switch(logLevel) {
        case .trace:    return .Trace
        case .debug:    return .Debug
        case .info:     return .Info
        case .warning:  return .Warning
        case .error:    return .Error
        case .none:     return .None
    }
}

internal struct CLDLogManager {
    
    internal static var minimumLogLevel = CLDLogLevel.none
    
}


internal func printLog<T>(_ logLevel : CLDLogLevel, text: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
    
    if CLDLogManager.minimumLogLevel.rawValue <= logLevel.rawValue {
        let filename = (file as NSString).lastPathComponent
        let levelText = levelTextForLevel(logLevel).rawValue
        print("\(prefix):[\(levelText)]: \(filename).\(function)[\(line)]: \(text)")
    }
}

