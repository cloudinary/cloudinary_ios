//
//  CLDTransformation.swift
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

/**
 The CLDTransformation class represents a full transformation performed by Cloudinay on-the-fly on a certain asset.
 */
@objc open class CLDTransformation: NSObject {
    
    fileprivate var currentTransformationParams: [String : String] = [:]
    fileprivate var transformations: [[String : String]] = []
    
    // MARK: - Init
    
    public override init() {
        super.init()
    }
    
    // MARK: - Get Values
    
    open var width: String? {
        return getParam(.WIDTH)
    }
    
    open var height: String? {
        return getParam(.HEIGHT)
    }
    
    open var named: String? {
        return getParam(.NAMED)
    }
    
    open var crop: String? {
        return getParam(.CROP)
    }
    
    open var background: String? {
        return getParam(.BACKGROUND)
    }
    
    open var color: String? {
        return getParam(.COLOR)
    }
    
    open var effect: String? {
        return getParam(.EFFECT)
    }
    
    open var angle: String? {
        return getParam(.ANGLE)
    }
    
    open var opacity: String? {
        return getParam(.OPACITY)
    }
    
    open var border: String? {
        return getParam(.BORDER)
    }
    
    open var x: String? {
        return getParam(.X)
    }
    
    open var y: String? {
        return getParam(.Y)
    }
    
    open var radius: String? {
        return getParam(.RADIUS)
    }
    
    open var quality: String? {
        return getParam(.QUALITY)
    }
    
    open var defaultImage: String? {
        return getParam(.DEFAULT_IMAGE)
    }
    
    open var gravity: String? {
        return getParam(.GRAVITY)
    }
    
    open var colorSpace: String? {
        return getParam(.COLOR_SPACE)
    }
    
    open var prefix: String? {
        return getParam(.PREFIX)
    }
    
    open var overlay: String? {
        return getParam(.OVERLAY)
    }
    
    open var underlay: String? {
        return getParam(.UNDERLAY)
    }
    
    open var fetchFormat: String? {
        return getParam(.FETCH_FORMAT)
    }
    
    open var density: String? {
        return getParam(.DENSITY)
    }
    
    open var page: String? {
        return getParam(.PAGE)
    }
    
    open var delay: String? {
        return getParam(.DELAY)
    }
    
    open var rawTransformation: String? {
        return getParam(.RAW_TRANSFORMATION)
    }
    
    open var flags: String? {
        return getParam(.FLAGS)
    }
    
    open var dpr: String? {
        return getParam(.DPR)
    }
    
    open var zoom: String? {
        return getParam(.ZOOM)
    }
    
    open var aspectRatio: String? {
        return getParam(.ASPECT_RATIO)
    }
    
    open var audioCodec: String? {
        return getParam(.AUDIO_CODEC)
    }
    
    open var audioFrequency: String? {
        return getParam(.AUDIO_FREQUENCY)
    }
    
    open var bitRate: String? {
        return getParam(.BIT_RATE)
    }
    
    open var videoSampling: String? {
        return getParam(.VIDEO_SAMPLING)
    }
    
    open var duration: String? {
        return getParam(.DURATION)
    }
    
    open var startOffset: String? {
        return getParam(.START_OFFSET)
    }
    
    open var endOffset: String? {
        return getParam(.END_OFFSET)
    }
    
    open var offset: [String]? {
        guard let
            start = startOffset,
            let end = endOffset else {
                return nil
        }
        return [start, end]
    }
    
    open var videoCodec: String? {
        return getParam(.VIDEO_CODEC)
    }
    
    fileprivate func getParam(_ param: TransformationParam) -> String? {
        return getParam(param.rawValue)
    }
    
    open func getParam(_ param: String) -> String? {
        return currentTransformationParams[param]
    }
    
    // MARK: - Set Values
    
    /**
     Set the image width.
     
     - parameter width:      The width to set.
     
     - returns:              The same instance of CLDTransformation.
     */
    @objc(setWidthWithInt:)
    @discardableResult
    open func setWidth(_ width: Int) -> CLDTransformation {
        return setWidth(String(width))
    }
    
    /**
     Set the image width.
     
     - parameter width:      The width to set.
     
     - returns:              The same instance of CLDTransformation.
     */
    @objc(setWidthWithFloat:)
    @discardableResult
    open func setWidth(_ width: Float) -> CLDTransformation {
        return setWidth(width.cldFloatFormat())
    }
    
    /**
     Set the image width.
     
     - parameter width:      The width to set.
     
     - returns:              The same instance of CLDTransformation.
     */
    @discardableResult
    open func setWidth(_ width: String) -> CLDTransformation {
        return setParam(TransformationParam.WIDTH, value: width)
    }
    
    /**
     Set the image height.
     
     - parameter height:     The height to set.
     
     - returns:              The same instance of CLDTransformation.
     */
    @objc(setHeightWithInt:)
    @discardableResult
    open func setHeight(_ height: Int) -> CLDTransformation {
        return setHeight(String(height))
    }
    
    /**
     Set the image height.
     
     - parameter height:     The height to set.
     
     - returns:              The same instance of CLDTransformation.
     */
    @objc(setHeightWithFloat:)
    @discardableResult
    open func setHeight(_ height: Float) -> CLDTransformation {
        return setHeight(height.cldFloatFormat())
    }
    
