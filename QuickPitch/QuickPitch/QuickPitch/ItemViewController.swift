//
//  ItemViewController.swift
//  QuickPitch
//
//  Created by Abrar on 8/2/16.
//  Copyright © 2016 QuickPitch. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation


class ItemViewController: UIViewController{
    var currentItem: Item?
    var player: AVPlayer?
    var videoURL: NSURL?
    var isPlaying: Bool?
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var imagePic: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productTextView: UITextView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBAction func shareButton(myItem: Item) {
        shareLink((currentItem?.link)!)
    }

    @IBOutlet weak var buyNowButton: UIButton!
    @IBAction func buyNow(sender: AnyObject) {
        UIApplication.sharedApplication().openURL((currentItem?.link)!)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //set logo
        let logo = UIImage(named: "QuickPitch-2s.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        //set scroller
        scroller.contentSize = CGSizeMake(400, 1350)
        scroller.directionalLockEnabled = true
        scroller.showsVerticalScrollIndicator = true
        scroller.flashScrollIndicators()
       
        //create views
        constructImageView()
        companyLabel.text = currentItem?.companyName as! String
        productLabel.text = currentItem?.productName as! String
        productTextView.text = currentItem?.productText as! String
        costLabel.text = "$" + (currentItem?.cost.stringValue)!
        self.videoURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(currentItem?.vidPath as! String, ofType: "mp4")!)
        self.player = AVPlayer(URL: videoURL!)
        constructItemVid()
        isPlaying = false
        
        
        //share button
        
    }
    
   
    func constructImageView() -> Void{
        imagePic.image = currentItem?.picture
        
        imagePic.layer.borderColor = UIColor.blackColor().CGColor
        imagePic.layer.borderWidth = 2.5;
        imagePic.layer.cornerRadius = 5.0;
        buyNowButton.layer.cornerRadius = 5.0;
    }
    
    func constructItemVid() -> Void{
        videoView.layer.borderColor = UIColor.blackColor().CGColor
        videoView.layer.borderWidth = 2.5;
        videoView.layer.cornerRadius = 5.0;
        videoView.backgroundColor = UIColor.blackColor()
        
        //let videoURL = NSURL(string: person.vidPath as String)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerLayer.frame = videoView.bounds
        
        //self.titleLabel.text = "paused"
        videoView.layer.addSublayer(playerLayer)
        //playVid()
        player!.pause()
    }
    
    @IBAction func vidClicked(sender: UIButton) {
        if (isPlaying == true)
        {
            player!.pause()
            isPlaying = false
        }
        else{
            player!.play()
            isPlaying = true
        }
        
    }
    
    func setMyItem(item: Item) -> Void{
        currentItem = item
    }
    
    func shareLink(link: NSURL) {
        let activityViewController = UIActivityViewController(activityItems: [link as NSURL], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    
    static func instantiate() -> ItemViewController
    {
        return UIStoryboard(name: "favorites", bundle: nil).instantiateViewControllerWithIdentifier("ItemViewController") as! ItemViewController
    }
    
   
}