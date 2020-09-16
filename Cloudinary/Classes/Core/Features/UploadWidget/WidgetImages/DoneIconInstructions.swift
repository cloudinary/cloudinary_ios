//
//  DoneIconInstructions.swift
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

class DoneIconInstructions : CLDImageDrawingInstructions {
    
    var targetSize         : CGSize
    var fillColor          : UIColor
    var ovalBackgroundColor: UIColor
        
    // MARK: - Initialization
    init(targetSize size: CGSize = CGSize(width: 60.0, height: 60.0), fillColor: UIColor = .white, ovalBackgroundColor: UIColor = UIColor(red: 38.0/255, green: 91.0/255, blue: 220.0/255, alpha: 1.0)) {
        self.targetSize          = size
        self.fillColor           = fillColor
        self.ovalBackgroundColor = ovalBackgroundColor
    }
    
    // MARK: - draw
    func draw(in context: CGContext) {
        
        let container  = CGRect(origin: .zero, size: targetSize)
        let vContainer = CGRect(origin: .zero, size: CGSize(width: targetSize.width/2, height: targetSize.height/2))
        
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }

        // Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: container.minX + fastFloor(container.width * 0.00000 + 0.5), y: container.minY + fastFloor(container.height * 0.00000 + 0.5), width: fastFloor(container.width * 1.00000 + 0.5) - fastFloor(container.width * 0.00000 + 0.5), height: fastFloor(container.height * 1.00000 + 0.5) - fastFloor(container.height * 0.00000 + 0.5)))
        ovalBackgroundColor.setFill()
        ovalPath.fill()
        
        //// pathDone Drawing
        let pathDonePath = UIBezierPath()
        pathDonePath.move(to: CGPoint(x: vContainer.midX + 0.37500 * vContainer.width, y: vContainer.midY + 0.67500 * vContainer.height))
        pathDonePath.addLine(to: CGPoint(x: vContainer.midX + 0.20000 * vContainer.width, y: vContainer.midY + 0.50000 * vContainer.height))
        pathDonePath.addLine(to: CGPoint(x: vContainer.midX + 0.14167 * vContainer.width, y: vContainer.midY + 0.55833 * vContainer.height))
        pathDonePath.addLine(to: CGPoint(x: vContainer.midX + 0.37500 * vContainer.width, y: vContainer.midY + 0.79167 * vContainer.height))
        pathDonePath.addLine(to: CGPoint(x: vContainer.midX + 0.87500 * vContainer.width, y: vContainer.midY + 0.29167 * vContainer.height))
        pathDonePath.addLine(to: CGPoint(x: vContainer.midX + 0.81667 * vContainer.width, y: vContainer.midY + 0.23333 * vContainer.height))
        pathDonePath.addLine(to: CGPoint(x: vContainer.midX + 0.37500 * vContainer.width, y: vContainer.midY + 0.67500 * vContainer.height))
        pathDonePath.close()
        pathDonePath.usesEvenOddFillRule = true
        fillColor.setFill()
        pathDonePath.fill()
    }
}