    /**
     Set the image height.
     
     - parameter height:     The height to set.
     
     - returns:              The same instance of CLDTransformation.
     */
    @discardableResult
    open func setHeight(_ height: String) -> CLDTransformation {
        return setParam(TransformationParam.HEIGHT, value: height)
    }
    
    /**
     A named transformation is a set of image transformations that has been given a custom name for easy reference.
     It is useful to define a named transformation when you have a set of relatively complex transformations that you use often and that you want to easily reference.
     
     - parameter names:     The names of the transformations to set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setNamedWithArray:)
    @discardableResult
    open func setNamed(_ names: [String]) -> CLDTransformation {
        return setNamed(names.joined(separator: "."))
    }
    
    /**
     A named transformation is a set of image transformations that has been given a custom name for easy reference.
     It is useful to define a named transformation when you have a set of relatively complex transformations that you use often and that you want to easily reference.
     
     - parameter names:     The names of the transformations to set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setNamed(_ names: String) -> CLDTransformation {
        return setParam(TransformationParam.NAMED, value: names)
    }
    
    /**
     Set the image crop.
     
     - parameter crop:      The crop to set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setCropWithCrop:)
    @discardableResult
    open func setCrop(_ crop: CLDCrop) -> CLDTransformation {
        return setCrop(String(describing: crop))
    }
    
    /**
     Set the image crop.
     
     - parameter crop:      The crop to set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setCrop(_ crop: String) -> CLDTransformation {
        return setParam(TransformationParam.CROP, value: crop)
    }
    
    /**
     Defines the background color to use instead of transparent background areas when converting to JPG format or using the pad crop mode.
     The background color can be set as an RGB hex triplet (e.g. '#3e2222'), a 3 character RGB hex (e.g. '#777') or a named color (e.g. 'green').
     
     - parameter background:    The background color to set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setBackground(_ background: String) -> CLDTransformation {
        return setParam(TransformationParam.BACKGROUND, value: background.replacingOccurrences(of: "#", with: "rgb:"))
    }
    
    /**
     Customize the color to use together with: text captions, the shadow effect and the colorize effect.
     The color can be set as an RGB hex triplet (e.g. '#3e2222'), a 3 character RGB hex (e.g. '#777') or a named color (e.g. 'green').
     
     - parameter color:     The color to set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setColor(_ color: String) -> CLDTransformation {
        return setParam(TransformationParam.COLOR, value: color.replacingOccurrences(of: "#", with: "rgb:"))
    }
    
    /**
     Apply a filter or an effect on an image.
     
     - parameter effect:    The effect to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setEffectWithEffect:)
    @discardableResult
    open func setEffect(_ effect: CLDEffect) -> CLDTransformation {
        return setEffect(String(describing: effect))
    }
    
    /**
     Apply a filter or an effect on an image.
     The value includes the name of the effect and an additional parameter that controls the behavior of the specific effect.
     
     - parameter effect:        The effect to apply.
     - parameter effectParam:   The effect value to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setEffectWithEffect:param:)
    @discardableResult
    open func setEffect(_ effect: CLDEffect, param: String) -> CLDTransformation {
        return setEffect(String(describing: effect), param: param)
    }
    
    /**
     Apply a filter or an effect on an image.
     The value includes the name of the effect and an additional parameter that controls the behavior of the specific effect.
     
     - parameter effect:        The effect to apply.
     - parameter effectParam:   The effect value to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setEffect(_ effect: String, param: String) -> CLDTransformation {
        return setEffect("\(effect):\(param)")
    }
    
    /**
     Apply a filter or an effect on an image.
     
     - parameter effect:    The effect to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setEffect(_ effect: String) -> CLDTransformation {
        return setParam(TransformationParam.EFFECT, value: effect)
    }
    
    /**
     Rotate or flip an image by the given degrees or automatically according to its orientation or available meta-data.
     
     - parameter angle:     The angle to rotate.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setAngleWithInt:)
    @discardableResult
    open func setAngle(_ angle: Int) -> CLDTransformation {
        return setAngle(String(angle))
    }
    
    /**
     Rotate or flip an image by the given degrees or automatically according to its orientation or available meta-data.
     
     - parameter angles:    The angles to rotate.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setAngleWithArray:)
    @discardableResult
    open func setAngle(_ angles: [String]) -> CLDTransformation {
        return setAngle(angles.joined(separator: "."))
    }
    
    /**
     Rotate or flip an image by the given degrees or automatically according to its orientation or available meta-data.
     
     - parameter angle:    The angle to rotate.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setAngle(_ angles: String) -> CLDTransformation {
        return setParam(TransformationParam.ANGLE, value: angles)
    }
    
    /**
     Adjust the opacity of the image and make it semi-transparent. 100 means opaque, while 0 is completely transparent.
     
     - parameter opacity:   The opacity level to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setOpacityWithInt:)
    @discardableResult
    open func setOpacity(_ opacity: Int) -> CLDTransformation {
        return setOpacity(String(opacity))
    }
    
    /**
     Adjust the opacity of the image and make it semi-transparent. 100 means opaque, while 0 is completely transparent.
     
     - parameter opacity:   The opacity level to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setOpacity(_ opacity: String) -> CLDTransformation {
        return setParam(TransformationParam.OPACITY, value: opacity)
    }
    
    /**
     Add a solid border around the image.
     
     - parameter width:     The border width.
     - parameter color:     The border color.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setBorder(_ width: Int, color: String) -> CLDTransformation {
        return setBorder("\(width)px_solid_\(color)")
    }
    
    /**
     Add a solid border around the image.
     Should conform to the form: [width]px_solid_[color], e.g - 5px_solid_#111111 or 5px_solid_red
     
     - parameter border:     The border to add.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setBorder(_ border: String) -> CLDTransformation {
        return setParam(TransformationParam.BORDER, value: border.replacingOccurrences(of: "#", with: "rgb:"))
    }
    
    /**
     Horizontal position for custom-coordinates based cropping, overlay placement and certain region related effects.
     
     - parameter x:     The x position to add.
     
     - returns:         The same instance of CLDTransformation.
     */
    @objc(setXFromInt:)
    @discardableResult
    open func setX(_ x: Int) -> CLDTransformation {
        return setX(String(x))
    }
    
