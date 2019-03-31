//
// Created by Amir on 05/11/2017.
// Copyright (c) 2017 Cloudinary. All rights reserved.
//

import Foundation

#if swift(>=4.0)
internal extension NSTextCheckingResult {
    func rangeAt(_ idx:Int) -> NSRange {
        return range(at: idx)
    }
}
#endif

