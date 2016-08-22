//
//  ContentDeliveryViewController.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.2
//

import UIKit
import MediaPlayer
import AWSMobileHubHelper

class ContentDeliveryViewController: UITableViewController {
    
    @IBOutlet weak var cacheLimitLabel: UILabel!
    @IBOutlet weak var currentCacheSizeLabel: UILabel!
    @IBOutlet weak var availableCacheSizeLabel: UILabel!
    @IBOutlet weak var pinnedCacheSizeLabel: UILabel!
    @IBOutlet weak var pathLabel: UILabel!
    
    private var prefix: String!
    private var marker: String?
    private var contents: [AWSContent]?
    private var didLoadAllContents: Bool!
    
    private var manager: AWSContentManager!
    private let dateFormatter: NSDateFormatter = NSDateFormatter()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = AWSContentManager.defaultContentManager()
        
        // Sets up the UIs.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "showContentManagerActionOptions:")
        
        // Sets up the date formatter.
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.locale = NSLocale.currentLocale()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        didLoadAllContents = false
        updateUserInterface()
        loadMoreContents()
    }
    
    private func updateUserInterface() {
        cacheLimitLabel.text = manager.maxCacheSize.aws_stringFromByteCount()
        currentCacheSizeLabel.text = manager.cachedUsedSize.aws_stringFromByteCount()
        availableCacheSizeLabel.text = (manager.maxCacheSize - manager.cachedUsedSize).aws_stringFromByteCount()
        pinnedCacheSizeLabel.text = manager.pinnedSize.aws_stringFromByteCount()
        
        if let prefix = self.prefix {
            pathLabel.text = prefix
        } else {
            pathLabel.text = "/"
        }
        tableView.reloadData()
    }
    
    // MARK: - Content Manager user action methods
    
    func showContentManagerActionOptions(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let refreshAction = UIAlertAction(title: "Refresh", style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
            self.refreshContents()
            })
        alertController.addAction(refreshAction)
        let downloadObjectsAction = UIAlertAction(title: "Download Recent", style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
            self.downloadObjectsToFillCache()
            })
        alertController.addAction(downloadObjectsAction)
        let changeLimitAction = UIAlertAction(title: "Set Cache Size", style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
            self.showDiskLimitOptions()
            })
        alertController.addAction(changeLimitAction)
        let removeAllObjectsAction = UIAlertAction(title: "Clear Cache", style: .Destructive, handler: {[unowned self](action: UIAlertAction) -> Void in
            self.manager.clearCache()
            self.updateUserInterface()
            })
        alertController.addAction(removeAllObjectsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func refreshContents() {
        marker = nil
        loadMoreContents()
    }
    
    private func loadMoreContents() {
        manager.listAvailableContentsWithPrefix(prefix, marker: marker, completionHandler: {[weak self](contents: [AWSContent]?, nextMarker: String?, error: NSError?) -> Void in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.showSimpleAlertWithTitle("Error", message: "Failed to load the list of contents.", cancelButtonTitle: "OK")
                print("Failed to load the list of contents. \(error)")
            }
            if let contents = contents where contents.count > 0 {
                strongSelf.contents = contents
                if let nextMarker = nextMarker where !nextMarker.isEmpty{
                    strongSelf.didLoadAllContents = false
                } else {
                    strongSelf.didLoadAllContents = true
                }
                strongSelf.marker = nextMarker
            }
            strongSelf.updateUserInterface()
            })
    }
    
    private func showDiskLimitOptions() {
        let alertController = UIAlertController(title: "Disk Cache Size", message: nil, preferredStyle: .ActionSheet)
        for number: Int in [1, 5, 20, 50, 100] {
            let byteLimitOptionAction = UIAlertAction(title: "\(number) MB", style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
                self.manager.maxCacheSize = UInt(number) * 1024 * 1024
                self.updateUserInterface()
                })
            alertController.addAction(byteLimitOptionAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func downloadObjectsToFillCache() {
        manager.listRecentContentsWithPrefix(prefix, completionHandler: {[weak self](result: AnyObject?, error: NSError?) -> Void in
            guard let strongSelf = self else { return }
            if let downloadResult: [AWSContent] = result as? [AWSContent] {
                for content: AWSContent in downloadResult {
                    if !content.cached && !content.directory {
                        strongSelf.downloadContent(content, pinOnCompletion: false)
                    }
                }
            }
            })
    }
    
    // MARK: - Content user action methods
    
    private func showActionOptionsForContent(rect: CGRect, content: AWSContent) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        if alertController.popoverPresentationController != nil {
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.sourceRect = CGRectMake(rect.midX, rect.midY, 1.0, 1.0)
        }

        if content.cached {
            let openAction = UIAlertAction(title: "Open", style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    self.openContent(content)
                }
                })
            alertController.addAction(openAction)
        }
        
        // Allow opening of remote files natively or in browser based on their type.
        let openRemoteAction = UIAlertAction(title: "Open Remote", style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
            self.openRemoteContent(content)
            })
        alertController.addAction(openRemoteAction)
        
        
        // If the content hasn't been downloaded, and it's larger than the limit of the cache,
        // we don't allow downloading the contentn.
        if content.knownRemoteByteCount + 4 * 1024 < manager.maxCacheSize {
            // 4 KB is for local metadata.
            var title: String = "Download"
            if content.knownRemoteLastModifiedDate.compare(content.downloadedDate) == .OrderedDescending {
                title = "Download Latest Version"
            }
            
            let downloadAction = UIAlertAction(title: title, style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
                self.downloadContent(content, pinOnCompletion: false)
                })
            alertController.addAction(downloadAction)
        }
        
        let downloadAndPinAction = UIAlertAction(title: "Download & Pin", style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
            self.downloadContent(content, pinOnCompletion: true)
            })
        alertController.addAction(downloadAndPinAction)
        
        if content.cached {
            if content.pinned {
                let unpinAction = UIAlertAction(title: "Unpin", style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
                    content.unPin()
                    self.updateUserInterface()
                    })
                alertController.addAction(unpinAction)
            } else {
                let pinAction = UIAlertAction(title: "Pin", style: .Default, handler: {[unowned self](action: UIAlertAction) -> Void in
                    content.pin()
                    self.updateUserInterface()
                    })
                alertController.addAction(pinAction)
            }
            let removeAction = UIAlertAction(title: "Delete Local Copy", style: .Destructive, handler: {[unowned self](action: UIAlertAction) -> Void in
                content.removeLocal()
                self.updateUserInterface()
                })
            alertController.addAction(removeAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func downloadContent(content: AWSContent, pinOnCompletion: Bool) {
        content.downloadWithDownloadType( .IfNewerExists, pinOnCompletion: pinOnCompletion, progressBlock: {[weak self](content: AWSContent?, progress: NSProgress?) -> Void in
            guard let strongSelf = self else { return }
            if strongSelf.contents!.contains( {$0 == content}) {
                let row = strongSelf.contents!.indexOf({$0 == content})!
                let indexPath = NSIndexPath(forRow: row, inSection: 0)
                strongSelf.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
            }, completionHandler: {[weak self](content: AWSContent?, data: NSData?, error: NSError?) -> Void in
                guard let strongSelf = self else { return }
                if let downloadError: NSError = error {
                    print("Failed to download a content from a server.\(downloadError)")
                    strongSelf.showSimpleAlertWithTitle("Error", message: "Failed to download a content from a server.", cancelButtonTitle: "OK")
                }
                strongSelf.updateUserInterface()
            })
    }
    
    private func openContent(content: AWSContent) {
        if content.isAudioVideo() { // Video and sound files
            let directories: [AnyObject] = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
            let cacheDirectoryPath = directories.first as! String
            let movieURL = NSURL(fileURLWithPath: "\(cacheDirectoryPath)/\(content.key.getLastPathComponent())")
            content.cachedData.writeToURL(movieURL, atomically: true)
            let controller: MPMoviePlayerViewController = MPMoviePlayerViewController(contentURL: movieURL)
            controller.moviePlayer.prepareToPlay()
            controller.moviePlayer.play()
            self.presentMoviePlayerViewControllerAnimated(controller)
        } else if content.isImage() {
            // Image files
            let storyboard = UIStoryboard(name: "ContentDelivery", bundle: nil)
            let imageViewController = storyboard.instantiateViewControllerWithIdentifier("ContentDeliveryImageViewController") as! ContentDeliveryImageViewController
            imageViewController.image = UIImage(data: content.cachedData)
            imageViewController.title = content.key
            navigationController?.pushViewController(imageViewController, animated: true)
        } else {
            showSimpleAlertWithTitle("Sorry!", message: "We can only open image, video, and sound files.", cancelButtonTitle: "OK")
        }
    }
    
    private func openRemoteContent(content: AWSContent) {
        content.getRemoteFileURLWithCompletionHandler({ (url: NSURL?, error: NSError?) -> Void in
            guard let url = url else {
                print("Error getting URL for file. \(error)")
                return
            }
            if content.isAudioVideo() { // Open Audio and Video files natively in app.
                let controller = MPMoviePlayerViewController(contentURL: url)
                controller.moviePlayer.prepareToPlay()
                controller.moviePlayer.play()
                self.presentMoviePlayerViewControllerAnimated(controller)
            } else { // Open other file types like PDF in web browser.
                let storyboard = UIStoryboard(name: "ContentDelivery", bundle: nil)
                let webViewController = storyboard.instantiateViewControllerWithIdentifier("ContentDeliveryWebViewController") as! ContentDeliveryWebViewController
                webViewController.url = url
                webViewController.title = content.key
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contents = self.contents {
            return contents.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContentDeliveryCell", forIndexPath: indexPath) as! ContentDeliveryCell
        let content = contents![indexPath.row]
        cell.prefix = prefix
        cell.content = content
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let contents = self.contents {
            if indexPath.row == contents.count - 1 {
                if (!didLoadAllContents) {
                    loadMoreContents()
                }
            }
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let content = self.contents![indexPath.row]
        if content.directory {
            let storyboard = UIStoryboard(name: "ContentDelivery", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("ContentDeliveryViewController") as! ContentDeliveryViewController
            viewController.prefix = content.key
            navigationController!.pushViewController(viewController, animated: true)
        } else {
            let rowRect = tableView.rectForRowAtIndexPath(indexPath)
            showActionOptionsForContent(rowRect, content: content)
        }
    }
}

class ContentDeliveryCell: UITableViewCell {
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var keepImageView: UIImageView!
    @IBOutlet weak var downloadedImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var prefix: String?
    var content: AWSContent! {
        didSet{
            var displayFilename: String = content.key
            if let prefix: String = self.prefix {
                displayFilename = displayFilename.substringFromIndex(prefix.endIndex)
            }
            
            fileNameLabel.text = displayFilename
            downloadedImageView.hidden = !content.cached
            keepImageView.hidden = !content.pinned
            var contentByteCount: UInt = content.fileSize
            if contentByteCount == 0 {
                contentByteCount = content.knownRemoteByteCount
            }
            
            if self.content.directory {
                detailLabel.text = "This is a folder"
                accessoryType = .DisclosureIndicator
            } else {
                detailLabel.text = contentByteCount.aws_stringFromByteCount()
                accessoryType = .None
            }
            
            if content.knownRemoteLastModifiedDate.compare(content.downloadedDate) == .OrderedDescending {
                detailLabel.text = "\(detailLabel.text!) - New Version Available"
                detailLabel.textColor = UIColor.blueColor()
            } else {
                detailLabel.textColor = UIColor.blackColor()
            }
            
            if content.status == .Running {
                progressView.progress = Float(content.progress.fractionCompleted)
                progressView.hidden = false
            } else {
                progressView.hidden = true
            }
        }
    }
}

class ContentDeliveryImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
    }
}

class ContentDeliveryWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var url: NSURL!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.delegate = self
        webView.dataDetectorTypes = .None
        webView.scalesPageToFit = true
        webView.loadRequest(NSURLRequest(URL: url))
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("The URL content failed to load \(error)")
        webView.loadHTMLString("<html><body><h1>Cannot Open the content of the URL.</h1></body></html>", baseURL: nil)
    }
}

// MARK: - Utility

extension ContentDeliveryViewController {
    private func showSimpleAlertWithTitle(title: String, message: String, cancelButtonTitle cancelTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension AWSContent {
    private func isAudioVideo() -> Bool {
        let lowerCaseKey = self.key.lowercaseString
        return lowerCaseKey.hasSuffix(".mov")
            || lowerCaseKey.hasSuffix(".mp4")
            || lowerCaseKey.hasSuffix(".mpv")
            || lowerCaseKey.hasSuffix(".3gp")
            || lowerCaseKey.hasSuffix(".mpeg")
            || lowerCaseKey.hasSuffix(".aac")
            || lowerCaseKey.hasSuffix(".mp3")
    }
    
    private func isImage() -> Bool {
        let lowerCaseKey = self.key.lowercaseString
        return lowerCaseKey.hasSuffix(".jpg")
            || lowerCaseKey.hasSuffix(".png")
            || lowerCaseKey.hasSuffix(".jpeg")
    }
}

extension UInt {
    private func aws_stringFromByteCount() -> String {
        if self < 1024 {
            return "\(self) B"
        }
        if self < 1024 * 1024 {
            return "\(self / 1024) KB"
        }
        if self < 1024 * 1024 * 1024 {
            return "\(self / 1024 / 1024) MB"
        }
        return "\(self / 1024 / 1024 / 1024) GB"
    }
}

extension String {
    private func getLastPathComponent() -> String {
        let nsstringValue: NSString = self
        return nsstringValue.lastPathComponent
    }
}