    /**
     Horizontal position for custom-coordinates based cropping, overlay placement and certain region related effects.
     
     - parameter x:     The x position to add.
     
     - returns:         The same instance of CLDTransformation.
     */
    @objc(setXFromFloat:)
    @discardableResult
    open func setX(_ x: Float) -> CLDTransformation {
        return setX(x.cldFloatFormat())
    }
    
    /**
     Horizontal position for custom-coordinates based cropping, overlay placement and certain region related effects.
     
     - parameter x:     The x position to add.
     
     - returns:         The same instance of CLDTransformation.
     */
    @discardableResult
    open func setX(_ x: String) -> CLDTransformation {
        return setParam(TransformationParam.X, value: x)
    }
    
    /**
     Vertical position for custom-coordinates based cropping and overlay placement.
     
     - parameter y:     The y position to add.
     
     - returns:         The same instance of CLDTransformation.
     */
    @objc(setYFromInt:)
    @discardableResult
    open func setY(_ y: Int) -> CLDTransformation {
        return setY(String(y))
    }
    
    /**
     Vertical position for custom-coordinates based cropping and overlay placement.
     
     - parameter y:     The y position to add.
     
     - returns:         The same instance of CLDTransformation.
     */
    @objc(setYFromFloat:)
    @discardableResult
    open func setY(_ y: Float) -> CLDTransformation {
        return setY(y.cldFloatFormat())
    }
    
    /**
     Vertical position for custom-coordinates based cropping and overlay placement.
     
     - parameter y:     The y position to add.
     
     - returns:         The same instance of CLDTransformation.
     */
    @discardableResult
    open func setY(_ y: String) -> CLDTransformation {
        return setParam(TransformationParam.Y, value: y)
    }
    
