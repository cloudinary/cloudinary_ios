//
//  CLDVideoPreprocessChain.swift
//
//  Copyright (c) 2017 Cloudinary (http://cloudinary.com)
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

public typealias CLDVideoPreprocessStep = (CLDVideoTranscode) throws -> CLDVideoTranscode

public class CLDVideoPreprocessChain: CLDPreprocessChain<CLDVideoTranscode> {
    private var outputURL: URL?

    public override init() {
        super.init()
    }

    internal override func decodeResource(_ resourceData: Any) throws -> CLDVideoTranscode? {
        if let url = resourceData as? URL {
            return CLDVideoTranscode(sourceURL: url)
        } else if let data = resourceData as? Data {
            return try handleLargeVideoData(data)
        } else {
            throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Resource type should be URL or Data only!")
        }
    }

    private func handleLargeVideoData(_ data: Data) throws -> CLDVideoTranscode? {
        var tempDirectory: URL!
        if #available(iOS 10.0, *) {
            tempDirectory = FileManager.default.temporaryDirectory
        } else {
            tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
        }
        let tempURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
        do {
            try data.write(to: tempURL)
            return CLDVideoTranscode(sourceURL: tempURL)
        } catch {
            throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Failed to write data to temporary file: \(error.localizedDescription)")
        }
    }

    public func setOutputFormat(format: AVFileType) -> Self {
        addStep { videoTranscode in
            try videoTranscode.setOutputFormat(format: format)
            return videoTranscode
        }
        return self
    }

    public func setOutputDimensions(dimensions: CGSize) -> Self {
        addStep { videoTranscode in
            videoTranscode.setOutputDimensions(dimensions: dimensions)
            return videoTranscode
        }
        return self
    }

    public func setCompressionPreset(preset: String) -> Self {
        addStep { videoTranscode in
            videoTranscode.setCompressionPreset(preset: preset)
            return videoTranscode
        }
        return self
    }

    internal override func execute(resourceData: Any) throws -> URL {
        try verifyEncoder()

        guard let videoTranscode = try decodeResource(resourceData) else {
            throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Error decoding resource")
        }

        let dispatchGroup = DispatchGroup()
        var resultURL: URL?
        var resultError: Error?

        dispatchGroup.enter()

        DispatchQueue.global(qos: .background).async {
            do {
                var processedTranscode = videoTranscode
                for preprocess in self.chain {
                    processedTranscode = try preprocess(processedTranscode)
                }

                processedTranscode.transcode { success, error in
                    if success, let outputURL = processedTranscode.outputURL {
                        resultURL = outputURL
                    } else {
                        resultError = error ?? CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Error transcoding video")
                    }
                    dispatchGroup.leave()
                }
            } catch {
                resultError = error
                dispatchGroup.leave()
            }
        }

        dispatchGroup.wait()

        if let finalOutputURL = resultURL {
            return finalOutputURL
        } else {
            throw resultError ?? CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Unknown error")
        }
    }

    internal override func verifyEncoder() throws {
        if encoder == nil {
            encoder = { _ in self.outputURL }
        }
    }
}
