//
//  CLDCropOverlayView.swift
//  ProjectCLDWidgetEditViewController
//
//  Created by Arkadi Yoskovitz on 8/17/20.
//  Copyright © 2020 Gini-Apps LTD. All rights reserved.
//

import UIKit

private let kCLDCropOverLayerPlaceholder = CGFloat(00.0);
private let kCLDCropOverLayerCornerWidth = CGFloat(20.0);

@objc
@objcMembers
public class CLDCropOverlayView : UIView
{
    // MARK: -
    public override var frame: CGRect { didSet { layoutLinesIfNeeded() } }
    
    public var gridColor : UIColor { didSet { layoutLinesIfNeeded() } }
    public var knobColor : UIColor { didSet { layoutLinesIfNeeded() } }
    
    // MARK: - Public Properties
    
    /**
     Hides the interior grid lines, sans animation.
     */
    public var isGridHidden : Bool {
        set { setGridlines(hidden: newValue, animted: false) }
        get { areGridLinesHidden }
    }
    
    /**
     Add/Remove the interior horizontal grid lines.
     */
    public var shouldDisplayHorizontalGridLines : Bool {
        set { setDisplayHorizontalGridLines(newValue) }
        get { displayGridLinesHorizontal }
    }
    
    /**
     Add/Remove the interior vertical grid lines.
     */
    public var shouldDisplayVerticalGridLines : Bool {
        set { setDisplayVerticalGridLines(newValue) }
        get { displayGridLinesVertical }
    }
    
    // MARK: - Private Properties
    
    private var areGridLinesHidden        : Bool
    private var displayGridLinesHorizontal: Bool
    private var displayGridLinesVertical  : Bool
    
    private var gridLinesHorizontal : [UIView]
    private var gridLinesVertical   : [UIView]
    
    private var outerLineViews       : [UIView] // top, right, bottom, left
    
    private var    topLeftLineViews  : [UIView] // vertical, horizontal
    private var bottomLeftLineViews  : [UIView]
    private var bottomRightLineViews : [UIView]
    private var    topRightLineViews : [UIView]
    
