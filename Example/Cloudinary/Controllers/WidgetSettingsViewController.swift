//
//  WidgetSettingsViewController.swift
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
import Cloudinary

class WidgetSettingsViewController: UIViewController {
    
    var allowRotate  = true
    
    var initialAspect: CLDWidgetConfiguration.AspectRatioLockState = .enabledAndOff
    var initialImages: InitialImagesState                          = .many
    
    var uploaderWidget: CLDUploaderWidget!
    
    @IBAction func allowRotateChanged(_ sender: UISwitch) {
        allowRotate = sender.isOn
    }
    
    @IBAction func initialAspectChanged(_ sender: UISegmentedControl) {
        initialAspect = CLDWidgetConfiguration.AspectRatioLockState(rawValue: sender.selectedSegmentIndex)!
    }
    
    @IBAction func initialImages(_ sender: UISegmentedControl) {
        initialImages = InitialImagesState(rawValue: sender.selectedSegmentIndex)!
    }
    
    @IBAction func presentWidget(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let uploadType    = UploadType(signed: false, preset: "ios_sample")
        let configuration = CLDWidgetConfiguration(allowRotate: allowRotate, initialAspectLockState: initialAspect, uploadType: uploadType)
        
        uploaderWidget = CLDUploaderWidget(cloudinary: appDelegate.cloudinary!, configuration: configuration, images: initialImages.images, delegate: self)
        
        uploaderWidget.presentWidget(from: self)
    }
    
    enum InitialImagesState: Int {
        case many
        case one
        case none
        
        var images: [UIImage] {
            
            switch self {
            case .many: return [#imageLiteral(resourceName: "dog2"),#imageLiteral(resourceName: "longDog"),#imageLiteral(resourceName: "dog2"),#imageLiteral(resourceName: "dog1"),#imageLiteral(resourceName: "dog2"),#imageLiteral(resourceName: "dog1"),#imageLiteral(resourceName: "dog2")]
            case .one : return [#imageLiteral(resourceName: "dog1")]
            case .none: return []
            }
        }
    }
}

extension WidgetSettingsViewController: CLDUploaderWidgetDelegate {
    func uploadWidget(_ widget: CLDUploaderWidget, willCall uploadRequests: [CLDUploadRequest]) {
        print("uploader widget delegate - will call")
    }
    
    func widgetDidCancel(_ widget: CLDUploaderWidget) {
        print("uploader widget delegate -  did cancel")
    }
    
    func uploadWidgetDidDismiss() {
        print("uploader widget delegate - did dismiss")
    }
}
