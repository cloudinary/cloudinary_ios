//
//  CLDDisplayLinkObservers.swift
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

protocol CLDDisplayLinkObserverDelegate: class {
    func displayLinkObserverDidTick(_ linkObserver: CLDDisplayLinkObserver)
}

class CLDDisplayLinkObserver: NSObject {
    
    private(set) var tickerTimestamp  : CFTimeInterval
    private(set) var displayLinkTicker: CADisplayLink?
    
    var delayValue   : Double
    
    weak var delegate: CLDDisplayLinkObserverDelegate?
    
    // MARK: - Init
    init(delegate: CLDDisplayLinkObserverDelegate?) {
        
        self.delayValue        = 0.0
        self.tickerTimestamp   = CFTimeInterval(0.0)
        self.displayLinkTicker = nil
        super.init()
        
        self.delegate = delegate
    }

    deinit {
        stopTicker()
    }

    // MARK: - private methods
    @objc fileprivate func updateTicker(with displayLink: CADisplayLink) {
        
        guard tickerTimestamp != 0.0 else { tickerTimestamp = displayLink.timestamp ; return }
        let delta = displayLink.timestamp - tickerTimestamp
        guard delta >= delayValue else { return }
        delegate?.displayLinkObserverDidTick(self)
        tickerTimestamp = displayLink.timestamp
    }
}

// MARK: - internal methods
extension CLDDisplayLinkObserver {
    
    func startTicker() {
        
        guard displayLinkTicker == nil else { return }
        let displayLink = CADisplayLink(target: self, selector: #selector(updateTicker(with:)))
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.tracking)
        displayLinkTicker = displayLink
    }
    
    func stopTicker() {
        
        displayLinkTicker?.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
        displayLinkTicker?.remove(from: RunLoop.main, forMode: RunLoop.Mode.tracking)
        displayLinkTicker?.invalidate()
        displayLinkTicker = nil
        tickerTimestamp = 0.0
    }
    
    func isValid() -> Bool {
        return displayLinkTicker != nil
    }
}
