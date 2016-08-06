//
//  FavList.swift
//  QuickPitch
//
//  Created by Abrar on 7/28/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation

class FavList {
    class var sharedInstance: FavList {
        struct Static {
            static var instance: FavList?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = FavList()
        }
        
        return Static.instance!
    }
    
    var favItems: [vidPerson] = []
}