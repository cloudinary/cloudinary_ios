//
//  CLDVideoControlsView.swift
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

protocol CLDVideoControlsViewDelegate: class {
    func playPressedOnVideoControls (_ videoControls: CLDVideoControlsView)
    func pausePressedOnVideoControls(_ videoControls: CLDVideoControlsView)
}

class CLDVideoControlsView: UIControl {
 
      
    private(set) var playPauseButton  : UIButton!
    private(set) var visibilityTimer  : CLDDisplayLinkObserver!
    
    weak         var delegate         : CLDVideoControlsViewDelegate?
    
    private(set) var currentState         : CLDVideoControlsState!
    private(set) var shownAndPlayingState : CLDVideoControlsState!
    private(set) var shownAndPausedState  : CLDVideoControlsState!
    private(set) var hiddenAndPlayingState: CLDVideoControlsState!
    private(set) var hiddenAndPausedState : CLDVideoControlsState!
    
    private let transparentBackgroundColor = UIColor.black.withAlphaComponent(0.5)
    private let controlTransitionsDuration = 0.2
    private let controlAppearanceDuration  = 2.5
    
    // MARK: - init
    init(frame: CGRect, delegate: CLDVideoControlsViewDelegate?) {
    
        self.delegate  = delegate
        
        super.init(frame: frame)
        
        // handle state
        shownAndPlayingState  = CLDVideoShownAndPlayingState (controlsView: self)
        shownAndPausedState   = CLDVideoShownAndPausedState  (controlsView: self)
        hiddenAndPlayingState = CLDVideoHiddenAndPlayingState(controlsView: self)
        hiddenAndPausedState  = CLDVideoHiddenAndPausedState (controlsView: self)
        currentState          = shownAndPlayingState
        
        // initial timer state
        visibilityTimer = CLDDisplayLinkObserver(delegate: self)
        startTimer()
        
        addTarget(self, action: #selector(backgroundPressed), for: .touchUpInside)
        
        createUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func resetControls() {
        
        currentState = shownAndPlayingState
        showControls()
        playVideo()
    }
}

// MARK: - handle events
extension CLDVideoControlsView {
    
    @objc private func backgroundPressed() {
        currentState.backgroundPressed()
    }
    
    @objc private func playPausePressed() {
        currentState.playPausePressed()
    }
    
    func videoEnded() {
        currentState.videoEnded()
    }
    
    func pauseVideo() {
        
        delegate?.pausePressedOnVideoControls(self)
        playPauseButton.setTitle("▶", for: .normal)
        stopTimer()
    }
    
    func playVideo() {
        
        delegate?.playPressedOnVideoControls(self)
        playPauseButton.setTitle("||", for: .normal)
        startTimer()
    }
}

// MARK: - handle state
extension CLDVideoControlsView {
    
    func setNewState(newState: CLDVideoControlsState) {
        currentState = newState
    }
}

// MARK: - display link timer
extension CLDVideoControlsView: CLDDisplayLinkObserverDelegate {
    
    func startTimer() {
        visibilityTimer.stopTicker()
        visibilityTimer.delayValue = controlAppearanceDuration
        visibilityTimer.startTicker()
    }
    
    func stopTimer() {
        visibilityTimer.stopTicker()
    }
    
    func displayLinkObserverDidTick(_ linkObserver: CLDDisplayLinkObserver) {
        currentState.timerFinished()
    }
}

// MARK: - UI
extension CLDVideoControlsView {
    
    private func createUI() {
        
        backgroundColor = transparentBackgroundColor
        
        playPauseButton = UIButton(type: .custom)
        playPauseButton.accessibilityIdentifier = "videoViewPausePlayButton"
        playPauseButton.setTitle("||", for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPausePressed), for: .touchUpInside)
        playPauseButton.titleLabel?.font = playPauseButton.titleLabel?.font.withSize(40)
        addSubview(playPauseButton)
        playPauseButton.cld_addConstraintsToCenter(self)
    }
    
    func showControls() {
        
        UIView.animate(withDuration: controlTransitionsDuration, animations: {
            
            self.backgroundColor       = self.transparentBackgroundColor
            self.playPauseButton.alpha = 1.0
        })
    }
    
    func hideControls() {
        
        // we dont set the background alpha to 0 in order to keep getting touch events
        UIView.animate(withDuration: controlTransitionsDuration, animations: {
            
            self.backgroundColor       = UIColor.clear
            self.playPauseButton.alpha = 0.0
        })
    }
}
