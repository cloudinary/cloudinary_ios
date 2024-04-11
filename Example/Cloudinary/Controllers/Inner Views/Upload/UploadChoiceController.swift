//
//  UploadChoiceController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 30/01/2024.
//

import Foundation
import UIKit

protocol UploadChoiceControllerDelegate: AnyObject {
    func switchToController(_ uploadState: UploadChoiceState, url: String?)
    func dismissController()
}

class UploadChoiceController: UIViewController {

    @IBOutlet weak var vwContainer: UIView!

    var currentController: UIViewController!

    var type: UploadViewType = .Upload

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CloudinaryHelper.shared.getUploadCloud() == nil {
            setContainerView(.NoCloudName)
        } else {
            setContainerView(.NoUpload)
        }
    }

    private func setContainerView(_ uploadState: UploadChoiceState, url: String? = nil) {
        removeCurrentController()
        switch uploadState {
        case .NoCloudName:
            currentController = UIStoryboard(name: "UploadNoCloud", bundle: nil).instantiateViewController(identifier: "UploadNoCloudController")
            (currentController as! UploadNoCloudController).delegate = self
//            currentController.modalPresentationStyle = .fullScreen
            self.present(currentController, animated: true)
            break
        case .NoUpload:
            currentController = UIStoryboard(name: "UploadDoesNotExist", bundle: nil).instantiateViewController(identifier: "UploadDoesNotExistController")
            currentController.view.frame = vwContainer.bounds
            (currentController as! UploadDoesNotExistController).type = type
            (currentController as! UploadDoesNotExistController).delegate = self
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
        case .UploadExist:
            currentController = UIStoryboard(name: "SingleUpload", bundle: nil).instantiateViewController(identifier: "SingleUploadViewController")
            currentController.view.frame = vwContainer.bounds
            (currentController as! SingleUploadViewController).type = type
            (currentController as! SingleUploadViewController).delegate = self
            (currentController as! SingleUploadViewController).url = url
            addChild(currentController)
            vwContainer.addSubview(currentController.view)
            currentController.didMove(toParent: self)
        }
    }

    private func removeCurrentController() {
        currentController?.willMove(toParent: nil)
        currentController?.view.removeFromSuperview()
        currentController?.removeFromParent()
    }
}

extension UploadChoiceController: UploadChoiceControllerDelegate {
    func switchToController(_ uploadState: UploadChoiceState, url: String?) {
        setContainerView(uploadState, url: url)
    }

    func dismissController() {
        self.dismiss(animated: true)
    }
}

enum UploadChoiceState {
    case NoCloudName
    case NoUpload
    case UploadExist
}
