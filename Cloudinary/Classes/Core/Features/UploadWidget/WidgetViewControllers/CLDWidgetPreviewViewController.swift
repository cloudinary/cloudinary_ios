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

protocol CLDWidgetPreviewDelegate: class {
    
    func widgetPreviewViewController(_ controller: CLDWidgetPreviewViewController, didFinishEditing images: [CLDWidgetImageContainer])
    func widgetPreviewViewControllerDidCancel(_ controller: CLDWidgetPreviewViewController)
}

class CLDWidgetPreviewViewController: UIViewController {

    private(set)  var collectionView: UICollectionView!
    private(set)  var mainImageView : UIImageView!
    private(set)  var uploadButton  : UIButton!
    private(set)  var images        : [CLDWidgetImageContainer]
    internal weak var delegate      : CLDWidgetPreviewDelegate?
    private(set)  var selectedIndex : Int
    
    // MARK: - init
    init(images: [CLDWidgetImageContainer], delegate: CLDWidgetPreviewDelegate? = nil) {
        
        self.images        = images
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
    
    func selectedImageEdited(newImage: CLDWidgetImageContainer) {
        
        images[selectedIndex] = newImage
        collectionView.reloadItems(at: [IndexPath(row: selectedIndex, section: 0)])
        mainImageView.image = newImage.editedImage
    }
    
    func selectedImage() -> CLDWidgetImageContainer {
        return images[selectedIndex]
    }
    
    // MARK: - action
    @objc private func uploadPressed(sender: UIButton) {
        delegate?.widgetPreviewViewController(self, didFinishEditing: images)
    }
}

// MARK: - UICollectionViewDataSource
extension CLDWidgetPreviewViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CLDWidgetPreviewCollectionCell

        cell.imageView.image = images[indexPath.row].editedImage

        return cell
    } 
}

// MARK: - UICollectionViewDelegate
extension CLDWidgetPreviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        mainImageView.image = images[indexPath.row].editedImage
        selectedIndex       = indexPath.row
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
        mainImageView             = UIImageView(image: images[0].editedImage)
        mainImageView.contentMode = .scaleAspectFit
        
        let image = CLDImageGenerator.generateImage(from: DoneIconInstructions())
        
        // upload button
        uploadButton = UIButton(type: .custom)
        uploadButton.setTitle(String(), for: .normal)
        uploadButton.setImage(image, for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadPressed), for: .touchUpInside)
    }
    
    func addAllSubviews() {
        
        view.addSubview(mainImageView)
        view.addSubview(collectionView)
        view.addSubview(uploadButton)
    }
    
    func addAllConstraints() {
        
        mainImageView .translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        uploadButton  .translatesAutoresizingMaskIntoConstraints = false
        
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
