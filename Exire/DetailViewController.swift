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
    @IBOutlet weak var goersLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    var eventUid: String!
    var Category: String!
    var ImageUrl: String!
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
                    }
                    if let eventLocationInfo = eventDetail["Event Location"] as? String{
                        self.locationLabel.text = eventLocationInfo
                    }
                    if let eventDateTimeInfo = eventDetail["Event Date And Time"] as? String{
                        self.dateTimeLabel.text = eventDateTimeInfo
                    }
                    if let eventDescriptionInfo = eventDetail["EventDescription"] as? String{
                        self.descriptionTextView.text = eventDescriptionInfo
                        self.collectionView.reloadData()
                        
                    }
                    
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
        })
        self.firebaseDatabase.child("eventParticipants").observeSingleEventOfType(.ChildAdded, withBlock: {(snapshot) in
            if let goersCount = snapshot.value as? [String:AnyObject]{
                if let goers = goersCount["goersCount"] as? Int{
                    self.goersLabel.text = "Goers: \(goers)"
                    self.collectionView.reloadData()
                }
            }
            
            })
        { (error) in
            print(error.localizedDescription)
        }
        
        
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
        firebaseDatabase.child(Category).observeSingleEventOfType(.ChildAdded, withBlock: {(snapshot) in
            let eventKey = snapshot.key
            let firebaseRef = FIRDatabase.database().reference().child("eventParticipants").child(eventKey)
            firebaseRef.runTransactionBlock({ (snapshot: FIRMutableData) -> FIRTransactionResult in
                if let uid = FIRAuth.auth()?.currentUser?.uid {
                    var goers = snapshot.value as? [String: AnyObject] ?? [:]
                    var Goers : Dictionary<String, Bool>
                    Goers = goers["goers"] as? [String : Bool] ?? [:]
                    var goersCount = goers["goersCount"] as? Int ?? 0
                    if let _ = Goers[uid]{
                        goersCount -= 1
                        Goers.removeValueForKey(uid)
                    } else {
                        goersCount += 1
                        Goers[uid] = true
                    }
                    
                    goers["goersCount"] = goersCount
                    goers["goers"] = Goers
                    snapshot.value = goers
                    
                    return FIRTransactionResult.successWithValue(snapshot)
                    
                }
                return FIRTransactionResult.successWithValue(snapshot)
                
                
            }) { (error, committed, snapshot) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            
        })
        
    }
    
}
