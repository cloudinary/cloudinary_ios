//
//  PhotoTableViewController.swift
//  PhotoAlbum
//

import UIKit
import os.log
import Cloudinary

class PhotoTableViewController: UITableViewController {

    //MARK: Properties
    @IBOutlet weak var message: UILabel!

    var photos = [Photo]()

    var cld = CLDCloudinary(configuration: CLDConfiguration(cloudName: AppDelegate.cloudName, secure: true))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        // Load any saved photos, otherwise load sample data.
        if let savedPhotos = loadPhotos() {
            photos += savedPhotos
        } else {
            // Load the sample data.
            loadSamplePhotos()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PhotoTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PhotoTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PhotoTableViewCell.")
        }

        // Fetches the appropriate image for the data source layout.
        let row = indexPath.row
        let photo = photos[row]

        cell.nameLabel.text = photo.name
        let size: CGSize = cell.photoImageView.frame.size
        let transformation = CLDTransformation().setWidth(Int(size.width)).setHeight(Int(size.height)).setCrop(.fit)
        // Get the image from cache or download it
        if let publicId = photo.publicId {
            cell.photoImageView.cldSetImage(publicId: publicId, cloudinary: cld, transformation: transformation)
        } else {
            // Image was not uploaded to Cloudinary yet.
            if let image = photo.image, let data = UIImageJPEGRepresentation(image, 1.0) {
                cell.photoImageView.image = image
                showMessage("Uploading to Cloudinary")
                let progressHandler = { (progress: Progress) in
                    self.showMessage(String("Uploading to Cloudinary: \(Int(progress.fractionCompleted * 100))%"))
                }
                cld.createUploader().upload(data: data, uploadPreset: AppDelegate.uploadPreset, progress: progressHandler) { (result, error) in
                            if let error = error {
                                os_log("Error uploading image %@", error)
                            } else {
                                if let result = result, let publicId = result.publicId {
                                    self.showMessage("Image uploaded to Cloudinary successfully")
                                    self.hideMessage()
                                    self.photos[row].publicId = publicId
                                    self.photos[row].image = nil // remove the reference to the original image
                                    cell.photoImageView.cldSetImage(publicId: publicId, cloudinary: self.cld, transformation: transformation, placeholder: image)
                                    self.savePhotos()
                                }
                            }
                        }
            }
        }
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            photos.remove(at: indexPath.row)
            savePhotos()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)

        switch (segue.identifier ?? "") {

        case "AddItem":
            os_log("Adding a new photo.", log: OSLog.default, type: .debug)

        case "ShowDetail":
            guard let photoDetailViewController = segue.destination as? PhotoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            guard let selectedPhotoCell = sender as? PhotoTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }

            guard let indexPath = tableView.indexPath(for: selectedPhotoCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedPhoto = photos[indexPath.row]
            photoDetailViewController.photo = selectedPhoto
            photoDetailViewController.placeholder = selectedPhotoCell.photoImageView.image

        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }


    //MARK: Actions

    @IBAction func unwindToPhotoList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PhotoViewController, let photo = sourceViewController.photo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing image.
                photos[selectedIndexPath.row] = photo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new image.
                let newIndexPath = IndexPath(row: photos.count, section: 0)
                photos.append(photo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

            // Save the photos.
            savePhotos()
        }
    }

    //MARK: Private Methods

    fileprivate func loadSamplePhotos() {

        let image1 = UIImage(named: "photo1")
        let image2 = UIImage(named: "photo2")
        let image3 = UIImage(named: "photo3")

        guard let photo1 = Photo(name: "Caprese Salad", image: image1) else {
            fatalError("Unable to instantiate photo1")
        }

        guard let photo2 = Photo(name: "Chicken and Potatoes", image: image2) else {
            fatalError("Unable to instantiate photo2")
        }

        guard let photo3 = Photo(name: "Pasta with Meatballs", image: image3) else {
            fatalError("Unable to instantiate photo2")
        }

        photos += [photo1, photo2, photo3]

    }

    fileprivate func savePhotos() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(photos, toFile: Photo.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Photos successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }

    fileprivate func loadPhotos() -> [Photo]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Photo.ArchiveURL.path) as? [Photo]
    }

}
