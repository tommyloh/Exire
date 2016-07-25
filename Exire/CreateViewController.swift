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
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet weak var eventDateTimeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var pickerData: [String] = [String]()
    let picker = UIPickerView()
    let firebaseDatabaseRef = FIRDatabase.database().reference()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        picker.delegate = self
        picker.dataSource = self
        pickerData = ["Music", "Sports", "Night Life", "Learning", "Expos", "Networking"]
        categoryTextField.inputView = picker
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
   
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = pickerData[row]
       
    }
    
    @IBAction func onPostEventPressed(sender: UIButton) {
        
        let randomUID = NSUUID().UUIDString
        let firebaseStorageRef = FIRStorage.storage().reference().child("EventPicture").child("\(randomUID).jpeg")
        let pickerValueText = self.categoryTextField.text
        let eventDateTimeValue = self.eventDateTimeTextField.text
        let eventLocationValue = self.eventLocationTextField.text
        let eventNameValue = self.eventNameTextField.text
        let eventDescription = self.descriptionTextView.text
        
        if let selectedImageData = UIImageJPEGRepresentation(self.imageView.image!, 0.1){
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            firebaseStorageRef.putData(selectedImageData, metadata: metadata, completion: { (metadata, error ) in
                if error != nil{
                    print(error)
                    
                    return
                }else if let eventImageUrl = metadata?.downloadURL()?.absoluteString {
                    let values = ["EventpictureURL" : eventImageUrl]
                    let detailedValues = ["Event Date And Time": eventDateTimeValue, "Event Location": eventLocationValue,"EventPictureURL" : eventImageUrl, "EventName":eventNameValue,"EventDescription":eventDescription]
                    self.firebaseDatabaseRef.child("users").child(User.currentUserUid()!).child("Customer_picture").setValue(values)
                    // create a new event ref
                    let newEventRef = self.firebaseDatabaseRef.child("events").childByAutoId()
                    newEventRef.setValue(detailedValues)
                    
                    
                    self.firebaseDatabaseRef.child(pickerValueText!).child(newEventRef.key).setValue(true)
                }
            })
            
        }
        
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onCancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}
//98758002