    /**
     Round the corners of an image or make it completely circular or oval (ellipse).
     
     - parameter radius:    The radius to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setRadiusFromInt:)
    @discardableResult
    open func setRadius(_ radius: Int) -> CLDTransformation {
        return setRadius(String(radius))
    }
    
    /**
     Round the corners of an image or make it completely circular or oval (ellipse).
     
     - parameter radius:    The radius to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setRadius(_ radius: String) -> CLDTransformation {
        return setParam(TransformationParam.RADIUS, value: radius)
    }
    
    /**
     Control the JPEG, WebP, GIF, JPEG XR and JPEG 2000 compression quality. 1 is the lowest quality and 100 is the highest. Reducing quality generates JPG images much smaller in file size. The default values are:
     * JPEG: 90
     * WebP: 80 (100 quality for WebP is lossless)
     * GIF: lossless by default. 80 if the `lossy` flag is added
     * JPEG XR and JPEG 2000: 70
     
     - parameter quality:   The quality to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setQualityFromInt:)
    @discardableResult
    open func setQuality(_ quality: Int) -> CLDTransformation {
        return setQuality(String(quality))
    }
    
    /**
     Control the JPEG, WebP, GIF, JPEG XR and JPEG 2000 compression quality. 1 is the lowest quality and 100 is the highest. Reducing quality generates JPG images much smaller in file size. The default values are:
     * JPEG: 90
     * WebP: 80 (100 quality for WebP is lossless)
     * GIF: lossless by default. 80 if the `lossy` flag is added
     * JPEG XR and JPEG 2000: 70
     
     - parameter quality:   The quality to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setQuality(_ quality: String) -> CLDTransformation {
        return setParam(TransformationParam.QUALITY, value: quality)
    }
    
    /**
     Specify the public ID of a placeholder image to use if the requested image or social network picture does not exist.
     
     - parameter defaultImage:      The identifier of the default image.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setDefaultImage(_ defaultImage: String) -> CLDTransformation {
        return setParam(TransformationParam.DEFAULT_IMAGE, value: defaultImage)
    }
    
    /**
     Decides which part of the image to keep while 'crop', 'pad' and 'fill' crop modes are used.
     
     - parameter gravity:           The gravity to apply.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @objc(setGravityWithGravity:)
    @discardableResult
    open func setGravity(_ gravity: CLDGravity) -> CLDTransformation {
        return setGravity(String(describing: gravity))
    }
    
    /**
     Decides which part of the image to keep while 'crop', 'pad' and 'fill' crop modes are used.
     
     - parameter gravity:           The gravity to apply.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setGravity(_ gravity: String) -> CLDTransformation {
        return setParam(TransformationParam.GRAVITY, value: gravity)
    }
    
    /**
     Set the transformation color space.
     
     - parameter colorSpace:        The color space to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setColorSpace(_ colorSpace: String) -> CLDTransformation {
        return setParam(TransformationParam.COLOR_SPACE, value: colorSpace)
    }
    
    /**
     Set the transformation prefix.
     
     - parameter prefix:            The prefix to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setPrefix(_ prefix: String) -> CLDTransformation {
        return setParam(TransformationParam.PREFIX, value: prefix)
    }
    
    /**
     Add an overlay over the base image. You can control the dimension and position of the overlay using the width, height, x, y and gravity parameters.
     The overlay can take one of the following forms:
     identifier can be a public ID of an uploaded image or a specific image kind, public ID and settings.
     
     **You can use the convenience method `addOverlayWithLayer`**
     
     - parameter overlay:           The overlay to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setOverlay(_ overlay: String) -> CLDTransformation {
        return setParam(TransformationParam.OVERLAY, value: overlay)
    }
    
    /**
     Add an underlay image below a base partially-transparent image.
     You can control the dimensions and position of the underlay using the width, height, x, y and gravity parameters.
     The identifier can be a public ID of an uploaded image or a specific image kind, public ID and settings.
     The underlay parameter shares the same features as the overlay parameter.
     
     **You can use the convenience method `addUnderlayWithLayer`**
     
     - parameter underlay:          The underlay to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setUnderlay(_ underlay: String) -> CLDTransformation {
        return setParam(TransformationParam.UNDERLAY, value: underlay)
    }
    
    /**
     Force format conversion to the given image format for remote 'fetch' URLs and auto uploaded images that already have a different format as part of their URLs.
     
     - parameter fetchFormat:       The fetchFormat to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setFetchFormat(_ fetchFormat: String) -> CLDTransformation {
        return setParam(TransformationParam.FETCH_FORMAT, value: fetchFormat)
    }
    
    /**
     Control the density to use while converting a PDF document to images. (range: 50-300, default is 150)
     
     - parameter density:           The density to use.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @objc(setDensityWithInt:)
    @discardableResult
    open func setDensity(_ density: Int) -> CLDTransformation {
        return setDensity(String(density))
    }
    
    /**
     Control the density to use while converting a PDF document to images. (range: 50-300, default is 150)
     
     - parameter density:           The density to use.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setDensity(_ density: String) -> CLDTransformation {
        return setParam(TransformationParam.DENSITY, value: density)
    }
    
    /**
     Given a multi-page file (PDF, animated GIF, TIFF), generate an image of a single page using the given index.
     
     - parameter page:              The index of the page to use to use.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @objc(setPageWithInt:)
    @discardableResult
    open func setPage(_ page: Int) -> CLDTransformation {
        return setPage(String(page))
    }
    
    /**
     Given a multi-page file (PDF, animated GIF, TIFF), generate an image of a single page using the given index.
     
     - parameter page:              The index of the page to use to use.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setPage(_ page: String) -> CLDTransformation {
        return setParam(TransformationParam.PAGE, value: page)
    }
    
    /**
     Controls the time delay between the frames of an animated image, in milliseconds.
     
     - parameter delay:             The delay between the frames of an animated image, in milliseconds.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @objc(setDelayWithInt:)
    @discardableResult
    open func setDelay(_ delay: Int) -> CLDTransformation {
        return setDelay(String(delay))
    }
    
    /**
     Controls the time delay between the frames of an animated image, in milliseconds.
     
     - parameter delay:             The delay between the frames of an animated image, in milliseconds.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setDelay(_ delay: String) -> CLDTransformation {
        return setParam(TransformationParam.DELAY, value: delay)
    }
    
    /**
     Add a raw transformation, it will be appended to the other transformation parameter.
     the transformation must conform to [Cloudinary's transformation documentation](http://cloudinary.com/documentation/image_transformation_reference)
     
     - parameter rawTransformation:     The raw transformation to add.
     
     - returns:                         The same instance of CLDTransformation.
     */
    @discardableResult
    open func setRawTransformation(_ rawTransformation: String) -> CLDTransformation {
        return setParam(TransformationParam.RAW_TRANSFORMATION, value: rawTransformation)
    }
    
