//
//  DetailViewController.swift
//  Exire
//
//  Created by Tommy Loh on 21/07/2016.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    var Category: String!
    var listOfImages = [String]()
    var firebaseDatabase = FIRDatabase.database().reference()
    var eventLocation = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        firebaseDatabase.child(Category).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let eventKey = snapshot.key
            self.firebaseDatabase.child("events").child(eventKey).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let eventDetail = snapshot.value as? [String: AnyObject]{
                if let eventImageInfo = eventDetail["EventPictureURL"] as? String {
                    self.listOfImages.append(eventImageInfo)
                    self.collectionView.reloadData()
                }
                if let eventLocationInfo = eventDetail["Event Location"] as? String{
                    self.locationLabel.text = eventLocationInfo
                }
                if let eventDateTimeInfo = eventDetail["Event Date And Time"] as? String{
                    self.dateTimeLabel.text = eventDateTimeInfo
                }
                if let eventDescriptionInfo = eventDetail["EventDescription"] as? String{
                    self.descriptionTextView.text = eventDescriptionInfo
                }
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    })
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! DetailEventCollectionViewCell
        
        if let url = NSURL(string: listOfImages[indexPath.row]){
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                if error != nil{
                    print(error)
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageView.image = UIImage(data: data!)
                })
            }
            task.resume()
        }
        return cell
    }

    @IBAction func onJoinButtonPressed(sender: UIButton) {
        
        
    }


}
