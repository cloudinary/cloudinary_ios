//
//  SingleUploadCollectionLayout.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 12/05/2024.
//

import Foundation
import UIKit

class SingleUploadCollectionLayout: UICollectionViewFlowLayout {

    var singleItemAttributes: UICollectionViewLayoutAttributes?

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        // Calculate item size to occupy one-third of the collection view's width
        let itemWidth = (collectionView.bounds.width - minimumInteritemSpacing * 2 - minimumLineSpacing * 2) / 3
        itemSize = CGSize(width: itemWidth, height: itemWidth)

        // Calculate horizontal inset to center items
        let inset = (collectionView.bounds.width - CGFloat(3) * itemWidth - minimumInteritemSpacing * 2) / 2

        // Set section inset
        sectionInset = UIEdgeInsets(top: sectionInset.top, left: inset, bottom: sectionInset.bottom, right: inset)

        // Adjust alignment for single item
        if collectionView.numberOfItems(inSection: 0) == 1 {
            let indexPath = IndexPath(item: 0, section: 0)
            singleItemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            singleItemAttributes?.frame.origin = CGPoint(x: sectionInset.left, y: sectionInset.top)
        } else {
            singleItemAttributes = nil
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let singleItemAttributes = singleItemAttributes {
            return [singleItemAttributes]
        } else {
            return super.layoutAttributesForElements(in: rect)
        }
    }
}