    /**
     Set one or more flags that alter the default transformation behavior.
     
     - parameter flags:     An array of the flags to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setFlagsWithArray:)
    @discardableResult
    open func setFlags(_ flags: [String]) -> CLDTransformation {
        return setFlags(flags.joined(separator: "."))
    }
    
    /**
     Set one or more flags that alter the default transformation behavior.
     
     - parameter flags:     An array of the flags to apply.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setFlags(_ flags: String) -> CLDTransformation {
        return setParam(TransformationParam.FLAGS, value: flags)
    }
    
    /**
     Deliver the image in the specified device pixel ratio.
     
     - parameter dpr:       The DPR ot set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setDprWithFloat:)
    @discardableResult
    open func setDpr(_ dpr: Float) -> CLDTransformation {
        return setDpr(dpr.cldFloatFormat())
    }
    
    /**
     Deliver the image in the correct device pixel ratio, according to the used device.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setDprAuto() -> CLDTransformation {
        let scale = Float(UIScreen.main.scale)
        return setDpr(scale)
    }
    
    /**
     Deliver the image in the specified device pixel ratio. The parameter accepts any positive float value.
     
     - parameter dpr:       The DPR ot set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setDpr(_ dpr: String) -> CLDTransformation {
        return setParam(TransformationParam.DPR, value: dpr)
    }
    
    /**
     Control how much of the original image surrounding the face to keep when using either the 'crop' or 'thumb' cropping modes with face detection. default is 1.0.
     
     - parameter zoom:      The zoom ot set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @objc(setZoomWithFloat:)
    @discardableResult
    open func setZoom(_ zoom: Float) -> CLDTransformation {
        return setZoom(zoom.cldFloatFormat())
    }
    
    /**
     Control how much of the original image surrounding the face to keep when using either the 'crop' or 'thumb' cropping modes with face detection. default is 1.0.
     
     - parameter zoom:      The zoom ot set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setZoom(_ zoom: String) -> CLDTransformation {
        return setParam(TransformationParam.ZOOM, value: zoom)
    }
    
    /**
     Resize or crop the image to a new aspect ratio using a nominator and dominator (e.g. 16 and 9 for 16:9).
     This parameter is used together with a specified crop mode that determines how the image is adjusted to the new dimensions.
     
     - parameter nominator:     The nominator ot use.
     - parameter dominator:     The dominator ot use.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setAspectRatio(nominator: Int, denominator: Int) -> CLDTransformation {
        return setAspectRatio("\(nominator):\(denominator)")
    }
    
    /**
     Resize or crop the image to a new aspect ratio.
     This parameter is used together with a specified crop mode that determines how the image is adjusted to the new dimensions.
     
     - parameter aspectRatio:   The aspect ratio ot use.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @objc(setAspectRatioWithFloat:)
    @discardableResult
    open func setAspectRatio(_ aspectRatio: Float) -> CLDTransformation {
        return setAspectRatio(aspectRatio.cldFloatFormat())
    }
    
    /**
     Resize or crop the image to a new aspect ratio.
     This parameter is used together with a specified crop mode that determines how the image is adjusted to the new dimensions.
     
     - parameter aspectRatio:   The aspect ratio ot use.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setAspectRatio(_ aspectRatio: String) -> CLDTransformation {
        return setParam(TransformationParam.ASPECT_RATIO, value: aspectRatio)
    }
    
    /**
     Use the audio_codec parameter to set the audio codec or remove the audio channel completely as follows:
     
     * **none** removes the audio channel
     * **aac** (mp4 or flv only)
     * **vorbis** (ogv or webm only)
     * **mp3** (mp4 or flv only)
     
     - parameter audioCodec:    The audio codec ot set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setAudioCodec(_ audioCodec: String) -> CLDTransformation {
        return setParam(TransformationParam.AUDIO_CODEC, value: audioCodec)
    }
    
    /**
     Use the audio_frequency parameter to control the audio sampling frequency.
     This parameter represents an integer value in Hz.
     See the documentation in the [Video transformations reference table](http://cloudinary.com/documentation/video_manipulation_and_delivery#video_transformations_reference) for the possible values.
     
     - parameter audioFrequency:    The audio frequency ot set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @objc(setAudioFrequencyWithInt:)
    @discardableResult
    open func setAudioFrequency(_ audioFrequency: Int) -> CLDTransformation {
        return setAudioFrequency(String(audioFrequency))
    }
    
    /**
     Use the audio_frequency parameter to control the audio sampling frequency.
     This parameter represents an integer value in Hz.
     See the documentation in the [Video transformations reference table](http://cloudinary.com/documentation/video_manipulation_and_delivery#video_transformations_reference) for the possible values.
     
     - parameter audioFrequency:    The audio frequency ot set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setAudioFrequency(_ audioFrequency: String) -> CLDTransformation {
        return setParam(TransformationParam.AUDIO_FREQUENCY, value: audioFrequency)
    }
    
    /**
     Use the bit_rate parameter for advanced control of the video bit rate.
     This parameter controls the number of bits used to represent the video data.
     The higher the bit rate, the higher the visual quality of the video, but the larger the file size as well.
     
     - parameter bitRate:    The bit rate ot set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @objc(setBitRateWithInt:)
    @discardableResult
    open func setBitRate(_ bitRate: Int) -> CLDTransformation {
        return setBitRate(String(bitRate))
    }
    
    /**
     Use the bit_rate parameter for advanced control of the video bit rate.
     This parameter controls the number of bits used to represent the video data.
     The higher the bit rate, the higher the visual quality of the video, but the larger the file size as well.
     
     - parameter bitRate:    The bit rate ot set in kilobytes.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setBitRate(kb bitRate: Int) -> CLDTransformation {
        return setBitRate("\(bitRate)k")
    }
    
    /**
     Use the bit_rate parameter for advanced control of the video bit rate.
     This parameter controls the number of bits used to represent the video data.
     The higher the bit rate, the higher the visual quality of the video, but the larger the file size as well.
     Bit rate can take one of the following values:
     
     * An integer e.g. 120000.
     * A string supporting ‘k’ and ‘m’ (kilobits and megabits respectively) e.g. 500k or 2m.
     
     - parameter bitRate:    The bit rate ot set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setBitRate(_ bitRate: String) -> CLDTransformation {
        return setParam(TransformationParam.BIT_RATE, value: bitRate)
    }
    
    /**
     The total number of frames to sample from the original video. The frames are spread out over the length of the video, e.g. 20 takes one frame every 5%.
     
     - parameter frames:        The video sampling frames ot set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setVideoSampling(frames: Int) -> CLDTransformation {
        return setVideoSampling(String(frames))
    }
    
    /**
     Controls the time delay between the frames of an animated image, in milliseconds.
     
     - parameter delay:         The delay ot set in milliseconds.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setVideoSampling(delay: Float) -> CLDTransformation {
        return setVideoSampling("\(delay.cldFloatFormat())s")
    }
    
    /**
     Relevant for conversion of video to animated GIF or WebP.
     If not specified, the resulting GIF or WebP samples the whole video (up to 400 frames, at up to 10 frames per second).
     By default the duration of the animated image is the same as the duration of the video,
     no matter how many frames are sampled from the original video (use the delay parameter to adjust the amount of time between frames).
     
     - parameter videoSampling:     The video sampling ot set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setVideoSampling(_ videoSampling: String) -> CLDTransformation {
        return setParam(TransformationParam.VIDEO_SAMPLING, value: videoSampling)
    }
    
    /**
     Offset in seconds or percent of a video, normally used together with the start_offset and end_offset parameters. Used to specify:
     * The duration the video displays.
     * The duration an overlay displays.
     
     - parameter seconds:       The duration to set in seconds.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setDuration(seconds: Float) -> CLDTransformation {
        return setDuration(seconds.cldFloatFormat())
    }
    
    /**
     Offset in seconds or percent of a video, normally used together with the start_offset and end_offset parameters. Used to specify:
     * The duration the video displays.
     * The duration an overlay displays.
     
     - parameter percent:       The duration percent to set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setDuration(percent: Int) -> CLDTransformation {
        return setDuration("\(percent)p")
    }
    
    /**
     Offset in seconds or percent of a video, normally used together with the start_offset and end_offset parameters. Used to specify:
     * The duration the video displays.
     * The duration an overlay displays.
     
     - parameter duration:      The duration to set in seconds.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setDuration(_ duration: String) -> CLDTransformation {
        return setParam(TransformationParam.DURATION, value: duration)
    }
    
    /**
     Set an offset in seconds to cut a video at the start.
     
     - parameter seconds:       The start time to set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setStartOffset(seconds: Float) -> CLDTransformation {
        return setStartOffset(seconds.cldFloatFormat())
    }
    
    /**
     Set an offset in percent to cut a video at the start.
     
     - parameter percent:       The percent of time to cut.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setStartOffset(percent: Int) -> CLDTransformation {
        return setStartOffset("\(percent)p")
    }
    
    /**
     Set an offset in seconds or percent of a video to cut a video at the start.
     
     - parameter duration:      The start time to set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    
    @discardableResult
    open func setStartOffset(_ duration: String) -> CLDTransformation {
        return setParam(TransformationParam.START_OFFSET, value: duration)
    }
    
    /**
     Set an offset in seconds to cut a video at the end.
     
     - parameter seconds:       The end time to set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setEndOffset(seconds: Float) -> CLDTransformation {
        return setEndOffset(seconds.cldFloatFormat())
    }
    
    /**
     Set an offset in percent to cut a video at the end.
     
     - parameter percent:       The percent of time to cut.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setEndOffset(percent: Int) -> CLDTransformation {
        return setEndOffset("\(percent)p")
    }
    
    /**
     Set an offset in seconds or percent of a video to cut a video at the end.
     
     - parameter duration:      The end time to set.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setEndOffset(_ duration: String) -> CLDTransformation {
        return setParam(TransformationParam.END_OFFSET, value: duration)
    }
    
    /**
     Used to determine the video codec, video profile and level to use.
     You can set this parameter to auto instead.
     
     - parameter videoCodec:        The video codec to set.
     - parameter videoProfile:      The video profile to set.
     - parameter level:             The level to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setVideoCodecAndProfileAndLevel(_ videoCodec: String, videoProfile: String, level: String? = nil) -> CLDTransformation {
        return level == nil ? setVideoCodec("\(videoCodec):\(videoProfile)") : setVideoCodec("\(videoCodec):\(videoProfile):\(level!)")
    }
    
    /**
     Used to determine the video codec to use.
     You can set this parameter to auto instead.
     
     - parameter videoCodec:        The video codec to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setVideoCodec(_ videoCodec: String) -> CLDTransformation {
        return setParam(TransformationParam.VIDEO_CODEC, value: videoCodec)
    }
    
    // MARK: Setters
    
    fileprivate func setParam(_ key: TransformationParam, value: String) -> CLDTransformation {
        return setParam(key.rawValue, value: value)
    }
    
    @discardableResult
    open func setParam(_ key: String, value: String) -> CLDTransformation {
        currentTransformationParams[key] = value
        return self
    }
    
    // MARK: - Convenience
    
    /**
     A convenience method to set video cutting in seconds. Must provide an array with exactly 2 values: 1. start offset. 2. end offset.
     
     - parameter seconds:           The array of both start and end offsets to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    func setOffset(seconds: [Float]) -> CLDTransformation {
        guard let
            start = seconds.first,
            let end = seconds.last else {
                return self
        }
        return setOffset([start.cldFloatFormat(), end.cldFloatFormat()])
    }
    
    /**
     A convenience method to set video cutting in percent. Must provide an array with exactly 2 values: 1. start offset. 2. end offset.
     
     - parameter seconds:           The array of both start and end offsets to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    func setOffset(percents: [Int]) -> CLDTransformation {
        guard let
            start = percents.first,
            let end = percents.last else {
                return self
        }
        return setOffset(["\(start)p", "\(end)p"])
    }
    
    /**
     A convenience method to set video cutting in seconds or percent. 
     Should provide an array with 2 values: 1. start offset. 2. end offset. Or one value for both.
     
     - parameter seconds:           The array of both start and end offsets to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    func setOffset(_ durations: [String]) -> CLDTransformation {
        guard let
            start = durations.first,
            let end = durations.last else {
                return self
        }
        setStartOffset(start)
        setEndOffset(end)
        return self
    }
    
    /**
     Shortcut to set video cutting in seconds using a combination of start_offset and end_offset values.
     
     - parameter startSeconds:           The start time to set.
     - parameter endSeconds:             The end time to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setStartOffsetAndEndOffset(startSeconds: Float, endSeconds: Float) -> CLDTransformation {
        setStartOffset(seconds: startSeconds)
        setEndOffset(seconds: endSeconds)
        return self
    }
    
    /**
     Shortcut to set video cutting in percent of video using a combination of start_offset and end_offset values.
     
     - parameter startPercent:           The start time to set.
     - parameter endPercent:             The end time to set.
     
     - returns:                     The same instance of CLDTransformation.
     */
    @discardableResult
    open func setStartOffsetAndEndOffset(startPercent: Int, endPercent: Int) -> CLDTransformation {
        setStartOffset(percent: startPercent)
        setEndOffset(percent: endPercent)
        return self
    }
    
