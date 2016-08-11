//
//  FeaturedCollectionViewCell.swift
//  Exire
//
//  Created by Tommy Loh on 10/08/2016.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    var items = ["1", "2", "3", "4", "5"]
    @IBOutlet weak var imageVIew: UIImageView!
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier!, forIndexPath: indexPath) as! FeaturedCollectionViewCell
        
       
        cell.imageVIew.image = UIImage(named: items[indexPath.row])
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//       
//        print("You selected cell #\(indexPath.item)!")
}
