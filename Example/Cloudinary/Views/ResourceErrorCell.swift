//
//  ResourceErrorCell.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 30/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

class ResourceErrorCell: UICollectionViewCell {
    // MARK: Properties
    @IBOutlet weak var imageView: CLDUIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var errorDescription: UILabel!
}
