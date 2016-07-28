//
//  SettingsViewController.swift
//  QuickPitch
//
//  Created by Abrar on 7/24/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //set logo
        let logo = UIImage(named: "QuickPitch-2s.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        
    }
    
    
}