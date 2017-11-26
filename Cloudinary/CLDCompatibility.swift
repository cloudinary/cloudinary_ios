//
// Created by Amir on 05/11/2017.
// Copyright (c) 2017 Cloudinary. All rights reserved.
//

import Foundation
//
//func range(for obj:NSTextCheckingResult, at idx:Int) -> NSRange {
//    #if swift(>=4.0)
//        return obj.range(at: idx)
//    #else
//        return obj.rangeAt(idx)
//    #endif
//}

#if swift(>=4.0)
internal extension NSTextCheckingResult {
    internal func rangeAt(_ idx:Int) -> NSRange {
        return range(at: idx)
    }
}
#endif

