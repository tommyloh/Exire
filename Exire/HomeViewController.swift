//
//  ViewController.swift
//  Exire
//
//  Created by Ammar Siddiqui on 7/19/16.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
 //      scrollView.contentSize = self
    }



}

