//
//  ItemView.swift
//  QuickPitch
//
//  Created by Abrar on 8/2/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation


class ItemView: UIView{
    //variables
    
    var currentItem: Item?
    
    //init
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    init(frame: CGRect, myItem: Item){
        self.currentItem = myItem
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    
    
}
