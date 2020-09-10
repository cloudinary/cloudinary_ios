//
//  DoneIconInstractions.swift
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

class DoneIconInstractions : CLDImageDrawingInstractions {
    
    var targetSize : CGSize
    
    // MARK: - Initialization
    init(targetSize size: CGSize = CGSize(width: 24.0, height: 24.0)) {
        self.targetSize = size
    }
    
    deinit {
        
    }
    
    // MARK: - draw
    func draw(in context: CGContext) {
        
        let container = CGRect(origin: .zero, size: targetSize)
        
        let pathDonePath = UIBezierPath()
        pathDonePath.move(to: CGPoint(x: container.minX + 0.37500 * container.width, y: container.minY + 0.67500 * container.height))
        pathDonePath.addLine(to: CGPoint(x: container.minX + 0.20000 * container.width, y: container.minY + 0.50000 * container.height))
        pathDonePath.addLine(to: CGPoint(x: container.minX + 0.14167 * container.width, y: container.minY + 0.55833 * container.height))
        pathDonePath.addLine(to: CGPoint(x: container.minX + 0.37500 * container.width, y: container.minY + 0.79167 * container.height))
        pathDonePath.addLine(to: CGPoint(x: container.minX + 0.87500 * container.width, y: container.minY + 0.29167 * container.height))
        pathDonePath.addLine(to: CGPoint(x: container.minX + 0.81667 * container.width, y: container.minY + 0.23333 * container.height))
        pathDonePath.addLine(to: CGPoint(x: container.minX + 0.37500 * container.width, y: container.minY + 0.67500 * container.height))
        pathDonePath.close()
        pathDonePath.usesEvenOddFillRule = true
        CLDStyleKitName.fillColor.setFill()
        pathDonePath.fill()
    }
}

