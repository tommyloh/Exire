//
//  Event.swift
//  Exire
//
//  Created by Tommy Loh on 03/08/2016.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import Foundation
import FirebaseDatabase
class Event{
    var uid: String
    var imageURL: String?
    init?(snapshot: FIRDataSnapshot){
        self.uid = snapshot.key
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        
        if let eventImageInfo = dict["EventPictureURL"] as? String {
            self.imageURL = eventImageInfo
        }
    }
}