    // MARK: - init
    public override init(frame: CGRect) {
        self.areGridLinesHidden = false
        
        self.displayGridLinesVertical   = true
        self.displayGridLinesHorizontal = true
        
        self.gridColor = UIColor.white
        self.knobColor = UIColor.white
        
        self.gridLinesHorizontal = [UIView]()
        self.gridLinesVertical   = [UIView]()
        
        self.outerLineViews    = [UIView]() //top, right, bottom, left
        self.topLeftLineViews  = [UIView]()
        self.topRightLineViews = [UIView]()
        self.bottomLeftLineViews  = [UIView]()
        self.bottomRightLineViews = [UIView]()
        
        super.init(frame: frame)
        
        self.clipsToBounds = false
        
        self.outerLineViews.append(contentsOf: [
            createLineView(background: gridColor),
            createLineView(background: gridColor),
            createLineView(background: gridColor),
            createLineView(background: gridColor)
        ])
        
        self.topLeftLineViews.append(contentsOf: [
            createLineView(background: gridColor),
            createLineView(background: gridColor)
        ])
        self.topRightLineViews.append(contentsOf: [
            createLineView(background: gridColor),
            createLineView(background: gridColor)
        ])
        self.bottomLeftLineViews.append(contentsOf: [
            createLineView(background: gridColor),
            createLineView(background: gridColor)
        ])
        self.bottomRightLineViews.append(contentsOf: [
            createLineView(background: gridColor),
            createLineView(background: gridColor)
        ])
        self.setDisplayHorizontalGridLines(true)
        self.setDisplayVerticalGridLines(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutLinesIfNeeded()
    }
    
    // MARK: -
    /**
     Shows and hides the interior grid lines with an optional crossfade animation.
     */
    public func setGridlines(hidden: Bool, animted: Bool) {
        
        areGridLinesHidden = hidden;
        
        let block : () -> Void = {
            self.gridLinesHorizontal.forEach { $0.alpha = hidden ? 0.0 : 1.0 }
            self.gridLinesVertical.forEach { $0.alpha = hidden ? 0.0 : 1.0 }
        }
        
        switch animted {
        case true : UIView.animate(withDuration: hidden ? 0.35 : 0.2) { block() }
        case false: block()
        }
    }
    
    // MARK: - Private setter actions
    private func setDisplayHorizontalGridLines(_ display: Bool) {
        
        displayGridLinesHorizontal = display
        
        gridLinesHorizontal.forEach { $0.removeFromSuperview() }
        
        gridLinesHorizontal.removeAll()
        
        if displayGridLinesHorizontal {
            gridLinesHorizontal.append(contentsOf: [
                createLineView(background: gridColor),
                createLineView(background: gridColor)
            ])
        }
        setNeedsDisplay()
    }
    
    private func setDisplayVerticalGridLines(_ display: Bool) {
        
        displayGridLinesVertical = display
        
        gridLinesVertical.forEach { $0.removeFromSuperview() }
        
        gridLinesVertical.removeAll()
        
        if displayGridLinesVertical {
            gridLinesVertical.append(contentsOf: [
                createLineView(background: gridColor),
                createLineView(background: gridColor)
            ])
        }
        setNeedsDisplay()
    }
    
    // MARK: - Private methods
    private func layoutLinesIfNeeded() {
        
        guard !outerLineViews.isEmpty else { return }
        applyLayoutLines()
    }
    
    private func applyLayoutLines() {
        
        let boundsSize = bounds.size
        
        // Border lines
        outerLineViews.enumerated().forEach { (item) in
            
            let aRect : CGRect
            switch item.offset {
            case 0: aRect = CGRect(x:  0.0            , y:              -1.0, width: boundsSize.width + 2.0, height:  1.0) // Top
            case 1: aRect = CGRect(x: boundsSize.width, y:               0.0, width: 1.0, height: boundsSize.height + 0.0) // Right
            case 2: aRect = CGRect(x: -1.0            , y: boundsSize.height, width: boundsSize.width + 2.0, height:  1.0) // Bottom
            case 3: aRect = CGRect(x: -1.0            , y:               0.0, width: 1.0, height: boundsSize.height + 1.0) // Left
            default: aRect = CGRect.zero
            }
            item.element.frame = aRect
        }
        
        // Corner liness
        [topLeftLineViews, topRightLineViews, bottomRightLineViews, bottomLeftLineViews].enumerated().forEach { item in
            var VFrame = CGRect.zero
            var HFrame = CGRect.zero
            
            switch item.offset {
            case 0: // Top left
                VFrame = CGRect(x: kCLDCropOverLayerPlaceholder - 3.0,
                                y: kCLDCropOverLayerPlaceholder - 3.0,
                                width: 3.0, height: kCLDCropOverLayerCornerWidth + 3.0)
                HFrame = CGRect(x: kCLDCropOverLayerPlaceholder + 0.0,
                                y: kCLDCropOverLayerPlaceholder - 3.0,
                                width: kCLDCropOverLayerCornerWidth + 0.0, height: 3.0)
                break
                
            case 1: // Top right
                VFrame = CGRect(x: boundsSize.width + kCLDCropOverLayerPlaceholder,
                                y: kCLDCropOverLayerPlaceholder - 3.0,
                                width: 3.0, height: kCLDCropOverLayerCornerWidth + 3.0)
                HFrame = CGRect(x: boundsSize.width - kCLDCropOverLayerCornerWidth,
                                y: kCLDCropOverLayerPlaceholder - 3.0,
                                width: kCLDCropOverLayerCornerWidth + 0.0, height: 3.0)
                break
                
            case 2: // Bottom right
                VFrame = CGRect(x: boundsSize.width  + kCLDCropOverLayerPlaceholder,
                                y: boundsSize.height - kCLDCropOverLayerCornerWidth,
                                width: 3.0, height: kCLDCropOverLayerCornerWidth + 3.0)
                HFrame = CGRect(x: boundsSize.width  - kCLDCropOverLayerCornerWidth,
                                y: boundsSize.height + kCLDCropOverLayerPlaceholder,
                                width: kCLDCropOverLayerCornerWidth + 0.0, height: 3.0)
                break
                
            case 3: // Bottom left
                VFrame = CGRect(x: kCLDCropOverLayerPlaceholder - 3.0,
                                y: boundsSize.height - kCLDCropOverLayerCornerWidth,
                                width: 3.0, height: kCLDCropOverLayerCornerWidth)
                HFrame = CGRect(x: kCLDCropOverLayerPlaceholder - 3.0,
                                y: boundsSize.height + kCLDCropOverLayerPlaceholder,
                                width: kCLDCropOverLayerCornerWidth + 3.0, height: 3.0)
                break
            default:
                break
            }
            item.element[0].frame = VFrame
            item.element[1].frame = HFrame
        }
        
        var    padding : CGFloat
        var linesCount : Int
        let thickness  = 1.0 / UIScreen.main.scale
        
        // Grid lines - horizontal
        linesCount = gridLinesHorizontal.count
        padding    = (bounds.height - (thickness * CGFloat(linesCount))) / (CGFloat(linesCount) + 1.0)
        gridLinesHorizontal.enumerated().forEach { item in
            
            var aRect = CGRect.zero
            aRect.size.width  = bounds.width
            aRect.size.height = thickness
            aRect.origin.y    = (padding * CGFloat(item.offset + 1)) + (thickness * CGFloat(item.offset))
            item.element.frame = aRect
        }
        
        // Grid lines - vertical
        linesCount = gridLinesVertical.count
        padding    = (bounds.width - (thickness * CGFloat(linesCount))) / (CGFloat(linesCount) + 1.0)
       
        gridLinesVertical.enumerated().forEach { item in
            
            var aRect = CGRect.zero
            aRect.size.width  = thickness
            aRect.size.height = bounds.height
            aRect.origin.x    = (padding * CGFloat(item.offset + 1)) + (thickness * CGFloat(item.offset))
            item.element.frame = aRect
        }
    }
    
    private func createLineView(background color: UIColor) -> UIView {
        
        let newLine = UIView(frame: .zero)
        newLine.backgroundColor = color
        addSubview(newLine)
        return newLine
    }
}
