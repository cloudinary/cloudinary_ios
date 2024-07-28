import XCTest
import AVFoundation
@testable import Cloudinary

class VideoPreprocessTests: XCTestCase {

    var videoURL: URL!

    // MARK: - Setup and TearDown
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: VideoPreprocessTests.self)
        videoURL = bundle.url(forResource: "dog", withExtension: "mp4")
    }

    override func tearDown() {
        super.tearDown()
        videoURL = nil
    }

    // MARK: - Helper Methods
    fileprivate func getVideoTranscode() -> CLDVideoTranscode {
        return CLDVideoTranscode(sourceURL: videoURL)
    }

    // MARK: - Tests
    func testSetOutputFormat() {
        var video = getVideoTranscode()

        video = try! CLDVideoPreprocessHelpers.setOutputFormat(format: .mp4)(video)
        XCTAssertEqual(video.outputFormat, .mp4)

        video = try! CLDVideoPreprocessHelpers.setOutputFormat(format: .mov)(video)
        XCTAssertEqual(video.outputFormat, .mov)
    }

    func testSetOutputDimensions() {
        var video = getVideoTranscode()
        let dimensions = CGSize(width: 1280, height: 720)

        video = try! CLDVideoPreprocessHelpers.setOutputDimensions(dimensions: dimensions)(video)
        XCTAssertEqual(video.outputDimensions, dimensions)
    }

    func testSetCompressionPreset() {
        var video = getVideoTranscode()
        let preset = AVAssetExportPresetHighestQuality

        video = try! CLDVideoPreprocessHelpers.setCompressionPreset(preset: preset)(video)
        XCTAssertEqual(video.compressionPreset, preset)
    }

    func testDimensionsValidator() {
        var video = getVideoTranscode()
        let dimensions = CGSize(width: 1280, height: 720)

        video = try! CLDVideoPreprocessHelpers.setOutputDimensions(dimensions: dimensions)(video)

        var modifiedVideo = try? CLDVideoPreprocessHelpers.dimensionsValidator(minWidth: 100, maxWidth: 2000, minHeight: 100, maxHeight: 2000)(video)
        XCTAssertNotNil(modifiedVideo)

        modifiedVideo = try? CLDVideoPreprocessHelpers.dimensionsValidator(minWidth: 1300, maxWidth: 2000, minHeight: 100, maxHeight: 2000)(video)
        XCTAssertNil(modifiedVideo)
    }
}
