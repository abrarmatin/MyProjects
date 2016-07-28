//
//  FavoritesViewController.swift
//  QuickPitch
//
//  Created by Abrar on 7/24/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UICollectionViewController{
    
    var personController:ChoosePersonViewController!
    //var likedNames:[NSString] = personController.likedPeople
    var likedNames: [NSString] = []
    
    
    
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

    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedNames.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
       
        let Label = cell.viewWithTag(1) as! UILabel
        Label.text = likedNames[indexPath.row] as String
        
        
        var view = UIView()
        let logo = UIImage(named: likedNames[indexPath.row] as String + ".png")
        let imageView = UIImageView(image:logo)
        view = imageView
        cell.backgroundView = view
        return cell
        
    
    }
    
    func setFavorites(newItem: NSString) ->Void
    {
        self.likedNames.insert(newItem, atIndex: likedNames.endIndex)
    }
    
}
