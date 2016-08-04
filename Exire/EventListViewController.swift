//
//  EventListViewController.swift
//  Exire
//
//  Created by Tommy Loh on 28/07/2016.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import UIKit
import Firebase

class EventListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    var category: String!
    var listOfImages = [String]()
    var firebaseDatabase = FIRDatabase.database().reference()
    var listOfName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category
        
        firebaseDatabase.child(category).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let eventKey = snapshot.key
            self.firebaseDatabase.child("events").child(eventKey).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let eventDetail = snapshot.value as? [String: AnyObject]{
                    if let eventImagePicture = eventDetail["EventPictureURL"] as? String {
                        self.listOfImages.append(eventImagePicture)
                        
                    }
                    if let eventImageName = eventDetail["EventName"] as? String {
                        self.listOfName.append(eventImageName)
                        self.collectionView.reloadData()
                    }
                }
            })
            })
        {
            (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return listOfImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventCell", forIndexPath: indexPath) as! EventListCollectionViewCell
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
        let eventName = listOfName[indexPath.row]
        cell.eventLabel.text = eventName
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? DetailViewController{
            destination.Category = category
            
        }
    }
    @IBAction func onSegmentedControlPressed(sender: UISegmentedControl) {
        
        if segmentController.selectedSegmentIndex == 0{
            
        }
        if segmentController.selectedSegmentIndex == 1{
            
        }
        
        
        
        
        
    }
}