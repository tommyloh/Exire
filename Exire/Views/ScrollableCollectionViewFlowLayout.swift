//
//  ScrollableCollectionViewFlowLayout.swift
//  Exire
//
//  Created by Tommy Loh on 02/08/2016.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import UIKit

class ScrollableCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override var itemSize: CGSize{
        set{
        
        }
        get{
            return collectionView!.bounds.size
        }
    }
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout(){
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal
    }
}
