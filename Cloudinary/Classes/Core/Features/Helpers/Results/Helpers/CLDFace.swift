//
//  CLDFace.swift
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

@objcMembers open class CLDFace: CLDBaseResult {
    
    open var boundingBox: CLDBoundingBox? {
        guard let bb = getParam(.boundingBox) as? [String : AnyObject] else {
            return nil
        }
        return CLDBoundingBox(json: bb)
    }
    
    open var confidence: Double? {
        return getParam(.confidence) as? Double
    }
    
    open var age: Double? {
        return getParam(.age) as? Double
    }
    
    open var smile: Double? {
        return getParam(.smile) as? Double
    }
    
    open var glasses: Double? {
        return getParam(.glasses) as? Double
    }
    
    open var sunglasses: Double? {
        return getParam(.sunglasses) as? Double
    }
    
    open var beard: Double? {
        return getParam(.beard) as? Double
    }
    
    open var mustache: Double? {
        return getParam(.mustache) as? Double
    }
    
    open var eyeClosed: Double? {
        return getParam(.eyeClosed) as? Double
    }
    
    open var mouthOpenWide: Double? {
        return getParam(.mouthOpenWide) as? Double
    }
    
    open var beauty: Double? {
        return getParam(.beauty) as? Double
    }
    
    open var gender: Double? {
        return getParam(.gender) as? Double
    }
    
    open var race: [String : Double]? {
        return getParam(.race) as? [String : Double]
    }
    
    open var emotion: [String : Double]? {
        return getParam(.emotion) as? [String : Double]
    }
    
    open var quality: [String : Double]? {
        return getParam(.quality) as? [String : Double]
    }
    
    open var pose: [String : Double]? {
        return getParam(.pose) as? [String : Double]
    }
    
    open var eyeLeftPosition: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeLeftPosition))
    }
    
    open var eyeRightPosition: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeRightPosition))
    }
    
    open var eyeLeft_Left: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeLeft_Left))
    }
    
    open var eyeLeft_Right: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeLeft_Right))
    }
    
    open var eyeLeft_Up: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeLeft_Up))
    }
    
    open var eyeLeft_Down: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeLeft_Down))
    }
    
    open var eyeRight_Left: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeRight_Left))
    }
    
    open var eyeRight_Right: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeRight_Right))
    }
    
    open var eyeRight_Up: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeRight_Up))
    }
    
    open var eyeRight_Down: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.eyeRight_Down))
    }
    
    open var nosePosition: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.nosePosition))
    }
    
    open var noseLeft: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.noseLeft))
    }
    
    open var noseRight: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.noseRight))
    }
    
    open var mouthLeft: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.mouthLeft))
    }
    
    open var mouthRight: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.mouthRight))
    }
    
    open var mouthUp: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.mouthUp))
    }
    
    open var mouthDown: CGPoint? {
        return CLDBoundingBox.parsePoint(resultJson, key: String(describing: CLDFaceKey.mouthDown))
    }
    
    // MARK: - Private Helpers
    
    fileprivate func getParam(_ param: CLDFaceKey) -> AnyObject? {
        return resultJson[String(describing: param)]
    }
    
    fileprivate enum CLDFaceKey: CustomStringConvertible {
        case boundingBox, confidence, age, smile, glasses, sunglasses, beard, mustache, eyeClosed, mouthOpenWide, beauty, gender, race, emotion, quality, pose, eyeLeftPosition, eyeRightPosition, eyeLeft_Left, eyeLeft_Right, eyeLeft_Up, eyeLeft_Down, eyeRight_Left, eyeRight_Right, eyeRight_Up, eyeRight_Down, nosePosition, noseLeft, noseRight, mouthLeft, mouthRight, mouthUp, mouthDown
        
        var description: String {
            switch self {
            case .boundingBox:          return "boundingbox"
            case .confidence:           return "confidence"
            case .age:                  return "age"
            case .smile:                return "smile"
            case .glasses:              return "glasses"
            case .sunglasses:           return "sunglasses"
            case .beard:                return "beard"
            case .mustache:             return "mustache"
            case .eyeClosed:            return "eye_closed"
            case .mouthOpenWide:        return "mouth_open_wide"
            case .beauty:               return "beauty"
            case .gender:               return "sex"
            case .race:                 return "race"
            case .emotion:              return "emotion"
            case .quality:              return "quality"
            case .pose:                 return "pose"
            case .eyeLeftPosition:      return "eye_left"
            case .eyeRightPosition:     return "eye_right"
            case .eyeLeft_Left:         return "e_ll"
            case .eyeLeft_Right:        return "e_lr"
            case .eyeLeft_Up:           return "e_lu"
            case .eyeLeft_Down:         return "e_ld"
            case .eyeRight_Left:        return "e_rl"
            case .eyeRight_Right:       return "e_rr"
            case .eyeRight_Up:          return "e_ru"
            case .eyeRight_Down:        return "e_rd"
            case .nosePosition:         return "nose"
            case .noseLeft:             return "n_l"
            case .noseRight:            return "n_r"
            case .mouthLeft:            return "mouth_l"
            case .mouthRight:           return "mouth_r"
            case .mouthUp:              return "m_u"
            case .mouthDown:            return "m_d"
            }
        }
    }
}
