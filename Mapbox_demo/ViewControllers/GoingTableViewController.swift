//
//  InvitationTableViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 8/5/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit

class GoingTableViewController: UITableViewController {
    
    // Variables
    
    var placeID: String = ""
    var getDataService = GetDataService()
    var response = "Pending"
    var placeInvitation = Place()
    var friendsArray = [FriendsNameFacebookID]()
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        
        self.getDataService.getPlaceInfo(self.placeID) { (place) in
            
            //self.placeInvitation = place
            self.placeInvitation.image = place.image
            self.placeInvitation.price = place.price
            self.placeInvitation.rating = place.rating
            self.placeInvitation.restaurantName = place.restaurantName
            self.placeInvitation.address = place.address
            self.placeInvitation.suggestions = place.suggestions
            
            self.getDataService.getFriendsAnswes(self.placeID, complete: { (friendsInfo) in
                self.friendsArray = friendsInfo
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                
            })
            
        }
        
        
    }
    
    @IBAction func backButtonAction(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
        vc.selectedIndex = 1
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    func loadUIView() {
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        self.indicator.center = self.tableView.center
        self.tableView.addSubview(self.indicator)
        self.indicator.bringSubviewToFront(self.tableView)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.indicator.startAnimating()
        
        
        self.getDataService.getPlaceInfo(self.placeID) { (place) in
            
            //self.placeInvitation = place
            self.placeInvitation.image = place.image
            self.placeInvitation.price = place.price
            self.placeInvitation.rating = place.rating
            self.placeInvitation.restaurantName = place.restaurantName
            self.placeInvitation.address = place.address
            
            self.indicator.stopAnimating()
        }
    }
    
    
    func respondAction(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            response = "Pending"
        case 1:
            response = "Yes"
        case 2:
            response = "No"
        default:
            break
        }
        updateToDatabase()
    }
    
    func updateToDatabase() {
        self.getDataService.getFacebookID { (facebookID) in
            DataService.dataService.setAnswer(self.placeID, facebookID: facebookID, response: self.response)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 6 {
            return 150
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell0", forIndexPath: indexPath) as! GoingTableViewCell
            
            cell.placeImage.af_setImageWithURL(NSURL(string: placeInvitation.image)!)
            
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! GoingTableViewCell
            
            cell.placeNameLabel?.text = placeInvitation.restaurantName
            
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! GoingTableViewCell
            
            cell.addressLabel?.text = placeInvitation.address
            
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath) as! GoingTableViewCell
            
            if placeInvitation.price.characters.count == 0 {
                cell.priceLabel?.text = "No Pricing"
            }
            else {
                cell.priceLabel?.text = "Tier: \(placeInvitation.price)"
            }
            
            
            
            return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! GoingTableViewCell
            
            cell.ratingLabel?.text = placeInvitation.rating
            
            return cell
        }
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell5", forIndexPath: indexPath) as! GoingTableViewCell
            if placeInvitation.suggestions.characters.count == 0 {
                cell.reviewsLabel?.text = "No Review"
                
            }
            else {
                cell.reviewsLabel?.text = placeInvitation.suggestions
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell6", forIndexPath: indexPath) as! GoingTableViewCell
            
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            return cell
        }
    }
}

extension GoingTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return self.friendsArray.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
                                                                         forIndexPath: indexPath) as! InvitationCollectionViewCell
        
        cell.friendsNameLabel?.text = self.friendsArray[indexPath.row].name
        cell.answerLabel?.text = self.friendsArray[indexPath.row].answer
        
        return cell
    }
}
