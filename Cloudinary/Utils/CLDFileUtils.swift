//
//
//  CLDFileUtils.swift
//
//  Copyright (c) 2017 Cloudinary (http://cloudinary.com)
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

internal class CLDFileUtils {
    internal static func getFileSize(url: URL)->Int64?{
        let attr = try? FileManager.default.attributesOfItem(atPath: url.path)
        return attr?[FileAttributeKey.size] as? Int64
    }

    internal static func removeFile(file: CLDPartDescriptor) {
        try? FileManager.default.removeItem(at: file.url)
    }

    internal static func removeFiles(files: [CLDPartDescriptor]) {
        for file in files {
            removeFile (file: file)
        }
    }

    internal static func splitFile(url: URL, name:String, chunkSize: Int) -> [CLDPartDescriptor]?{
        let maxBufferSize = 16 * 1024
        var names = [URL]()
        var outputStream:OutputStream?
        var success = false
        var parts = [CLDPartDescriptor]()
        guard let inputStream = InputStream(url: url) else {
            return nil
        }
    
        defer {
            inputStream.close()
            outputStream?.close()
            
            // clean up files if something failed mid-process
            if (!success) {
                removeFiles(files: parts)
            }
        }
        
        inputStream.open()
        
        let bufferSize = min(chunkSize, maxBufferSize)
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        
        var currentChunkBytes = 0
        var chunkIndex = 0
        var targetUrl: URL!
        var totalRead:Int64 = 0
        
        while inputStream.hasBytesAvailable {
            let read = inputStream.read(&buffer, maxLength: calcReadSize(currentChunkBytes, chunkSize, bufferSize))

            if (read == 0) {
                continue
            }
            
            if (outputStream == nil){
                targetUrl = getTempFileUrl(fileName: name + "_part\(chunkIndex)")
                outputStream = OutputStream(url: targetUrl!, append: false)
                
                guard (outputStream != nil) else {
                    return nil
                }
                
                outputStream?.open()
            }
    
            currentChunkBytes += read
            totalRead += Int64(read)
            outputStream!.write(&buffer, maxLength: read)
            
            if (currentChunkBytes >= chunkSize) {
                // wrap up current chunk:
                outputStream?.close()
                outputStream = nil
                parts.append(CLDPartDescriptor(url: targetUrl, offset: totalRead - Int64(currentChunkBytes), length: currentChunkBytes))
                currentChunkBytes = 0
                chunkIndex += 1
            }
        }
        
        if (outputStream != nil) {
            // wrap up last chunk's last chunk:
            parts.append(CLDPartDescriptor(url: targetUrl, offset: totalRead - Int64(currentChunkBytes), length: currentChunkBytes))
        }
        
        success = true
        return parts
    }
    
    fileprivate static func calcReadSize(_ currentChunkBytes: Int, _ chunkSize: Int, _ bufferSize: Int) -> Int {
        let chunkSpaceLeft = chunkSize - currentChunkBytes
        let maxLength = min(bufferSize, chunkSpaceLeft)
        return maxLength
    }

    internal static func getTempFileUrl(fileName: String) -> URL{
        return NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)!
    }
}

public struct CLDPartDescriptor {
    public let url: URL
    public let offset: Int64
    public let length: Int
}
