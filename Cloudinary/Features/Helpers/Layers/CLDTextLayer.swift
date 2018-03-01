//
//  CLDTextLayer.swift
//
//  Copyright (c) 2016 Cloudinary (http://cloudinary.com)
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

import Foundation

@objcMembers open class CLDTextLayer: CLDLayer {
    
    internal var text: String?
    internal var fontFamily: String?
    internal var fontSize: String?
    internal var fontStyle: String?
    internal var fontWeight: String?
    internal var textDecoration: String?
    internal var textAlign: String?
    internal var stroke: String?
    internal var letterSpacing: String?
    internal var lineSpacing: String?
    
    // MARK: - Init
    
    /**
     Initialize a CLDTextLayer instance.
     
     -returns: The new CLDTextLayer instance.
     */
    public override init() {        
        super.init()
        resourceType = String(describing: LayerResourceType.text)
    }
    
    // MARK: - Set Values
    
    
    /**
     Add a text caption layer.
     
     - parameter text:          The text to use as a caption layer.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    open func setText(text: String) -> CLDTextLayer {
        self.text = text
        return self
    }
    
    /**
     Set the name of a font family. e.g. `arial`.
     
     - parameter fontFamily:    The layer font family.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    open func setFontFamily(fontFamily: String) -> CLDTextLayer {
        self.fontFamily = fontFamily
        return self
    }
    
    /**
     Set the font size in pixels. e.g. 12.
     
     - parameter fontSize:      The layer font size.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    @objc(setFontSizeFromInt:)
    open func setFontSize(_ fontSize: Int) -> CLDTextLayer {
        return setFontSize(String(fontSize))
    }
    
    /**
     Set the font size in pixels. e.g. 12.
     
     - parameter fontSize:      The layer font size.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    @objc(setFontSizeFromString:)
    open func setFontSize(_ fontSize: String) -> CLDTextLayer {
        self.fontSize = fontSize
        return self
    }
    
    /**
     Set the font style.
     
     - parameter fontStyle:     The layer font style.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    @objc(setFontStyleFromLayerFontStyle:)
    open func setFontStyle(_ fontStyle: CLDFontStyle) -> CLDTextLayer {
        return setFontStyle(String(describing: fontStyle))
    }
    
    /**
     Set the font style. Possible values: normal (default value) or italic. e.g., italic
     
     - parameter fontStyle:     The layer font style.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    @objc(setFontStyleFromString:)
    open func setFontStyle(_ fontStyle: String) -> CLDTextLayer {
        self.fontStyle = fontStyle
        return self
    }
    
    /**
     Set the text weight.
     
     - parameter fontWeight:    The layer font weight.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    @objc(setFontWeightFromLayerFontWeight:)
    open func setFontWeight(_ fontWeight: CLDFontWeight) -> CLDTextLayer {
        return setFontWeight(String(describing: fontWeight))
    }
    
    /**
     Set the text weight. Possible values: normal (default value) or bold.
     
     - parameter fontWeight:    The layer font weight.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    @objc(setFontWeightFromString:)
    open func setFontWeight(_ fontWeight: String) -> CLDTextLayer {
        self.fontWeight = fontWeight
        return self
    }
    
    /**
     Set the text decoration. Possible values: none (default value), underline or strikethrough.
     
     - parameter textDecoration:    The layer text Decoration.
     
     - returns:                     The same instance of CLDTextLayer.
     */
    @objc(setTextDecorationString:)
    open func setTextDecoration(_ textDecoration: String) -> CLDTextLayer {
        self.textDecoration = textDecoration
        return self
    }
    
    /**
     Set the text alignment. Possible values: left (default value), center, right, end, start or justify.
     
     - parameter textAlign:     The layer text alignment.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    @objc(setTextAlignString:)
    open func setTextAlign(_ textAlign: String) -> CLDTextLayer {
        self.textAlign = textAlign
        return self
    }
    
    /**
     Set the font stroke (border).
     Possible values: none (default value) or stroke.
     Set the color and weight of the stroke with the border parameter.
     
     - parameter stroke:        The layer text stroke.
     
     - returns:                 The same instance of CLDTextLayer.
     */
    @objc(setStrokeString:)
    open func setStroke(_ stroke: String) -> CLDTextLayer {
        self.stroke = stroke
        return self
    }
    
    /**
     Set the spacing between the letters in pixels. Can be a positive or negative.
     
     - parameter letterSpacing:         The layer letter Spacing.
     
     - returns:                         The same instance of CLDTextLayer.
     */
    @objc(setLetterSpacingFromInt:)
    open func setLetterSpacing(_ letterSpacing: Int) -> CLDTextLayer {
        return setLetterSpacing(String(letterSpacing))
    }
    
