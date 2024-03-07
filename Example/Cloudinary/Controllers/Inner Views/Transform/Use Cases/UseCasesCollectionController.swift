//
//  UseCasesCollectionController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 21/02/2024.
//

import Foundation
import UIKit

protocol UseCasesCollectionDelegate {
    func cellSelected(_ index: Int)
}

class UseCasesCollectionController: NSObject,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var delegate: UseCasesCollectionDelegate

    var selectedCellIndex = 0

    init(_ delegate: UseCasesCollectionDelegate) {
        self.delegate = delegate
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UseCaseCollectionCell", for: indexPath) as! UseCaseCollectionCell
        cell.setCellBy(index: indexPath.row)
        setSelectedCell(cell, index: indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        delegate.cellSelected(indexPath.row)
        collectionView.reloadData()
    }

    private func setSelectedCell(_ cell: UseCaseCollectionCell, index: Int) {
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
        return CGSize(width: 80, height: 116)
    }

}
