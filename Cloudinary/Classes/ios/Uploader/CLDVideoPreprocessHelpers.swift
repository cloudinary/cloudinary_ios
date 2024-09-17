import Foundation
import AVKit

public class CLDVideoPreprocessHelpers {

    private var steps: [(CLDVideoTranscode) throws -> CLDVideoTranscode] = []

    public func addStep(_ step: @escaping (CLDVideoTranscode) throws -> CLDVideoTranscode) {
        steps.append(step)
    }

    public static func setOutputFormat(format: AVFileType) -> CLDVideoPreprocessStep {
        return { videoTranscode in
            do {
                try videoTranscode.setOutputFormat(format: format)
            } catch {
                throw error
            }
            return videoTranscode
        }
    }

    public static func setOutputDimensions(dimensions: CGSize) -> CLDVideoPreprocessStep {
        return { videoTranscode in
            videoTranscode.setOutputDimensions(dimensions: dimensions)
            return videoTranscode
        }
    }

    public static func setCompressionPreset(preset: String) -> CLDVideoPreprocessStep {
        return { videoTranscode in
            videoTranscode.setCompressionPreset(preset: preset)
            return videoTranscode
        }
    }

    public static func dimensionsValidator(minWidth: CGFloat, maxWidth: CGFloat, minHeight: CGFloat, maxHeight: CGFloat) -> CLDVideoPreprocessStep {
        return { videoTranscode in
            guard let dimensions = videoTranscode.outputDimensions else {
                throw NSError(domain: "CLDVideoPreprocessHelpers", code: -1, userInfo: [NSLocalizedDescriptionKey: "Dimensions not set"])
            }
            if dimensions.width < minWidth || dimensions.width > maxWidth || dimensions.height < minHeight || dimensions.height > maxHeight {
                throw VideoPreprocessError.dimensionsOutOfRange
            }
            return videoTranscode
        }
    }
}

enum VideoPreprocessError: Error {
    case dimensionsOutOfRange
}
