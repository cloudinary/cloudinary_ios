//
//  CLDVideoPlayerTests.swift
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

import XCTest
import Cloudinary
import AVFoundation
import AVKit

class CLDVideoPlayerTests: UIBaseTest {

    // MARK: - Tests

    func testVideoLoadingAndSetFromURL() {
        var videoLoadedAndSet = false
        let videoPlayer = CLDVideoPlayer(url: "https://testurl.com")
        if videoPlayer.currentItem != nil {
            videoLoadedAndSet = true
        }
        XCTAssertTrue(videoLoadedAndSet)
    }

    func testInitializationWithValidData() {
        let publicId = "test_public_id"
        let transformation = CLDTransformation().setWidth(640).setHeight(480)

        let player = CLDVideoPlayer(publicId: publicId, cloudinary: cloudinarySecured, transformation: transformation)

        XCTAssertNotNil(player, "CLDVideoPlayer should initialize with valid data.")
    }


    func testPlaybackPauses() {
        var publicId: String? = ""
        let file = TestResourceType.dog.url
        let params = CLDUploadRequestParams().setColors(true)
        params.setResourceType(.video)

        XCTAssertNotNil(publicId)
        let player = CLDVideoPlayer(url: file)

        // Assuming you have a test expectation for the video to pause.
        let expectation = XCTestExpectation(description: "Video should pause.")

        // Start playing and pause after 2 seconds.
        player.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            player.pause()
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
