//
//  ViewController.swift
//  Exire
//
//  Created by Ammar Siddiqui on 7/19/16.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    //    var listofImagesKey = [String]()
    //    var listOfImages = [String]()
    var listOfEvents = [Event]()
    var firebaseDatabase = FIRDatabase.database().reference()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        firebaseDatabase.child("events").observeEventType(.ChildAdded, withBlock: { (snapshot) in

            if let event = Event(snapshot: snapshot){
                self.listOfEvents.append(event)
                self.collectionView.reloadData()
            }
        })
        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats:true);
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        let numberOfItems =
        
        return listOfEvents.count == 0 ? 0 : 10000
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as! HomeCollectionViewCell
        
        // clear previous image
        cell.imageView.image = nil
        
        let index = indexPath.row % listOfEvents.count
        let event = listOfEvents[index]
        if let imageURL = event.imageURL, let url = NSURL(string: imageURL){
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? EventListViewController{
            switch segue.identifier! {
                
            case "SportSegue":
                destination.category = "Sports"
            case "MusicSegue" :
                destination.category = "Music"
            case "LearningSegue" :
                destination.category = "Learning"
            case "NightLifeSegue" :
                destination.category = "Night Life"
            case "ExposSegue" :
                destination.category = "Expos"
            case "NetworkingSegue" :
                destination.category = "Networking"
            default:
                break
            }
        }else if let destination = segue.destinationViewController as? DetailViewController{
            
            if let indexPath = collectionView.indexPathsForSelectedItems()?.first{
                let event = listOfEvents[indexPath.row]
                destination.eventUid = event.uid
            
            }
            
            
            
            
            
        }
    }
    
    func scrollToNextCell(){
        
        let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);
        
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset;
        
        //scroll to next cell
        collectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width, contentOffset.y, cellSize.width, cellSize.height), animated: true);
        
        
    }
    
    
}