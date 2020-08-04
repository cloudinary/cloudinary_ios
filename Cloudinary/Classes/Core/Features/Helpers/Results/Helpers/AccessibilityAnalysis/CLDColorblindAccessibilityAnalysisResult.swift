//
//  CLDColorblindAccessibilityAnalysisResult.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
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

@objcMembers open class CLDColorblindAccessibilityAnalysisResult: CLDBaseResult {
    
    open var distinctColors: Double? {
        guard let distinctColors = getParam(.distinctColors) as? Double else { return nil }
        
        return distinctColors
    }
    open var distinctEdges: Double? {
        guard let distinctEdges = getParam(.distinctEdges) as? Double else { return nil }
        
        return distinctEdges
    }
    open var mostIndistinctPair: [String]? {
        guard let mostIndistinctPair = getParam(.mostIndistinctPair) as? [String] else { return nil }
        
        return mostIndistinctPair
    }
    
    // MARK: - Private Helpers
    fileprivate func getParam(_ param: CLDColorblindAccessibilityAnalysisResultKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum CLDColorblindAccessibilityAnalysisResultKey: CustomStringConvertible {
        case distinctColors, distinctEdges, mostIndistinctPair
        
        var description: String {
            switch self {
            case .distinctColors    : return "distinct_colors"
            case .distinctEdges     : return "distinct_edges"
            case .mostIndistinctPair: return "most_indistinct_pair"
            }
        }
    }
}
