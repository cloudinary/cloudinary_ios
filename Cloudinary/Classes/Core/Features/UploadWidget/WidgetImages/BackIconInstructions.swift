//
//  BackIconInstructions.swift
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

class BackIconInstructions : CLDImageDrawingInstructions {
    
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
        
        let pathBackArrowPath = UIBezierPath()
        pathBackArrowPath.move(to: CGPoint(x: container.minX + 0.83333 * container.width, y: container.minY + 0.45833 * container.height))
        pathBackArrowPath.addLine(to: CGPoint(x: container.minX + 0.32625 * container.width, y: container.minY + 0.45833 * container.height))
        pathBackArrowPath.addLine(to: CGPoint(x: container.minX + 0.55917 * container.width, y: container.minY + 0.22542 * container.height))
        pathBackArrowPath.addLine(to: CGPoint(x: container.minX + 0.50000 * container.width, y: container.minY + 0.16667 * container.height))
        pathBackArrowPath.addLine(to: CGPoint(x: container.minX + 0.16667 * container.width, y: container.minY + 0.50000 * container.height))
        pathBackArrowPath.addLine(to: CGPoint(x: container.minX + 0.50000 * container.width, y: container.minY + 0.83333 * container.height))
        pathBackArrowPath.addLine(to: CGPoint(x: container.minX + 0.55875 * container.width, y: container.minY + 0.77458 * container.height))
        pathBackArrowPath.addLine(to: CGPoint(x: container.minX + 0.32625 * container.width, y: container.minY + 0.54167 * container.height))
        pathBackArrowPath.addLine(to: CGPoint(x: container.minX + 0.83333 * container.width, y: container.minY + 0.54167 * container.height))
        pathBackArrowPath.addLine(to: CGPoint(x: container.minX + 0.83333 * container.width, y: container.minY + 0.45833 * container.height))
        pathBackArrowPath.close()
        pathBackArrowPath.usesEvenOddFillRule = true
        fillColor.setFill()
        pathBackArrowPath.fill()
    }
}

