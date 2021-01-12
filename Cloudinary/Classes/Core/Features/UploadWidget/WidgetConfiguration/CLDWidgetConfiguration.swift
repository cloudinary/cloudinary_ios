//
//  CLDWidgetConfiguration.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
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

import UIKit

@objcMembers public class CLDWidgetConfiguration: NSObject {
    
    public var allowRotate           : Bool
    public var initialAspectLockState: AspectRatioLockState
    public var uploadType            : CLDUploadType
    
    // MARK: - init
    /**
    Initializes the `CLDWidgetConfiguration` instance with the specified allowRotate, initialAspectLockState and uploadType.
     
    - parameter allowRotate:             A boolean value specifying whether or not to allow image rotation. true by default.
    - parameter initialAspectLockState:  Enum value specifying the initial aspect ratio lock state. enabledAndOn by default.
    - parameter uploadType:              CLDUploadType object specifying the upload request type. signed without preset by default.
    
    - returns: The new `CLDWidgetConfiguration` instance.
    */
    public init(
        allowRotate           : Bool = true,
        initialAspectLockState: AspectRatioLockState = .enabledAndOff,
        uploadType            : CLDUploadType = CLDUploadType(signed: true, preset: nil)
    ) {
        self.allowRotate            = allowRotate
        self.initialAspectLockState = initialAspectLockState
        self.uploadType             = uploadType
        
        super.init()
    }
    
    // MARK: - AspectRatioLockState
    /**
    Aspect ratio lock state
    * enabledAndOff: User can change the aspect ratio lock state - initial state is aspect ratio not locked.
    * enabledAndOn: User can change the aspect ratio lock state - initial state is aspect ratio locked.
    * disabled: Aspect ratio lock state button is removed. User will be able to change the aspect ratio of the image, but not the lock state.
    */
    @objc public enum AspectRatioLockState: Int {
        
        case enabledAndOff
        case enabledAndOn
        case disabled
    }
}

@objcMembers public class CLDUploadType: NSObject {
    
    private(set) var signed: Bool
    private(set) var preset: String?
    
    /**
    Initializes the `CLDUploadType` instance with the specified signed and preset.
     
    - parameter signed:             A boolean value specifying whether to use signed or unsigned upload.
    - parameter preset:             A string represents the preset for unsigned upload requests. preset MUST be set when choosing unsigned requests.
    
    - returns: The new `CLDUploadType` instance.
    */
    public init(signed: Bool, preset: String?) {
        
        self.signed = signed
        self.preset = preset
        
        if !signed, (preset == nil || preset == String()) {
            print("unsigned upload must have a predefined preset!")
        }
    }
}
