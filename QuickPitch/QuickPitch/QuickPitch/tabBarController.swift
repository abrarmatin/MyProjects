//
//  tabBarController.swift
//  QuickPitch
//
//  Created by Abrar on 8/14/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation

var tabChanged: Bool = true
class tabBarController: UITabBarController{
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print("tab changed")
        print("changed to true")
        tabChanged = true
        
        if item != "Explore"
        {
            "changed to true"
            tabChanged = true
        }
        //pause video
        
    }
    
}