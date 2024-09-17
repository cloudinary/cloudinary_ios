import Foundation
import AVFoundation

public class CLDVideoTranscode {
    let sourceURL: URL
    var outputURL: URL?
    var outputFormat: AVFileType = .mov
    var outputDimensions: CGSize?
    var compressionPreset: String = AVAssetExportPresetPassthrough // Default to passthrough

    init(sourceURL: URL) {
        self.sourceURL = sourceURL
    }

    func setOutputFormat(format: AVFileType) throws {
        guard FileManager.default.fileExists(atPath: sourceURL.path) else {
            throw NSError(domain: "CLDVideoPreprocessHelpers", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid source URL"])
        }

        let asset = AVAsset(url: sourceURL)
        guard asset.tracks(withMediaType: .video).first != nil else {
            throw NSError(domain: "CLDVideoPreprocessHelpers", code: -1, userInfo: [NSLocalizedDescriptionKey: "No video track found"])
        }

        self.outputFormat = format
    }

    func setOutputDimensions(dimensions: CGSize) {
        self.outputDimensions = dimensions
    }

    func setCompressionPreset(preset: String) {
        self.compressionPreset = preset
    }

    var hasVideoTrack: Bool {
        let asset = AVAsset(url: sourceURL)
        return asset.tracks(withMediaType: .video).first != nil
    }

    func transcode(completion: @escaping (Bool, Error?) -> Void) {
        let asset = AVAsset(url: sourceURL)
        let outputURL = generateOutputURL()

        do {
            // Create asset reader
            let assetReader = try AVAssetReader(asset: asset)
            guard let videoTrack = asset.tracks(withMediaType: .video).first else {
                throw NSError(domain: "CLDVideoTranscode", code: -1, userInfo: [NSLocalizedDescriptionKey: "No video track found"])
            }

            // Configure output settings for AVAssetReader
            let assetReaderOutputSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB
            ]

            let assetReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: assetReaderOutputSettings)

            // Add the output to the reader
            assetReader.add(assetReaderOutput)

            // Create asset writer
            let assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: outputFormat)
            let videoSettings: [String: Any] = [
                AVVideoWidthKey: outputDimensions?.width ?? videoTrack.naturalSize.width,
                AVVideoHeightKey: outputDimensions?.height ?? videoTrack.naturalSize.height
            ]

            let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            assetWriterInput.expectsMediaDataInRealTime = true
            assetWriter.add(assetWriterInput)

            // Start reading and writing
            assetReader.startReading()
            assetWriter.startWriting()
            assetWriter.startSession(atSourceTime: .zero)

            assetWriterInput.requestMediaDataWhenReady(on: DispatchQueue(label: "assetWriterQueue")) {
                while assetWriterInput.isReadyForMoreMediaData {
                    guard assetReader.status == .reading else {
                        let error = assetReader.error ?? NSError(domain: "CLDVideoTranscode", code: -1, userInfo: [NSLocalizedDescriptionKey: "Asset reader status is not reading"])
                        completion(false, error)
                        return
                    }

                    if let sampleBuffer = assetReaderOutput.copyNextSampleBuffer() {
                        assetWriterInput.append(sampleBuffer)
                    } else {
                        assetWriterInput.markAsFinished()
                        assetWriter.finishWriting {
                            defer {
                                if self.sourceURL.isFileURL {
                                    try? FileManager.default.removeItem(at: self.sourceURL)
                                }
                            }

                            if assetWriter.status == .completed {
                                self.outputURL = assetWriter.outputURL
                                completion(true, nil)
                            } else {
                                completion(false, assetWriter.error)
                            }
                        }
                        break
                    }
                }
            }
        } catch {
            completion(false, error)
        }
    }

    private func generateOutputURL() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension(outputFormat.fileExtension)
    }
}

private extension AVFileType {
    var fileExtension: String {
        switch self {
        case .mov:
            return "mov"
        case .mp4:
            return "mp4"
        case .m4v:
            return "m4v"
        default:
            return "mov"
        }
    }
}
