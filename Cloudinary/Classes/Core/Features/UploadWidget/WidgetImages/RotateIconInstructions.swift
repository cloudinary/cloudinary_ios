//
//  RotateIconInstructions.swift
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

class RotateIconInstructions : CLDImageDrawingInstructions {
    
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
        
       let pathRotatePath = UIBezierPath()
        pathRotatePath.move(to: CGPoint(x: container.minX + 0.30583 * container.width, y: container.minY + 0.26708 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.03583 * container.width, y: container.minY + 0.53750 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.30625 * container.width, y: container.minY + 0.80750 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.57667 * container.width, y: container.minY + 0.53750 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.30583 * container.width, y: container.minY + 0.26708 * container.height))
        pathRotatePath.close()
        pathRotatePath.move(to: CGPoint(x: container.minX + 0.15375 * container.width, y: container.minY + 0.53750 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.30625 * container.width, y: container.minY + 0.38500 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.45833 * container.width, y: container.minY + 0.53750 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.30583 * container.width, y: container.minY + 0.69000 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.15375 * container.width, y: container.minY + 0.53750 * container.height))
        pathRotatePath.close()
        pathRotatePath.move(to: CGPoint(x: container.minX + 0.80667 * container.width, y: container.minY + 0.27667 * container.height))
        pathRotatePath.addCurve(to: CGPoint(x: container.minX + 0.54167 * container.width, y: container.minY + 0.16667 * container.height), controlPoint1: CGPoint(x: container.minX + 0.73375 * container.width, y: container.minY + 0.20333 * container.height), controlPoint2: CGPoint(x: container.minX + 0.63750 * container.width, y: container.minY + 0.16667 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.54167 * container.width, y: container.minY + 0.03167 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.36500 * container.width, y: container.minY + 0.20833 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.54167 * container.width, y: container.minY + 0.38500 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.54167 * container.width, y: container.minY + 0.25000 * container.height))
        pathRotatePath.addCurve(to: CGPoint(x: container.minX + 0.74792 * container.width, y: container.minY + 0.33542 * container.height), controlPoint1: CGPoint(x: container.minX + 0.61625 * container.width, y: container.minY + 0.25000 * container.height), controlPoint2: CGPoint(x: container.minX + 0.69083 * container.width, y: container.minY + 0.27833 * container.height))
        pathRotatePath.addCurve(to: CGPoint(x: container.minX + 0.74792 * container.width, y: container.minY + 0.74792 * container.height), controlPoint1: CGPoint(x: container.minX + 0.86167 * container.width, y: container.minY + 0.44917 * container.height), controlPoint2: CGPoint(x: container.minX + 0.86167 * container.width, y: container.minY + 0.63417 * container.height))
        pathRotatePath.addCurve(to: CGPoint(x: container.minX + 0.54167 * container.width, y: container.minY + 0.83333 * container.height), controlPoint1: CGPoint(x: container.minX + 0.69083 * container.width, y: container.minY + 0.80500 * container.height), controlPoint2: CGPoint(x: container.minX + 0.61625 * container.width, y: container.minY + 0.83333 * container.height))
        pathRotatePath.addCurve(to: CGPoint(x: container.minX + 0.42333 * container.width, y: container.minY + 0.80792 * container.height), controlPoint1: CGPoint(x: container.minX + 0.50125 * container.width, y: container.minY + 0.83333 * container.height), controlPoint2: CGPoint(x: container.minX + 0.46083 * container.width, y: container.minY + 0.82458 * container.height))
        pathRotatePath.addLine(to: CGPoint(x: container.minX + 0.36125 * container.width, y: container.minY + 0.87000 * container.height))
        pathRotatePath.addCurve(to: CGPoint(x: container.minX + 0.54167 * container.width, y: container.minY + 0.91667 * container.height), controlPoint1: CGPoint(x: container.minX + 0.41750 * container.width, y: container.minY + 0.90083 * container.height), controlPoint2: CGPoint(x: container.minX + 0.47958 * container.width, y: container.minY + 0.91667 * container.height))
        pathRotatePath.addCurve(to: CGPoint(x: container.minX + 0.80667 * container.width, y: container.minY + 0.80667 * container.height), controlPoint1: CGPoint(x: container.minX + 0.63750 * container.width, y: container.minY + 0.91667 * container.height), controlPoint2: CGPoint(x: container.minX + 0.73375 * container.width, y: container.minY + 0.88000 * container.height))
        pathRotatePath.addCurve(to: CGPoint(x: container.minX + 0.80667 * container.width, y: container.minY + 0.27667 * container.height), controlPoint1: CGPoint(x: container.minX + 0.95333 * container.width, y: container.minY + 0.66042 * container.height), controlPoint2: CGPoint(x: container.minX + 0.95333 * container.width, y: container.minY + 0.42292 * container.height))
        pathRotatePath.close()
        pathRotatePath.usesEvenOddFillRule = true
        fillColor.setFill()
        pathRotatePath.fill()
    }
}

