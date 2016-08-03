//
//  ItemViewController.swift
//  QuickPitch
//
//  Created by Abrar on 8/2/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation


class ItemViewController: UIViewController{
    var currentItem: Item?
    @IBOutlet weak var imagePic: UIImageView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //newItemView = ItemView(frame: <#T##CGRect#>, image: <#T##UIImage#>, text: <#T##NSString#>, vidPath: <#T##NSString#>, link: <#T##NSString#>)
        imagePic.image = currentItem?.picture
        
    }
    
    func setMyItem(item: Item) -> Void{
        currentItem = item
    }
    
    
    static func instantiate() -> ItemViewController
    {
        return UIStoryboard(name: "favorites", bundle: nil).instantiateViewControllerWithIdentifier("ItemViewController") as! ItemViewController
    }
    
   
}