//
//  CLDQualityAnalysis.swift
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

@objcMembers open class CLDQualityAnalysis: CLDBaseResult {
    
    open var blockiness: NSNumber? {
        guard let blockiness = getParam(.blockiness) as? NSNumber else { return nil }
        
        return blockiness
    }
    open var chromaSubsampling: NSNumber? {
        guard let chromaSubsampling = getParam(.chromaSubsampling) as? NSNumber else { return nil }
        
        return chromaSubsampling
    }
    open var resolution: NSNumber? {
        guard let resolution = getParam(.resolution) as? NSNumber else { return nil }
        
        return resolution
    }
    open var noise: NSNumber? {
        guard let noise = getParam(.noise) as? NSNumber else { return nil }
        
        return noise
    }
    open var colorScore: NSNumber? {
        guard let colorScore = getParam(.colorScore) as? NSNumber else { return nil }
        
        return colorScore
    }
    open var jpegChroma: NSNumber? {
        guard let jpegChroma = getParam(.jpegChroma) as? NSNumber else { return nil }
        
        return jpegChroma
    }
    open var dct: NSNumber? {
        guard let dct = getParam(.dct) as? NSNumber else { return nil }
        
        return dct
    }
    open var jpegQuality: NSNumber? {
        guard let jpegQuality = getParam(.jpegQuality) as? NSNumber else { return nil }
        
        return jpegQuality
    }
    open var focus: NSNumber? {
        guard let focus = getParam(.focus) as? NSNumber else { return nil }
        
        return focus
    }
    open var saturation: NSNumber? {
        guard let saturation = getParam(.saturation) as? NSNumber else { return nil }
        
        return saturation
    }
    open var contrast: NSNumber? {
        guard let contrast = getParam(.contrast) as? NSNumber else { return nil }
        
        return contrast
    }
    open var exposure: NSNumber? {
        guard let exposure = getParam(.exposure) as? NSNumber else { return nil }
        
        return exposure
    }
    open var lighting: NSNumber? {
        guard let lighting = getParam(.lighting) as? NSNumber else { return nil }
        
        return lighting
    }
    open var pixelScore: NSNumber? {
        guard let pixelScore = getParam(.pixelScore) as? NSNumber else { return nil }
        
        return pixelScore
    }
    
    // MARK: - Private Helpers
    fileprivate func getParam(_ param: CLDQualityAnalysisKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum CLDQualityAnalysisKey: CustomStringConvertible {
        case blockiness, chromaSubsampling, resolution, noise, colorScore, jpegChroma, dct, jpegQuality, focus, saturation, contrast, exposure, lighting, pixelScore
        
        var description: String {
            switch self {
            case .blockiness: return "blockiness"
            case .chromaSubsampling: return "chroma_subsampling"
            case .resolution: return "resolution"
            case .noise: return "noise"
            case .colorScore: return "color_score"
            case .jpegChroma: return "jpeg_chroma"
            case .dct: return "dct"
            case .jpegQuality: return "jpeg_quality"
            case .focus: return "focus"
            case .saturation: return "saturation"
            case .contrast: return "contrast"
            case .exposure: return "exposure"
            case .lighting: return "lighting"
            case .pixelScore: return "pixel_score"
            }
        }
    }
}
