//
//  Item.swift
//  QuickPitch
//
//  Created by Abrar on 8/2/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation

class Item: NSObject{
    let companyName: NSString
    let productName: NSString
    let vidPath: NSString
    let cost: NSNumber
    let picture: UIImage
    let productText: NSString
    

    
//    override var description: String {
//        return "Name: \(companyName), \n Image: \(vidPath), \n Age: \(Age) \n NumberOfSharedFriends: \(NumberOfSharedFriends) \n NumberOfSharedInterests: \(NumberOfSharedInterests) \n NumberOfPhotos/: \(NumberOfPhotos)"
//    }
    
    init(cname: NSString?, pname: NSString?, cost: NSNumber?, vidPath: NSString?, picture: UIImage, description: NSString?) {
        self.companyName = cname ?? ""
        self.productName = pname ?? ""
        self.cost = cost!
        self.vidPath = vidPath ?? ""
        self.picture = picture
        self.productText = description ?? ""
        
    }
}