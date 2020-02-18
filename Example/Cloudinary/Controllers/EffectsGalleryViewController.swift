//
//  EffectsGalleryViewController.swift
//  SampleApp
//
//  Created by Nitzan Jaitman on 31/08/2017.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary
import AVKit

class EffectsGalleryViewController: UIViewController, UploadedResourceDetails {
    // MARK: Properties
    @IBOutlet weak var imageView: CLDUIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var currEffectContainer: UIView!

    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    let reuseIdentifier = "EffectCell"
    var currEffect: EffectMetadata?
    var effects = [EffectMetadata]()
    var currUrl: String?
    var resource: CLDResource!
    var cloudinary: CLDCloudinary!
    var observation: NSKeyValueObservation?
    var isVideo: Bool!
    var resourceType: CLDUrlResourceType!

    // video player:
    var player: AVPlayer!
    var avpController = AVPlayerViewController()

    override open func viewDidAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        cloudinary = appDelegate.cloudinary

        self.player = AVPlayer()
        self.avpController = AVPlayerViewController()
        self.avpController.player = self.player
        avpController.view.frame = videoView.frame
        self.addChild(avpController)
        self.currEffectContainer.addSubview(avpController.view)

        self.isVideo = resource.resourceType == "video"
        self.resourceType = isVideo ? CLDUrlResourceType.video : CLDUrlResourceType.image

        DispatchQueue.global().async {
            if (self.isVideo) {
                self.effects = CloudinaryHelper.generateVideoEffectList(cloudinary: self.cloudinary, resource: self.resource)
            } else {
                self.effects = CloudinaryHelper.generateEffectList(cloudinary: self.cloudinary, resource: self.resource)
            }

            DispatchQueue.main.async {
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                self.updateCurrEffect((self.effects.first)!)
            }
        }
    }

    @IBAction func codeButtonClicked(_ sender: Any) {
        if let currUrl = currUrl {
            openStringUrl(currUrl)
        }
    }

    fileprivate func openStringUrl(_ url: String) {
        let url = URL(string: url)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    fileprivate func updateCurrEffect(_ effect: EffectMetadata) {
        currEffect = effect
        descriptionLabel.text = effect.description
        self.imageView.image = nil
        self.player.replaceCurrentItem(with: nil)

        // Apply scaling/responsive params to a copy of the transformation:
        let transformation = effect.transformation.copy() as! CLDTransformation

        if (isVideo) {
            // manually set size (for images goth are automatic, see the else clause below). Note that DPR
            // is not supported for videos so we fetch with pixel size:
            transformation.chain().setWidth(Int(round(UIScreen.main.bounds.width * UIScreen.main.scale)))
            self.currUrl = cloudinary.createUrl()
                    .setResourceType(self.resourceType)
                    .setTransformation(transformation)
                    .setFormat("mp4")
                    .generate(resource.publicId!)

            self.videoView.isHidden = false
            self.avpController.view.isHidden = false
            self.imageView.isHidden = true
            activityIndicator.isHidden = true
            let url = URL(string: self.currUrl!)!
            self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        } else {
            transformation.setFetchFormat("png")
            // note: This url will be used when openning the browser, this is NOT identical to the one shown
            // inside the app - In the app the size is determined automatically. In the url for browser, the size
            // will be screen width for full-screen view.
            self.currUrl = updateCurrUrlForBrowser(cloudinary, transformation)
            self.videoView.isHidden = true
            self.avpController.view.isHidden = true
            self.imageView.isHidden = false

            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

            // use CLDUIImageView with CLDResponsiveParams to automatically handle fetch dimensions and dpr:
            let params = CLDResponsiveParams.fit().setReloadOnSizeChange(true)
            self.imageView.cldSetImage(publicId: resource.publicId!, cloudinary: getAppDelegate()!.cloudinary, resourceType: self.resourceType, responsiveParams: params, transformation: transformation)
        }
    }

    fileprivate func updateCurrUrlForBrowser(_ cloudinary: CLDCloudinary, _ transformation: CLDTransformation) -> String {
        let copy = transformation.copy() as! CLDTransformation
        copy.chain().setDpr(Float(UIScreen.main.scale)).setWidth(Int(round(UIScreen.main.bounds.width)))
        return cloudinary.createUrl().setTransformation(copy).setResourceType(self.resourceType).generate(resource.publicId!)!
    }

    func setResource(resource: CLDResource) {
        self.resource = resource;
    }

    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateCurrEffect(effects[indexPath.item])
    }
}

extension EffectsGalleryViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return effects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EffectCell
        let effect = effects[indexPath.row]
        let params = CLDResponsiveParams.autoFill()
        let transformation = effect.transformation.copy() as! CLDTransformation

        cell.imageView.cldSetImage(publicId: resource.publicId!, cloudinary: getAppDelegate()!.cloudinary,
                resourceType: self.resourceType, responsiveParams: params,
                transformation: transformation.setFetchFormat("png"))

        cell.indicator.startAnimating()

        return cell
    }
}

extension EffectsGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
