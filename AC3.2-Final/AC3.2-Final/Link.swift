//
//  Link.swift
//  BareBonesFirebase
//
//  Created by Miti Shah on 2/13/17.
//  Copyright © 2017 Miti Shah. All rights reserved.
//

import Foundation

class Link {
    let key: String
    let userID: String?
    let comment: String?
    
    init( key: String, userID: String, comment: String) {
        self.key = key
        self.userID = userID
        self.comment = comment
        
    }
    
    var asDictionary: [String: String] {
        return [ "key": key, "userID": userID!, "comment": comment!]
    }
}