    /**
     Set an overlay using the helper class CLDLayer.
     
     - parameter layer:     The layer to add as an overlay.
     
     - returns:                 The same instance of CLDTransformation.
     */
    @discardableResult
    open func setOverlayWithLayer(_ layer: CLDLayer) -> CLDTransformation {
        if let layerString = layer.asString() {
            return setOverlay(layerString)
        }
        else {
            return setOverlay("")
        }
    }
    
    /**
     Set an underlay using the helper class CLDLayer.
     
     - parameter layer:     The layer to add as an underlay.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setUnderlayWithLayer(_ layer: CLDLayer) -> CLDTransformation {
        if let layerString = layer.asString() {
            return setUnderlay(layerString)
        }
        else {
            return setUnderlay("")
        }
    }
    
    /**
     A convenience method to set the transformation X and Y parameters.
     
     - parameter point:     The top left pont to set.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func setTopLeftPoint(_ point: CGPoint) -> CLDTransformation {
        setX(Float(point.x))
        return setY(Float(point.y))
    }
    
    // MARK: - Actions
    
    /**
     Cloudinary supports powerful image transformations that are applied on the fly using dynamic URLs,
     and you can also combine multiple transformations together as part of a single delivery request, e.g. crop an image and then add a border.
     In certain cases you may want to perform additional transformations on the result of a single transformation request.
     In order to do that, you can chain the transformations together.
     
     In practice, the chain allows you to start seting properties to a new transformation,
     which will be chained to the transformation you worked on, even though you still use the same CLDTransformation instance.
     
     - returns:             The same instance of CLDTransformation.
     */
    @discardableResult
    open func chain() -> Self {
        transformations.append(currentTransformationParams)
        currentTransformationParams = [:]
        return self
    }
    
