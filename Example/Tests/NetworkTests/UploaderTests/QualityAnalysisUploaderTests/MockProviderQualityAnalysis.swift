//
//  MockProviderQualityAnalysis.swift
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

public class MockProviderQualityAnalysis: BaseMockProvider {
    
    // MARK: - json result
    override class func jsonString() -> String {
      
        return "{\"asset_id\":\"c9c2e940e1e5db90269f97af090b57fe\",\"public_id\":\"x7ldagsqc4wyyidbjahc\",\"version\":1602752171,\"version_id\":\"5f0199de7decc33210c6553c30e2ff57\",\"signature\":\"5d828d573c800ad8477b57f049add2b37eeff7cf\",\"width\":1144,\"height\":1048,\"format\":\"jpg\",\"resource_type\":\"image\",\"created_at\":\"2020-10-15T08:56:11Z\",\"tags\":[],\"pages\":1,\"bytes\":64893,\"type\":\"upload\",\"etag\":\"aa1a546faf1dad85ef49f6f6a2875602\",\"placeholder\":false,\"url\":\"http://res.cloudinary.com/ginidev/image/upload/v1602752171/x7ldagsqc4wyyidbjahc.jpg\",\"secure_url\":\"https://res.cloudinary.com/ginidev/image/upload/v1602752171/x7ldagsqc4wyyidbjahc.jpg\",\"access_mode\":\"public\",\"quality_analysis\":{\"jpeg_quality\":0.89,\"jpeg_chroma\":0.25,\"focus\":1.0,\"noise\":1.0,\"contrast\":0.99,\"exposure\":1.0,\"saturation\":1.0,\"lighting\":1.0,\"pixel_score\":0.9,\"color_score\":1.0,\"dct\":0.91,\"blockiness\":1.0,\"chroma_subsampling\":0.0,\"resolution\":0.58},\"quality_score\":0.76,\"original_filename\":\"textImage\"}"
    }
}
