//
//  BaseViewController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 04/01/2024.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vwBack: UIView!
    var type: BaseControllerType!
    var innerIndex: Int = 0

    var currentController: UIViewController!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle()
        setController()
        setBackButton()
    }

    private func setBackButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backClicked))
        vwBack.addGestureRecognizer(tapGesture)
    }

    private func setTitle() {
        switch type {
        case .Optimization:
            lbTitle.text = "Optimization"
            break
        case .Transform:
            lbTitle.text = "Transform"
            break
        case .Upload:
            lbTitle.text = "Upload"
            break
        case .UploadLarge:
            lbTitle.text = "Upload Large"
            break
        case .FetchUpload:
            lbTitle.text = "Fetch Upload"
            break
        case .UploadWidget:
            lbTitle.text = "Upload Widget"
            break
        case .ImageWidget:
            lbTitle.text = "Image Widget"
            break
        case .UseCases:
            lbTitle.text = "Use Cases"
            break
        case .none:
            break
        }
    }

    private func setController() {
            switch type {
            case .Optimization:
                currentController = UIStoryboard(name: "Optimization", bundle: nil).instantiateViewController(identifier: "OptimizationViewController") as! OptimizationViewController
                currentController.view.frame = vwContainer.bounds
                (currentController as! OptimizationViewController).type = .Optimization
                addChild(currentController)
                vwContainer.addSubview(currentController.view)
                currentController.didMove(toParent: self)
            case .Transform:
                currentController = UIStoryboard(name: "Transform", bundle: nil).instantiateViewController(identifier: "TransformViewController") as! TransformViewController
                (currentController as! TransformViewController).innerIndex = innerIndex
                currentController.view.frame = vwContainer.bounds
                addChild(currentController)
                vwContainer.addSubview(currentController.view)
                currentController.didMove(toParent: self)
            case .UseCases:
                currentController = UIStoryboard(name: "UseCases", bundle: nil).instantiateViewController(identifier: "UseCasesViewController") as! UseCasesViewController
                currentController.view.frame = vwContainer.bounds
                (currentController as! UseCasesViewController).innerIndex = innerIndex
                addChild(currentController)
                vwContainer.addSubview(currentController.view)
                currentController.didMove(toParent: self)
            case .Upload:
                currentController = (UIStoryboard(name: "UploadChoice", bundle: nil).instantiateViewController(identifier: "UploadChoiceController") as! UploadChoiceController)
                currentController.view.frame = vwContainer.bounds
                (currentController as! UploadChoiceController).type = .Upload
                addChild(currentController)
                vwContainer.addSubview(currentController.view)
                currentController.didMove(toParent: self)
            case .UploadLarge:
                currentController = (UIStoryboard(name: "UploadChoice", bundle: nil).instantiateViewController(identifier: "UploadChoiceController") as! UploadChoiceController)
                currentController.view.frame = vwContainer.bounds
                (currentController as! UploadChoiceController).type = .UploadLarge
                addChild(currentController)
                vwContainer.addSubview(currentController.view)
                currentController.didMove(toParent: self)
            case .FetchUpload:
                 currentController = UIStoryboard(name: "Optimization", bundle: nil).instantiateViewController(identifier: "OptimizationViewController") as! OptimizationViewController
                currentController.view.frame = vwContainer.bounds
                (currentController as! OptimizationViewController).publicId = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Leonardo_da_Vinci_%281452-1519%29_-_The_Last_Supper_%281495-1498%29.jpg/1600px-Leonardo_da_Vinci_%281452-1519%29_-_The_Last_Supper_%281495-1498%29.jpg?20150402075721"
                (currentController as! OptimizationViewController).type = .FetchUpload
                addChild(currentController)
                vwContainer.addSubview(currentController.view)
                currentController.didMove(toParent: self)
            case .UploadWidget:
                if (currentController == nil || (currentController as? UploadWidgetViewController == nil)) {
                    currentController = UIStoryboard(name: "UploadWidget", bundle: nil).instantiateViewController(identifier: "UploadWidgetViewController")
                    currentController.view.frame = vwContainer.bounds
                    addChild(currentController)
                    vwContainer.addSubview(currentController.view)
                    currentController.didMove(toParent: self)
                }
            case .ImageWidget:
                 currentController = UIStoryboard(name: "ImageWidget", bundle: nil).instantiateViewController(identifier: "ImageWidgetViewController")
                currentController.view.frame = vwContainer.bounds
                addChild(currentController)
                vwContainer.addSubview(currentController.view)
        case .none:
            break
        }
    }

    @objc private func backClicked() {
        self.dismiss(animated: true)
    }
}

enum BaseControllerType {
    case Optimization
    case Transform
    case Upload
    case UploadLarge
    case FetchUpload
    case UploadWidget
    case ImageWidget
    case UseCases
}
public enum UploadViewType {
    case Upload
    case UploadLarge
    case UploadWidget
}

public enum OptimizationViewType {
    case Optimization
    case FetchUpload
}
