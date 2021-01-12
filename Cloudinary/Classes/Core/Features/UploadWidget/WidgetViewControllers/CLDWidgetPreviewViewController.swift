//
//  CLDWidgetPreviewViewController.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import AVKit

protocol CLDWidgetPreviewDelegate: class {
    
    func widgetPreviewViewController(_ controller: CLDWidgetPreviewViewController, didFinishEditing assets: [CLDWidgetAssetContainer])
    func widgetPreviewViewController(_ controller: CLDWidgetPreviewViewController, didSelect asset: CLDWidgetAssetContainer)
    func widgetPreviewViewControllerDidCancel(_ controller: CLDWidgetPreviewViewController)
}

class CLDWidgetPreviewViewController: UIViewController {

    private(set)  var collectionView: UICollectionView!
    private(set)  var mainImageView : UIImageView!
    private(set)  var uploadButton  : UIButton!
    
    private(set)  var videoView     : CLDVideoView!
    
    private(set)  var assets        : [CLDWidgetAssetContainer]
    internal weak var delegate      : CLDWidgetPreviewDelegate?
    private(set)  var selectedIndex : Int
        
    // MARK: - init
    init(assets: [CLDWidgetAssetContainer], delegate: CLDWidgetPreviewDelegate? = nil) {
        
        self.assets        = assets
        self.delegate      = delegate
        self.selectedIndex = 0
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        super.loadView()
        createUI()
    }
    
    func selectedImageEdited(newImage: CLDWidgetAssetContainer) {
        
        assets[selectedIndex] = newImage
        collectionView.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
        mainImageView.image = newImage.editedImage
    }
    
    func selectedImage() -> CLDWidgetAssetContainer {
        return assets[selectedIndex]
    }
    
    // MARK: - action
    @objc private func uploadPressed(sender: UIButton) {
        delegate?.widgetPreviewViewController(self, didFinishEditing: assets)
    }
}

// MARK: - UICollectionViewDataSource
extension CLDWidgetPreviewViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CLDWidgetPreviewCollectionCell

        cell.imageView.image = assets[indexPath.row].presentationImage

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CLDWidgetPreviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard selectedIndex != indexPath.row else { return }
         
        selectedIndex = indexPath.row
        let selectedAsset = assets[selectedIndex]
        
        switch selectedAsset.assetType {
        case .video: videoSelected(video: selectedAsset.originalVideo!)
        case .image: imageSelected(image: selectedAsset.editedImage!)
        }
        
        delegate?.widgetPreviewViewController(self, didSelect: selectedAsset)
    }
}

// MARK: - present asset
extension CLDWidgetPreviewViewController {
    
    var videoTransitionDelay   : TimeInterval { 0.1 }
    var videoTransitionDuration: TimeInterval { 0.2 }
    
    func videoSelected(video: AVPlayerItem) {
        
        UIView.animate(withDuration: videoTransitionDuration, animations: {
            
            self.videoView.alpha     = 0.0
            self.mainImageView.alpha = 0.0
            
        }) { (complete) in
                
            self.videoView.replaceCurrentItem(with: video)
            
            UIView.animate(withDuration: self.videoTransitionDuration, delay: self.videoTransitionDelay, options: .curveEaseInOut, animations: {
                self.videoView.alpha = 1
                
            }, completion: nil)
        }
    }
    
    func imageSelected(image: UIImage) {
        
        videoView.pauseVideo()
        
        mainImageView.image = image
        
        showImageView()
    }
    
    func showVideoView() {
        
        UIView.animate(withDuration: 0.4) {
            self.videoView.alpha = 1.0
            self.mainImageView.alpha = 0.0
        }
    }
    
    func showImageView() {
        
        UIView.animate(withDuration: 0.4) {
            self.videoView.alpha = 0.0
            self.mainImageView.alpha = 1.0
        }
    }
}

// MARK: - create UI
private extension CLDWidgetPreviewViewController {
    
