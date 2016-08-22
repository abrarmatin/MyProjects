////
////  SearchViewController.swift
////  QuickPitch
////
////  Created by Abrar on 7/24/16.
////  Copyright © 2016 QuickPitch. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class SearchViewController: UITableViewController{
//    
//    let searchBarController = UISearchController(searchResultsController: nil)
//    var vidPersonArray = [vidPerson]()
//    var filteredItems = [vidPerson]()
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    
//    }
//    @IBOutlet weak var searchBar: UISearchBar!
//    
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        
//       // searchBar.layer.backgroundColor = UIColor.blackColor().CGColor
//        //set logo
//        let logo = UIImage(named: "QuickPitch-2s.png")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
//        
//        
//        //searchBarController.searchResultsUpdater = self
//        searchBarController.dimsBackgroundDuringPresentation = false
//        searchBarController.definesPresentationContext = true
//        tableView.tableHeaderView = searchBarController.searchBar
//        
//    }
//    
//    func filterSearch(searchWord: String, scope: String = "All")
//    {
//        filteredItems = vidPersonArray.filter{ vidPerson in
//            return vidPerson.productName.containsString(searchWord)
//            
//        }
//        tableView.reloadData()
//    }
//    
//   // func updateSearc
//    
//}