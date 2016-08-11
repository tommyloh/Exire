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
    var locationInfo: String?
    var dateTimeInfo: String?
    var descriptionInfo: String?
    var eventNameInfo :String?
    init?(snapshot: FIRDataSnapshot){
        self.uid = snapshot.key
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        
        if let eventImageInfo = dict["EventPictureURL"] as? String {
            self.imageURL = eventImageInfo
        }
        
        if let eventLocationInfo = dict["Event Location"] as? String{
            self.locationInfo = eventLocationInfo
        }
        if let eventDateTimeInfo = dict["Event Date And Time"] as? String{
            self.dateTimeInfo = eventDateTimeInfo
        }
        if let eventDescriptionInfo = dict["EventDescription"] as? String{
            self.descriptionInfo = eventDescriptionInfo
        }
        if let eventNameInfo = dict["EventName"] as? String{
            self.eventNameInfo = eventNameInfo
        }

    }

    
}
class detailEvent{
    var uid: String?
    var imageUrl:String?
    var imageName: String?
    var eventLocation: String?
    var eventDate: String?
    var eventDescription:String?
    
    init?(snapshot :FIRDataSnapshot){
        self.uid = snapshot.key
        guard let dict = snapshot.value as? [String:AnyObject] else{
            return nil
        }
        if let eventImagePicture = dict["EventPictureURL"] as? String{
            self.imageUrl = eventImagePicture
        }
        if let eventName = dict["EventName"] as? String{
            self.imageName = eventName
        }
//        if let eventLocation = dict["Event Location"] as? String{
//            self.locationInfo = eventLocation
//        }
//        if let eventDate = dict["Event Date And Time"] as? String{
//            self.dateTimeInfo = eventDate
//        }
//        if let eventDescription = dict["EventDescription"] as? String{
//            self.descriptionInfo = eventDescription
        
    
        
    }
    
}
