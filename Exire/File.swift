//
//  File.swift
//  Exire
//
//  Created by Tommy Loh on 21/07/2016.
//  Copyright © 2016 GATCorp. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    
    var ProfileImageUrl : String?
    // key = snapshot.key
//    
//    if let ProfileImageUrl = dict["profileImageUrl"] as? String{
//        profileImageUrl = ProfileImageUrl
//    }
//    
    class func signIn(uid: String){
        NSUserDefaults.standardUserDefaults().setValue(uid, forKeyPath: "uid")
    }
    
    class func isSignedIn() -> Bool {
        if let _ = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
            return true
        }else{
            return false
        }
    }
    
    class func currentUserUid() -> String?{
        return NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
    }
    
}
