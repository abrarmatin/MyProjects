//
//  fbTestView.swift
//  QuickPitch
//
//  Created by Abrar on 8/16/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class fbTestView: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}