    internal func asString() -> String? {
        chain()
        var components: [String] = []
        for params in self.transformations {
            if let singleTransStringRepresentation = self.getStringRepresentationFromParams(params) {
                components.append(singleTransStringRepresentation)
            }
            else {
                return nil
            }
        }
        return components.joined(separator: "/")
    }
    
    // MARK: - Private
    
    fileprivate func getStringRepresentationFromParams(_ params: [String : String]) -> String? {
        
        let emptyParams = params.filter{$0.0.isEmpty || $0.1.isEmpty}
        if emptyParams.count > 0 {
            printLog(.error, text: "An empty string key or value are not allowed.")
            return nil
        }
        
        var components: [String] = params.sorted{$0.0 < $1.0}
                                        .filter{$0.0 != TransformationParam.RAW_TRANSFORMATION.rawValue && !$0.1.isEmpty}
                                        .map{"\($0)_\($1)"}

        if let rawTrans = params[TransformationParam.RAW_TRANSFORMATION.rawValue] , !rawTrans.isEmpty {
            components.append(rawTrans)
        }
        return components.joined(separator: ",")
    }
    
    // MARK: - Params
    
    internal enum TransformationParam: String {
        case WIDTH =                        "w"
        case HEIGHT =                       "h"
        case NAMED =                        "t"
        case CROP =                         "c"
        case BACKGROUND =                   "b"
        case COLOR =                        "co"
        case EFFECT =                       "e"
        case ANGLE =                        "a"
        case OPACITY =                      "o"
        case BORDER =                       "bo"
        case X =                            "x"
        case Y =                            "y"
        case RADIUS =                       "r"
        case QUALITY =                      "q"
        case DEFAULT_IMAGE =                "d"
        case GRAVITY =                      "g"
        case COLOR_SPACE =                  "cs"
        case PREFIX =                       "p"
        case OVERLAY =                      "l"
        case UNDERLAY =                     "u"
        case FETCH_FORMAT =                 "f"
        case DENSITY =                      "dn"
        case PAGE =                         "pg"
        case DELAY =                        "dl"
        case FLAGS =                        "fl"
        case DPR =                          "dpr"
        case ZOOM =                         "z"
        case ASPECT_RATIO =                 "ar"
        case AUDIO_CODEC =                  "ac"
        case AUDIO_FREQUENCY =              "af"
        case BIT_RATE =                     "br"
        case VIDEO_SAMPLING =               "vs"
        case DURATION =                     "du"
        case START_OFFSET =                 "so"
        case END_OFFSET =                   "eo"
        case VIDEO_CODEC =                  "vc"
        case RAW_TRANSFORMATION =           "raw_transformation"
    }
    
