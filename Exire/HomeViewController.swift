//
//  ViewController.swift
//  Exire
//
//  Created by Ammar Siddiqui on 7/19/16.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import UIKit
import Firebase
class HomeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var firebaseDatabase = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? EventListViewController{
            switch segue.identifier! {
            case "SportSegue":
                destination.category = "Sports"
                
                
            case "MusicSegue" :
                destination.category = "Music"
            default:
                break
            }
        }
    }
}