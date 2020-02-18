//
//  ResourceInProgressCell.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 31/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

class ResourceInProgressCell: UICollectionViewCell {
    // MARK: Properties
    @IBOutlet weak var imageView: CLDUIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
}
