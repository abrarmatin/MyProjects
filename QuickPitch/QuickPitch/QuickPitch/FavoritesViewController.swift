//
//  FavoritesViewController.swift
//  QuickPitch
//
//  Created by Abrar on 7/24/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation
import UIKit
//import FBSDKLoginKit

//var globalLogo = UIImage(named: "QuickPitch-2s.png")

class FavoritesViewController: UICollectionViewController, UITabBarDelegate{
    
    var personController:ChoosePersonViewController!
    var items = FavList.sharedInstance
    var delegate:UITabBarDelegate?
    var itemVC: ItemViewController?
    var logo: UIImage?
    var newItem: Item?
    var currentIndex: NSIndexPath?
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //self.collectionView!.backgroundColor = UIColor .grayColor()
        
        //******TESTING***********
//        let loginButton = FBSDKLoginButton()
//        loginButton.center = view.center
//        view.addSubview(loginButton)
        //***********************
        
        //set logo
        let logo = UIImage(named: "QuickPitch-2s.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.delegate = self
    }
    
    //update the favorites tab
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView!.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.favItems.count
    }
    
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        
        if items.favItems.count > 0
        {
            var view = UIView()
            logo = UIImage(named: items.favItems[indexPath.row].picname as String + ".png")
            let imageView = UIImageView(image:logo)
            view = imageView
            cell.backgroundView = view
            newItem = Item(cname: items.favItems[indexPath.row].companyName, pname: items.favItems[indexPath.row].productName, cost: items.favItems[indexPath.row].cost, vidPath: items.favItems[indexPath.row].vidPath, picture: logo!, description: "test6", link: items.favItems[indexPath.row].link)

            //itemPressed(cell)
            //globalLogo = logo
            
        }
        return cell
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let indexPaths = collectionView!.indexPathsForSelectedItems()!
        if indexPaths.count > 0
        {
            print("made it into if")
            let indexPath = indexPaths[0] as NSIndexPath
            let logo = UIImage(named: items.favItems[indexPath.row].picname as String + ".png")
            itemVC = segue.destinationViewController as? ItemViewController
            itemVC?.currentItem = Item(cname: items.favItems[indexPath.row].companyName, pname: items.favItems[indexPath.row].productName, cost: items.favItems[indexPath.row].cost, vidPath: items.favItems[indexPath.row].vidPath, picture: logo!, description: items.favItems[indexPath.row].productDescription, link: items.favItems[indexPath.row].link)
        }
        
        
        
    }
    
   
    
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //This method will be called when user changes tab.
        print("it changed")
    
    }
    
    //force portrait
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
}