    // MARK: Crop
    
    @objc public enum CLDCrop: Int, CustomStringConvertible {
        case fill, crop, scale, fit, limit, mFit, lFill, pad, lPad, mPad, thumb, imaggaCrop, imaggaScale
        
        public var description: String {
            get {
                switch self {
                case .fill:         return "fill"
                case .crop:         return "crop"
                case .scale:        return "scale"
                case .fit:          return "fit"
                case .limit:        return "limit"
                case .mFit:         return "mfit"
                case .lFill:        return "lfill"
                case .pad:          return "pad"
                case .lPad:         return "lpad"
                case .mPad:         return "mpad"
                case .thumb:        return "thumb"
                case .imaggaCrop:   return "imagga_crop"
                case .imaggaScale:  return "imagga_scale"
                }
            }
        }
    }
    
    // MARK: Effect
    
    @objc public enum CLDEffect: Int, CustomStringConvertible {
        case hue, red, green, blue, negate, brightness, sepia, grayscale, blackwhite, saturation, colorize, contrast, autoContrast, vibrance, autoColor, improve, autoBrightness, fillLight, viesusCorrect, gamma, screen, multiply, overlay, makeTransparent, trim, shadow, distort, shear, displace, oilPaint, redeye, advRedeye, vignette, gradientFade, pixelate, pixelateRegion, pixelateFaces, blur, blurRegion, blurFaces, sharpen, unsharpMask, orderedDither
        
        public var description: String {
            get {
                switch self {
                case .hue:              return "hue"
                case .red:              return "red"
                case .green:            return "green"
                case .blue:             return "blue"
                case .negate:           return "negate"
                case .brightness:       return "brightness"
                case .sepia:            return "sepia"
                case .grayscale:        return "grayscale"
                case .blackwhite:       return "blackwhite"
                case .saturation:       return "saturation"
                case .colorize:         return "colorize"
                case .contrast:         return "contrast"
                case .autoContrast:     return "auto_contrast"
                case .vibrance:         return "vibrance"
                case .autoColor:        return "auto_color"
                case .improve:          return "improve"
                case .autoBrightness:   return "auto_brightness"
                case .fillLight:        return "fill_light"
                case .viesusCorrect:    return "viesus_correct"
                case .gamma:            return "gamma"
                case .screen:           return "screen"
                case .multiply:         return "multiply"
                case .overlay:          return "overlay"
                case .makeTransparent:  return "make_transparent"
                case .trim:             return "trim"
                case .shadow:           return "shadow"
                case .distort:          return "distort"
                case .shear:            return "shear"
                case .displace:         return "displace"
                case .oilPaint:         return "oil_paint"
                case .redeye:           return "redeye"
                case .advRedeye:        return "adv_redeye"
                case .vignette:         return "vignette"
                case .gradientFade:     return "gradient_fade"
                case .pixelate:         return "pixelate"
                case .pixelateRegion:   return "pixelate_region"
                case .pixelateFaces:    return "pixelate_faces"
                case .blur:             return "blur"
                case .blurRegion:       return "blur_region"
                case .blurFaces:        return "blur_faces"
                case .sharpen:          return "sharpen"
                case .unsharpMask:      return "unsharp_mask"
                case .orderedDither:    return "ordered_dither"
                }
            }
        }
    }
    
    // MARK: Gravity
    
    @objc public enum CLDGravity: Int, CustomStringConvertible {
        case center, auto, face, faceCenter, faces, facesCenter, advFace, advFaces, advEyes, north, northWest, northEast, south, southWest, southEast, east, west, xyCenter, custom, customFace, customFaces, customAdvFace, customAdvFaces
        
        public var description: String {
            get {
                switch self {
                case .center:           return "center"
                case .auto:             return "auto"
                case .face:             return "face"
                case .faceCenter:       return "faceCenter"
                case .faces:            return "faces"
                case .facesCenter:      return "facesCenter"
                case .advFace:          return "adv_face"
                case .advFaces:         return "adv_faces"
                case .advEyes:          return "adv_eyes"
                case .north:            return "north"
                case .northWest:        return "north_west"
                case .northEast:        return "north_east"
                case .south:            return "south"
                case .southWest:        return "south_west"
                case .southEast:        return "south_east"
                case .west:             return "west"
                case .east:             return "east"
                case .xyCenter:         return "xy_center"
                case .custom:           return "custom"
                case .customFace:       return "custom:face"
                case .customFaces:      return "custom:faces"
                case .customAdvFace:    return "custom:adv_face"
                case .customAdvFaces:   return "custom:adv_faces"
                }
            }
        }
    }
    
}
