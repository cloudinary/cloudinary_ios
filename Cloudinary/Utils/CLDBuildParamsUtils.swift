//
//  CLDBuildParamsUtils.swift
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


// MARK: - Build String Params

internal func buildCoordinatesString(_ coordinates: [CLDCoordinate]) -> String {
    return coordinates.map{$0.description}.joined(separator: "|")
}

internal func buildEagerString(_ eager: [CLDTransformation]) -> String {
    return eager.map {$0.asString() ?? ""}
            .filter {!$0.isEmpty}
            .joined(separator: "|")
}

internal func buildContextString(_ context: [String : String]) -> String {
    return context.map{"\($0)=\(encodeContextValue($1))"}.joined(separator: "|")
}

internal func encodeContextValue(_ value: String) -> String {
    return value.replacingOccurrences(of: "|", with: "\\|").replacingOccurrences(of: "=", with: "\\=")
}

internal func buildHeadersString(_ headers: [String : String]) -> String {    
    return headers.map{"\($0): \($1)\\n"}.joined(separator: "")
}
