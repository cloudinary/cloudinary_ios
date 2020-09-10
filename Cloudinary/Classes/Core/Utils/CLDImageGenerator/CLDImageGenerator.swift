//
//  CLDImageGenerator.swift
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

import UIKit

// MARK: - CLDImageDrawingInstractions
protocol CLDImageDrawingInstractions {
    
    var targetSize: CGSize { get }
    func draw(in context: CGContext)
}

// MARK: - CLDImageGenerator
class CLDImageGenerator: NSObject {
    
    class CLDGeneratableImage {
        
        let instractions: CLDImageDrawingInstractions
        
        init(_ drawingInstractions: CLDImageDrawingInstractions) {
            self.instractions = drawingInstractions
        }
        
        /// Draws an image according to instractions
        final func draw() -> UIImage? {
            
            UIGraphicsBeginImageContextWithOptions(instractions.targetSize, false, UIScreen.main.scale)
            
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            
            context.saveGState()
            instractions.draw(in: context)
            context.restoreGState()
            
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            
            UIGraphicsEndImageContext()
            
            return image
        }
    }
    
    /// Generates an image based on an instractions object
    ///
    /// - Parameter instractions: Drawing instractions used to generate an image
    /// - Parameter direction       : The direction of the generated image
    static func generateImage(from instractions: CLDImageDrawingInstractions, for direction: CLDImageGenerator.Direction = .up) -> UIImage? {
        
        guard let workImage = CLDGeneratableImage(instractions).draw() else { return nil }
        
        return UIImage(cgImage: workImage.cgImage!, scale: workImage.scale, orientation: direction.imageOrientation)
    }
}

// MARK: - CLDImageGenerator
extension CLDImageGenerator {
    
    enum Direction: Int {
        
        case left
        case right
        case up
        case down
    }
}

// MARK: - CLDImageGenerator.Direction
extension CLDImageGenerator.Direction {
    
    var imageOrientation: UIImage.Orientation {
        
        switch self {
        case .up   : return .up
        case .down : return .down
        case .left : return .left
        case .right: return .right
        }
    }
}
