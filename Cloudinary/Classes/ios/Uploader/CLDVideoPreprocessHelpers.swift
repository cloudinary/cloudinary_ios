import AVFoundation
import UIKit

public class CLDVideoPreprocessHelpers {

    public static func setOutputDimensions(dimensions: CGSize) -> (CLDVideoTranscode) throws -> CLDVideoTranscode {
        return { transcode in
            transcode.outputDimensions = dimensions
            return transcode
        }
    }

    public static func setOutputFormat(format: AVFileType) -> (CLDVideoTranscode) throws -> CLDVideoTranscode {
        return { transcode in
            transcode.outputFormat = format
            return transcode
        }
    }

    public static func setCompressionPreset(preset: String) -> (CLDVideoTranscode) throws -> CLDVideoTranscode {
        return { transcode in
            transcode.compressionPreset = preset
            return transcode
        }
    }

    public static func dimensionsValidator(minWidth: CGFloat, maxWidth: CGFloat, minHeight: CGFloat, maxHeight: CGFloat) -> ((CLDVideoTranscode) throws -> CLDVideoTranscode) {
        return { videoTranscode in
            guard let dimensions = videoTranscode.outputDimensions else {
                throw NSError(domain: "CLDVideoPreprocessHelpers", code: 0, userInfo: [NSLocalizedDescriptionKey: "Video dimensions not set"])
            }
            if dimensions.width < minWidth || dimensions.width > maxWidth || dimensions.height < minHeight || dimensions.height > maxHeight {
                throw NSError(domain: "CLDVideoPreprocessHelpers", code: 0, userInfo: [NSLocalizedDescriptionKey: "Video dimensions out of bounds"])
            }
            return videoTranscode
        }
    }
}
