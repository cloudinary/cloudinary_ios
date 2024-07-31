import XCTest
import AVFoundation
@testable import Cloudinary

class VideoPreprocessTests: XCTestCase {

    var videoURL: URL!
    var invalidVideoURL: URL!
    var notAVideoURL: URL!

    // MARK: - Setup and TearDown
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: VideoPreprocessTests.self)
        videoURL = bundle.url(forResource: "dog", withExtension: "mp4")
        invalidVideoURL = URL(fileURLWithPath: "/invalid/path/to/video.mp4")
        notAVideoURL = bundle.url(forResource: "empty_string", withExtension: "txt")
    }

    override func tearDown() {
        super.tearDown()
        videoURL = nil
        invalidVideoURL = nil
        notAVideoURL = nil
    }

    // MARK: - Helper Methods
    fileprivate func getVideoTranscode(from url: URL) -> CLDVideoTranscode {
        return CLDVideoTranscode(sourceURL: url)
    }

    // MARK: - Tests
    func testSetOutputFormat() {
        var video = getVideoTranscode(from: videoURL)

        video = try! CLDVideoPreprocessHelpers.setOutputFormat(format: .mp4)(video)
        XCTAssertEqual(video.outputFormat, .mp4)

        video = try! CLDVideoPreprocessHelpers.setOutputFormat(format: .mov)(video)
        XCTAssertEqual(video.outputFormat, .mov)
    }

    func testSetOutputDimensions() {
        var video = getVideoTranscode(from: videoURL)
        let dimensions = CGSize(width: 1280, height: 720)

        video = try! CLDVideoPreprocessHelpers.setOutputDimensions(dimensions: dimensions)(video)
        XCTAssertEqual(video.outputDimensions, dimensions)
    }

    func testSetCompressionPreset() {
        var video = getVideoTranscode(from: videoURL)
        let preset = AVAssetExportPresetHighestQuality

        video = try! CLDVideoPreprocessHelpers.setCompressionPreset(preset: preset)(video)
        XCTAssertEqual(video.compressionPreset, preset)
    }

    func testDimensionsValidator() {
        var video = getVideoTranscode(from: videoURL)
        let dimensions = CGSize(width: 1280, height: 720)

        video = try! CLDVideoPreprocessHelpers.setOutputDimensions(dimensions: dimensions)(video)

        var modifiedVideo = try? CLDVideoPreprocessHelpers.dimensionsValidator(minWidth: 100, maxWidth: 2000, minHeight: 100, maxHeight: 2000)(video)
        XCTAssertNotNil(modifiedVideo)

        modifiedVideo = try? CLDVideoPreprocessHelpers.dimensionsValidator(minWidth: 1300, maxWidth: 2000, minHeight: 100, maxHeight: 2000)(video)
        XCTAssertNil(modifiedVideo)
    }

    func testInvalidURL() {
        let video = getVideoTranscode(from: invalidVideoURL)
        XCTAssertThrowsError(try CLDVideoPreprocessHelpers.setOutputFormat(format: .mp4)(video)) { error in
            XCTAssertEqual((error as NSError).domain, "CLDVideoPreprocessHelpers")
        }
    }

    func testNotAVideo() {
        let video = getVideoTranscode(from: notAVideoURL)
        XCTAssertThrowsError(try CLDVideoPreprocessHelpers.setOutputFormat(format: .mp4)(video)) { error in
            XCTAssertEqual((error as NSError).domain, "CLDVideoPreprocessHelpers")
        }
    }

    func testMissingVideoTrack() {
        let video = getVideoTranscode(from: videoURL)
        XCTAssertTrue(video.hasVideoTrack, "Original video should have a video track")

        let noVideoTrackURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")

        let fileManager = FileManager.default
        let fileContents = Data()
        fileManager.createFile(atPath: noVideoTrackURL.path, contents: fileContents)

        let noVideoTrackTranscode = getVideoTranscode(from: noVideoTrackURL)
        XCTAssertFalse(noVideoTrackTranscode.hasVideoTrack, "The mock video should not have a video track")

        do {
            _ = try CLDVideoPreprocessHelpers.setOutputFormat(format: .mp4)(noVideoTrackTranscode)
            XCTFail("Expected to throw an error for missing video track")
        } catch {
            XCTAssertEqual((error as NSError).domain, "CLDVideoPreprocessHelpers")
        }
    }


}
