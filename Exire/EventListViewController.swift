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
    var event : detailEvent?
    var category: String!
    var listOfImages = [String]()
    var firebaseDatabase = FIRDatabase.database().reference()
    var listOfName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseDatabase.child(category).observeEventType(.ChildAdded, withBlock: {(snapshot) in
            let eventkey = snapshot.key
            self.firebaseDatabase.child("events").child(eventkey).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let event = detailEvent(snapshot: snapshot){
                    self.event = event
                    self.listOfImages.append(event.imageUrl!)
                    self.listOfName.append(event.imageName!)
                    
                    self.collectionView.reloadData()
                }
            })
        })
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
            
           destination.eventUID = event?.uid
        }
    }
    @IBAction func onSegmentedControlPressed(sender: UISegmentedControl) {
        
        if segmentController.selectedSegmentIndex == 0{
            
        }
        if segmentController.selectedSegmentIndex == 1{
            
        }
        
        
        
        
        
    }
}