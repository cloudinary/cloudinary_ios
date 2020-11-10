//
//  CLDCropScrollView.swift
//  ProjectCLDWidgetEditViewController
//
//  Created by Arkadi Yoskovitz on 8/17/20.
//  Copyright © 2020 Gini-Apps LTD. All rights reserved.
//

import UIKit
public typealias CLDTouchHandler = () -> Void

/*
 Subclassing UIScrollView was necessary in order to directly capture
 touch events that weren't otherwise accessible via UIGestureRecognizer objects.
 */
@objc
@objcMembers
public class CLDCropScrollView : UIScrollView {
    
    public var touchesBegan    :CLDTouchHandler?
    public var touchesCancelled:CLDTouchHandler?
    public var touchesEnded    :CLDTouchHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureInitialState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureInitialState()
    }
    
    private func configureInitialState() {
        
        self.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.alwaysBounceHorizontal = true
        self.alwaysBounceVertical   = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator   = false
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let handler = touchesBegan {
            handler()
        }
        super.touchesBegan(touches, with: event)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let handler = touchesEnded {
            handler()
        }
        super.touchesEnded(touches, with: event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let handler = touchesEnded {
            handler()
        }
        super.touchesCancelled(touches, with: event)
    }
}
