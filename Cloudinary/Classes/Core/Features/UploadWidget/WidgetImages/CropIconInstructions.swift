//
//  CropIconInstructions.swift
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

class CropIconInstructions : CLDImageDrawingInstructions {
    
    var targetSize : CGSize
    var fillColor : UIColor
    
    // MARK: - Initialization
    init(targetSize size: CGSize = CGSize(width: 24.0, height: 24.0), fillColor: UIColor = .white) {
        self.targetSize = size
        self.fillColor = fillColor
    }
    
    // MARK: - draw
    func draw(in context: CGContext) {
        
        let container = CGRect(origin: .zero, size: targetSize)
        
        let pathCropPath = UIBezierPath()
        pathCropPath.move(to: CGPoint(x: container.minX + 0.70833 * container.width, y: container.minY + 0.62500 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.79167 * container.width, y: container.minY + 0.62500 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.79167 * container.width, y: container.minY + 0.29167 * container.height))
        pathCropPath.addCurve(to: CGPoint(x: container.minX + 0.70833 * container.width, y: container.minY + 0.20833 * container.height), controlPoint1: CGPoint(x: container.minX + 0.79167 * container.width, y: container.minY + 0.24583 * container.height), controlPoint2: CGPoint(x: container.minX + 0.75417 * container.width, y: container.minY + 0.20833 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.37500 * container.width, y: container.minY + 0.20833 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.37500 * container.width, y: container.minY + 0.29167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.70833 * container.width, y: container.minY + 0.29167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.70833 * container.width, y: container.minY + 0.62500 * container.height))
        pathCropPath.close()
        pathCropPath.move(to: CGPoint(x: container.minX + 0.29167 * container.width, y: container.minY + 0.70833 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.29167 * container.width, y: container.minY + 0.04167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.20833 * container.width, y: container.minY + 0.04167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.20833 * container.width, y: container.minY + 0.20833 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.04167 * container.width, y: container.minY + 0.20833 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.04167 * container.width, y: container.minY + 0.29167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.20833 * container.width, y: container.minY + 0.29167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.20833 * container.width, y: container.minY + 0.70833 * container.height))
        pathCropPath.addCurve(to: CGPoint(x: container.minX + 0.29167 * container.width, y: container.minY + 0.79167 * container.height), controlPoint1: CGPoint(x: container.minX + 0.20833 * container.width, y: container.minY + 0.75417 * container.height), controlPoint2: CGPoint(x: container.minX + 0.24583 * container.width, y: container.minY + 0.79167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.70833 * container.width, y: container.minY + 0.79167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.70833 * container.width, y: container.minY + 0.95833 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.79167 * container.width, y: container.minY + 0.95833 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.79167 * container.width, y: container.minY + 0.79167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.95833 * container.width, y: container.minY + 0.79167 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.95833 * container.width, y: container.minY + 0.70833 * container.height))
        pathCropPath.addLine(to: CGPoint(x: container.minX + 0.29167 * container.width, y: container.minY + 0.70833 * container.height))
        pathCropPath.close()
        pathCropPath.usesEvenOddFillRule = true
        fillColor.setFill()
        pathCropPath.fill()
    }
}