    var cellId               : String       { return "CLDWidgetPreviewCollectionCell" }
    
    var collectionCellSpacing: CGFloat      { return 2 }
    var collectionHeight     : CGFloat      { return 70 }
    var buttonSize           : CGSize       { return CGSize(width: 80, height: 80) }
    var sectionInsets        : UIEdgeInsets { return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0) }
    var collectionCellSize   : CGSize       { return CGSize(width: collectionHeight * 0.9, height: collectionHeight) }
    
    // MARK: - private methods
    func createUI() {
        
        view.backgroundColor = .black
        
        createAllSubviews()
        addAllSubviews()
        addAllConstraints()
        
        // initial asset presentation state
        switch assets[0].assetType {
        case .video: mainImageView.alpha = 0
        case .image: videoView.alpha     = 0
        }
    }

    func createAllSubviews() {
        
        // collectionView
        let layout                     = UICollectionViewFlowLayout()
        layout.sectionInset            = sectionInsets
        layout.minimumLineSpacing      = collectionCellSpacing
        layout.minimumInteritemSpacing = collectionCellSpacing
        
        layout.itemSize                = collectionCellSize
        layout.scrollDirection         = .horizontal
        
        collectionView                         = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.allowsSelection         = true
        collectionView.allowsMultipleSelection = false
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        collectionView.register(CLDWidgetPreviewCollectionCell.self, forCellWithReuseIdentifier: cellId)
        
        // imageView
        mainImageView             = UIImageView(image: assets[0].editedImage)
        mainImageView.contentMode = .scaleAspectFit
        
        // videoView
        let playerItem                    = assets[0].originalVideo
        videoView                         = CLDVideoView(frame: CGRect.zero, playerItem: playerItem, isMuted: true)
        videoView.accessibilityIdentifier = "previewViewControllerVideoView"
        
        // upload button
        let buttonImage = CLDImageGenerator.generateImage(from: DoneIconInstructions())
        uploadButton = UIButton(type: .custom)
        uploadButton.setTitle(String(), for: .normal)
        uploadButton.setImage(buttonImage, for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadPressed), for: .touchUpInside)
    }
    
    func addAllSubviews() {
        
        view.addSubview(mainImageView)
        view.addSubview(collectionView)
        view.addSubview(videoView)
        view.addSubview(uploadButton)
    }
    
    func addAllConstraints() {
        
        mainImageView .translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        uploadButton  .translatesAutoresizingMaskIntoConstraints = false
        videoView     .translatesAutoresizingMaskIntoConstraints = false
        
        // collectionView
        let collectionConstraints = [
            NSLayoutConstraint(item: collectionView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView!, attribute: .top, relatedBy: .equal, toItem: mainImageView, attribute: .bottom, multiplier: 1, constant: 5),
            NSLayoutConstraint(item: collectionView!, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: collectionView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: collectionHeight)
        ]
        NSLayoutConstraint.activate(collectionConstraints)
        
        // imageView
        let imageViewConstraints = [
            NSLayoutConstraint(item: mainImageView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mainImageView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: mainImageView!, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
        
        // videoView
        let videoViewConstraints = [
            NSLayoutConstraint(item: videoView!, attribute: .leading, relatedBy: .equal, toItem: mainImageView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: videoView!, attribute: .trailing, relatedBy: .equal, toItem: mainImageView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: videoView!, attribute: .top, relatedBy: .equal, toItem: mainImageView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: videoView!, attribute: .bottom, relatedBy: .equal, toItem: mainImageView, attribute: .bottom, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(videoViewConstraints)
        
        // uploadButton
        let uploadButtonConstraints = [
            NSLayoutConstraint(item: uploadButton!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: uploadButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: buttonSize.width),
            NSLayoutConstraint(item: uploadButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: buttonSize.height),
            NSLayoutConstraint(item: uploadButton!, attribute: .bottom, relatedBy: .equal, toItem: mainImageView, attribute: .bottom, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(uploadButtonConstraints)
    }
}
