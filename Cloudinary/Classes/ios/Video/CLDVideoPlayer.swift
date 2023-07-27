//
//  CLDVideoPlayer.swift
//
//  Copyright (c) 2018 Cloudinary (http://cloudinary.com)
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
import AVKit
@objcMembers open class CLDVideoPlayer: AVPlayer {

    var automaticStreamingProfile = true

    var publicId: String?

    var transformation: CLDTransformation?

    override init() {
        super.init()
    }

    /**
     Download a video asynchronously from the specified URL and set it to the AVPlayer video.

     - parameter publicId:                      The remote asset's name (e.g. the public id of an uploaded image).
     - parameter cloudinary:                    An instance of CLDCloudinary.
     - parameter transformation:                An instance of CLDTransformation.
     - parameter automaticStreamingProfile:     A bool to indicate the use of automatic streaming profile default: true

     */
    public init(publicId: String, cloudinary: CLDCloudinary, transformation: CLDTransformation? = nil, automaticStreamingProfile: Bool? = true) {
        var transformation = transformation
        var cldUrl = cloudinary.createUrl()
        if automaticStreamingProfile ?? true  && transformation == nil {
            cldUrl = cldUrl.setFormat("m3u8")
            transformation = CLDTransformation().setStreamingProfile("auto")
        }
        guard let urlString = cldUrl.setResourceType(.video)
            .setTransformation(transformation ?? CLDTransformation())
            .generate(publicId), let url = URL(string: urlString) else {
            print("Error - could not generate URL for CLDVideoPlayer")
            super.init()
            return
        }
        super.init(url: url)
    }

    /**
     Initializes a CLDVideoPlayer instance, using a given AVPlayerItem.

     - parameter item:  The player item to put into AVPlayer

    */
    public override init(playerItem item: AVPlayerItem?) {
        super.init(playerItem: item)
    }

    /**
     Initializes a CLDVideoPlayer instance, using a given URL.

     - parameter url:  The URL to put into AVPlayer

    */
    public override init(url URL: URL) {
        super.init(url: URL)
    }

    /**
     Initializes a CLDVideoPlayer instance, using a given URL.

     - parameter url:  The string to put into AVPlayer

    */
    public init(url string: String) {
        guard let url = URL(string: string) else {
            print("Error - could not generate URL for CLDVideoPlayer")
            super.init()
            return
        }
        super.init(url: url)
    }
}
