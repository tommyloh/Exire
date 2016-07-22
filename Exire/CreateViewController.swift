//
//  CreateViewController.swift
//  Exire
//
//  Created by Tommy Loh on 21/07/2016.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import UIKit
import Firebase


class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate , UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var imageView: UIImageView!
    var pickerData: [String] = [String]()
    let firebaseDatabaseRef = FIRDatabase.database().reference()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        pickerData = ["Music", "Sports", "Night Life", "Learning", "Expos", "Networking"]
    }
    
    @IBAction func onSelectButtonPressed(sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var pickedImage = UIImage?()
        if let EdittedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = EdittedImage
        }else if let OriginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = OriginalImage
        }
            imageView.contentMode = .ScaleToFill
            imageView.image = pickedImage
        dismissViewControllerAnimated(true, completion: nil)
        }
   
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerDidSelect(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        
    }
    
    
    @IBAction func onPostEventPressed(sender: UIButton) {
        
        let randomUID = NSUUID().UUIDString
        let firebaseStorageRef = FIRStorage.storage().reference().child("EventPicture").child("\(randomUID).jpeg")
        
        if let selectedImageData = UIImageJPEGRepresentation(self.imageView.image!, 0.1){
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            firebaseStorageRef.putData(selectedImageData, metadata: metadata, completion: { (metadata, error ) in
                if error != nil{
                    print(error)
                    
                    return
                }else if let eventImageUrl = metadata?.downloadURL()?.absoluteString {
                    let values = ["EventpictureURL" : eventImageUrl]
                    self.firebaseDatabaseRef.child("users").child(User.currentUserUid()!).child("Customer_picture").setValue(values)
                }
            })
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

