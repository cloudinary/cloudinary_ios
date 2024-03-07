//
//  DeliveryViewController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 28/12/2023.
//

import Foundation
import UIKit

class DeliveryViewController: UIViewController {
    @IBOutlet weak var vwOptimization: UIView!
    @IBOutlet weak var vwTransform: UIView!
    @IBOutlet weak var vwUseCases: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var cvTransformation: UICollectionView!
    @IBOutlet weak var cvUseCases: UICollectionView!
    
    var transfromationCollectionController: DeliveryTransformCollectionController!
    var useCasesCollectionController: DeliveryUseCasesCollectionController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setOptimizationView()
        setTransformationCollectionView()
        setUseCasesCollectionView()
    }

    private func setOptimizationView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optimizationClicked))

        vwOptimization.addGestureRecognizer(tapGesture)
    }

    @objc private func optimizationClicked() {
        if let controller = UIStoryboard(name: "Base", bundle: nil).instantiateViewController(identifier: "BaseViewController") as? BaseViewController {
            controller.type = .Optimization
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }

    @objc private func transformClicked(_ index: Int) {
        if let controller = UIStoryboard(name: "Base", bundle: nil).instantiateViewController(identifier: "BaseViewController") as? BaseViewController {
            controller.type = .Transform
            controller.innerIndex = index
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }

    @objc private func useCasesClicked(_ index: Int) {
        if let controller = UIStoryboard(name: "Base", bundle: nil).instantiateViewController(identifier: "BaseViewController") as? BaseViewController {
            controller.innerIndex = index
            controller.type = .UseCases
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }

    private func setTransformationCollectionView() {
        transfromationCollectionController = DeliveryTransformCollectionController(self)
        cvTransformation.dataSource = transfromationCollectionController
        cvTransformation.delegate = transfromationCollectionController
    }

    private func setUseCasesCollectionView() {
        useCasesCollectionController = DeliveryUseCasesCollectionController(self)
        cvUseCases.delegate = useCasesCollectionController
        cvUseCases.dataSource = useCasesCollectionController
    }
}

extension DeliveryViewController: DeliveryTransformCollectionDelegate {
    func transformCellSelected(_ index: Int) {
        transformClicked(index)
    }
}

extension DeliveryViewController: DeliverUseCaseCollectionDelegate {
    func useCaseCellSelected(_ index: Int) {
        useCasesClicked(index)
    }
}