    /**
     Set the spacing between the letters in pixels. Can be a positive or negative.
     
     - parameter letterSpacing:         The layer letter Spacing.
     
     - returns:                         The same instance of CLDTextLayer.
     */
    @objc(setLetterSpacingFromFloat:)
    open func setLetterSpacing(_ letterSpacing: Float) -> CLDTextLayer {
        return setLetterSpacing(letterSpacing.cldFloatFormat())
    }
    
    /**
     Set the spacing between the letters in pixels. Can be a positive or negative.
     
     - parameter letterSpacing:         The layer letter Spacing.
     
     - returns:                         The same instance of CLDTextLayer.
     */
    @objc(setLetterSpacingString:)
    open func setLetterSpacing(_ letterSpacing: String) -> CLDTextLayer {
        self.letterSpacing = letterSpacing
        return self
    }
    
    /**
     Set the spacing between the lines in pixels (only relevant for multi-line text). Can be a positive or negative.
     
     - parameter lineSpacing:           The layer line Spacing.
     
     - returns:                         The same instance of CLDTextLayer.
     */
    @objc(setLineSpacingFromInt:)
    open func setLineSpacing(_ lineSpacing: Int) -> CLDTextLayer {
        return setLineSpacing(String(describing: letterSpacing))
    }
    
    /**
     Set the spacing between the lines in pixels (only relevant for multi-line text). Can be a positive or negative.
     
     - parameter lineSpacing:           The layer line Spacing.
     
     - returns:                         The same instance of CLDTextLayer.
     */
    @objc(setLineSpacingFromFloat:)
    open func setLineSpacing(_ lineSpacing: Float) -> CLDTextLayer {
        return setLineSpacing(lineSpacing.cldFloatFormat())
    }
    
    /**
     Set the spacing between the lines in pixels (only relevant for multi-line text). Can be a positive or negative.
     
     - parameter lineSpacing:           The layer line Spacing.
     
     - returns:                         The same instance of CLDTextLayer.
     */
    @objc(setLineSpacingString:)
    open func setLineSpacing(_ lineSpacing: String) -> CLDTextLayer {
        self.lineSpacing = lineSpacing
        return self
    }
    
    // MARK: - Actions
    
    internal override func getStringComponents() -> [String]? {
        
        if (text == nil || text!.isEmpty) && (publicId == nil || publicId!.isEmpty) {
            printLog(.error, text: "Must supply either text or publicId")
            return nil
        }
        
        guard var components = super.getStringComponents() else {
            return nil
        }
        
        let optionalTextParams = getOptionalTextPropertiesArray()
        let mandatoryTextParams = getMandatoryTextPropertiesArray()
        if optionalTextParams.isEmpty {
            if !mandatoryTextParams.isEmpty {
                components.append(mandatoryTextParams.joined(separator: "_"))
            }
        }
        else if !mandatoryTextParams.isEmpty {
            let textProperties = mandatoryTextParams + optionalTextParams
            components.append(textProperties.joined(separator: "_"))
        }
        else  {
            printLog(.error, text: "Must supply fontSize and fontFamily for text layer")
            return nil
        }
        
        if let publicId = publicId , !publicId.isEmpty {
            components.append(publicId.replacingOccurrences(of: "/", with: ":"))
        }
        if let text = text , !text.isEmpty {
            if let text = text.cldSmartEncodeUrl() {
                var textToAdd = text.replacingOccurrences(of: "%2C", with: "%252C")
                textToAdd = textToAdd.replacingOccurrences(of: "/", with: "%252F")
                components.append(textToAdd)
            }
        }
        
        return components
    }
    
    //MARK: - Private
    
    fileprivate func getOptionalTextPropertiesArray() -> [String] {
        var properties: [String] = []
        if let fontWeight = fontWeight , fontWeight != "normal" {
            properties.append(fontWeight)
        }
        if let fontStyle = fontStyle , fontStyle != "normal" {
            properties.append(fontStyle)
        }
        if let textDecoration = textDecoration , textDecoration != "none" {
            properties.append(textDecoration)
        }
        if let stroke = stroke , stroke != "none" {
            properties.append(stroke)
        }
        if let textAlign = textAlign , !textAlign.isEmpty {
            properties.append(textAlign)
        }
        if let letterSpacing = letterSpacing , !letterSpacing.isEmpty {
            properties.append("letter_spacing_\(letterSpacing)")
        }
        if let lineSpacing = lineSpacing , !lineSpacing.isEmpty {
            properties.append("line_spacing_\(lineSpacing)")
        }
        
        return properties
    }
    
    fileprivate func getMandatoryTextPropertiesArray() -> [String] {
        var properties: [String] = []
        
        if let fontSize = fontSize {
            properties.insert(fontSize, at: 0)
        }
        
        if let fontFamily = fontFamily {
            properties.insert(fontFamily, at: 0)
        }
        
        return properties
    }
}
