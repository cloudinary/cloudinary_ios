//
//  UploadNoCloudController.swift
//  Cloudinary_Sample_App
//
//  Created by Adi Mizrahi on 04/02/2024.
//

import Foundation
import UIKit

class UploadNoCloudController: UIViewController {

    @IBOutlet weak var tfCloudName: UITextField!
    @IBOutlet weak var vwGetStarted: UIView!
    @IBOutlet weak var vwCantFindCloud: UIView!
    @IBOutlet weak var vwClose: UIView!

    weak var delegate: UploadChoiceControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextField()
        setGetStratedView()
        setCantFindCloudView()
        setCloseView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EventsHandler.shared.logEvent(event: EventObject(name: "Upload No Cloud"))
    }

    private func setTextField() {
        tfCloudName.delegate = self
    }

    private func setGetStratedView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(getStratedTap))

        vwGetStarted.addGestureRecognizer(gesture)
    }

    private func setCloseView() {
        vwClose.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeView))
        vwClose.addGestureRecognizer(tapGesture)
    }

    private func setCantFindCloudView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cantFindCloudClicked))

        vwCantFindCloud.addGestureRecognizer(gesture)
    }

    @objc private func cantFindCloudClicked() {
        if let url = URL(string: "https://cloudinary.com/documentation/how_to_integrate_cloudinary#create_and_explore_your_account") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc private func getStratedTap() {
        CloudinaryHelper.shared.setUploadCloud(tfCloudName.text)
        delegate.switchToController(.NoUpload, url: nil)
        self.dismiss(animated: true)
    }

    @objc private func closeView() {
          self.dismiss(animated: true) {
              self.delegate.dismissController()
          }
      }
}

extension UploadNoCloudController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getStratedTap()
        tfCloudName.resignFirstResponder()
        return false
    }
}
