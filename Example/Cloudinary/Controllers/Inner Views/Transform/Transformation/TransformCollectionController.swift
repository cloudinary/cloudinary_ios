//
//  TransformCollectionController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 08/01/2024.
//

import Foundation
import UIKit
import Cloudinary

protocol TransformCollectionDelegate {
    func cellSelected(_ index: Int)
}

class TransformCollectionController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var delegate: TransformCollectionDelegate

    var selectedCellIndex = 0

    init(_ delegate: TransformCollectionDelegate) {
        self.delegate = delegate
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformCollectionCell", for: indexPath) as! TransformCollectionCell
        cell.setCellBy(index: indexPath.row)
        setSelectedCell(cell, index: indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let previousSelectedIndexPath = selectedCellIndex
         selectedCellIndex = indexPath.row
         delegate.cellSelected(indexPath.row)
         updateSelectedCellAppearance(collectionView, indexPath)
         updateSelectedCellAppearance(collectionView, IndexPath(row: previousSelectedIndexPath, section: 0))
     }

     func updateSelectedCellAppearance(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
         if let cell = collectionView.cellForItem(at: indexPath) as? TransformCollectionCell {
             setSelectedCell(cell, index: indexPath.row)
         }
     }

    func setSelectedCell(_ cell: TransformCollectionCell, index: Int) {
        if index == selectedCellIndex {
            cell.isSelected = true
            cell.layer.borderColor = UIColor(named: "primary")?.cgColor
            cell.layer.borderWidth = 3
            cell.layer.cornerRadius = 4
        } else {
            cell.layer.borderWidth = 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 84, height: 116)
    }
}
