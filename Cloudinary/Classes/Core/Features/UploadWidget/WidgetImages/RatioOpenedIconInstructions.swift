//
//  RatioOpenedIconInstructions.swift
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

class RatioOpenedIconInstructions : CLDImageDrawingInstructions {
    
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
        
        let pathRatioOpenedPath = UIBezierPath()
        pathRatioOpenedPath.move(to: CGPoint(x: container.minX + 0.75000 * container.width, y: container.minY + 0.33333 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.70833 * container.width, y: container.minY + 0.33333 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.70833 * container.width, y: container.minY + 0.25000 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.50000 * container.width, y: container.minY + 0.04167 * container.height), controlPoint1: CGPoint(x: container.minX + 0.70833 * container.width, y: container.minY + 0.13500 * container.height), controlPoint2: CGPoint(x: container.minX + 0.61500 * container.width, y: container.minY + 0.04167 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.29167 * container.width, y: container.minY + 0.25000 * container.height), controlPoint1: CGPoint(x: container.minX + 0.38500 * container.width, y: container.minY + 0.04167 * container.height), controlPoint2: CGPoint(x: container.minX + 0.29167 * container.width, y: container.minY + 0.13500 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.29167 * container.width, y: container.minY + 0.25000 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.37500 * container.width, y: container.minY + 0.25000 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.37500 * container.width, y: container.minY + 0.25000 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.50000 * container.width, y: container.minY + 0.12500 * container.height), controlPoint1: CGPoint(x: container.minX + 0.37500 * container.width, y: container.minY + 0.18083 * container.height), controlPoint2: CGPoint(x: container.minX + 0.43083 * container.width, y: container.minY + 0.12500 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.62500 * container.width, y: container.minY + 0.25000 * container.height), controlPoint1: CGPoint(x: container.minX + 0.56917 * container.width, y: container.minY + 0.12500 * container.height), controlPoint2: CGPoint(x: container.minX + 0.62500 * container.width, y: container.minY + 0.18083 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.62500 * container.width, y: container.minY + 0.33333 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.25000 * container.width, y: container.minY + 0.33333 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.16667 * container.width, y: container.minY + 0.41667 * container.height), controlPoint1: CGPoint(x: container.minX + 0.20417 * container.width, y: container.minY + 0.33333 * container.height), controlPoint2: CGPoint(x: container.minX + 0.16667 * container.width, y: container.minY + 0.37083 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.16667 * container.width, y: container.minY + 0.83333 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.25000 * container.width, y: container.minY + 0.91667 * container.height), controlPoint1: CGPoint(x: container.minX + 0.16667 * container.width, y: container.minY + 0.87917 * container.height), controlPoint2: CGPoint(x: container.minX + 0.20417 * container.width, y: container.minY + 0.91667 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.75000 * container.width, y: container.minY + 0.91667 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.83333 * container.width, y: container.minY + 0.83333 * container.height), controlPoint1: CGPoint(x: container.minX + 0.79583 * container.width, y: container.minY + 0.91667 * container.height), controlPoint2: CGPoint(x: container.minX + 0.83333 * container.width, y: container.minY + 0.87917 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.83333 * container.width, y: container.minY + 0.41667 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.75000 * container.width, y: container.minY + 0.33333 * container.height), controlPoint1: CGPoint(x: container.minX + 0.83333 * container.width, y: container.minY + 0.37083 * container.height), controlPoint2: CGPoint(x: container.minX + 0.79583 * container.width, y: container.minY + 0.33333 * container.height))
        pathRatioOpenedPath.close()
        pathRatioOpenedPath.move(to: CGPoint(x: container.minX + 0.75000 * container.width, y: container.minY + 0.83333 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.25000 * container.width, y: container.minY + 0.83333 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.25000 * container.width, y: container.minY + 0.41667 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.75000 * container.width, y: container.minY + 0.41667 * container.height))
        pathRatioOpenedPath.addLine(to: CGPoint(x: container.minX + 0.75000 * container.width, y: container.minY + 0.83333 * container.height))
        pathRatioOpenedPath.close()
        pathRatioOpenedPath.move(to: CGPoint(x: container.minX + 0.50000 * container.width, y: container.minY + 0.70833 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.58333 * container.width, y: container.minY + 0.62500 * container.height), controlPoint1: CGPoint(x: container.minX + 0.54583 * container.width, y: container.minY + 0.70833 * container.height), controlPoint2: CGPoint(x: container.minX + 0.58333 * container.width, y: container.minY + 0.67083 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.50000 * container.width, y: container.minY + 0.54167 * container.height), controlPoint1: CGPoint(x: container.minX + 0.58333 * container.width, y: container.minY + 0.57917 * container.height), controlPoint2: CGPoint(x: container.minX + 0.54583 * container.width, y: container.minY + 0.54167 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.41667 * container.width, y: container.minY + 0.62500 * container.height), controlPoint1: CGPoint(x: container.minX + 0.45417 * container.width, y: container.minY + 0.54167 * container.height), controlPoint2: CGPoint(x: container.minX + 0.41667 * container.width, y: container.minY + 0.57917 * container.height))
        pathRatioOpenedPath.addCurve(to: CGPoint(x: container.minX + 0.50000 * container.width, y: container.minY + 0.70833 * container.height), controlPoint1: CGPoint(x: container.minX + 0.41667 * container.width, y: container.minY + 0.67083 * container.height), controlPoint2: CGPoint(x: container.minX + 0.45417 * container.width, y: container.minY + 0.70833 * container.height))
        pathRatioOpenedPath.close()
        pathRatioOpenedPath.usesEvenOddFillRule = true
        fillColor.setFill()
        pathRatioOpenedPath.fill()
    }
}

