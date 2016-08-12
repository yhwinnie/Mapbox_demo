//
//  InvitationTableViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 8/5/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit

class InvitationTableViewController: UITableViewController {
    
    // Variables
    var placeID: String = ""
    var getDataService = GetDataService()
    var response: String = "Pending"
    var placeInvitation = Place()
    var friendsArray = [FriendsNameFacebookID]()
    var buttonState: Bool = false
    var id: String = ""
    
    var indicator: UIActivityIndicatorView!
    
    // Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        self.indicator.center = self.tableView.center
        self.tableView.addSubview(self.indicator)
        self.indicator.bringSubviewToFront(self.tableView)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.indicator.startAnimating()
        
        
        self.getDataService.getPlaceInfo(self.placeID) { (place) in
            
            self.placeInvitation.image = place.image
            self.placeInvitation.price = place.price
            self.placeInvitation.rating = place.rating
            self.placeInvitation.restaurantName = place.restaurantName
            self.placeInvitation.address = place.address
            self.placeInvitation.suggestions = place.suggestions
            
            self.getDataService.getFriendsAnswes(self.placeID, complete: { (friendsInfo) in
                self.friendsArray = friendsInfo
                
                self.getDataService.getFacebookID({ (facebookID) in
                    self.id = facebookID
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                        
                    }
                })
            })
        }
    }
    
    @IBAction func interestedAction(sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "Are you going?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let goingAction = UIAlertAction(title: "Going", style: .Default) { (action) in
            //self.response = "Going"
            if let image = UIImage(named:"going-1.png") {
                sender.setImage(image, forState: .Normal)
                self.response = "Going"
            }
            
        }
        alertController.addAction(goingAction)
        
        let notGoingAction = UIAlertAction(title: "Not Going", style: .Default) { (action) in
            self.response = "Not going"
            if let image = UIImage(named:"not_going-1.png") {
                sender.setImage(image, forState: .Normal)
            }
        }
        alertController.addAction(notGoingAction)
        
        let interestedAction = UIAlertAction(title: "Interested", style: .Default) { (action) in
            self.response = "Interested"
            if let image = UIImage(named:"interested-1.png") {
                sender.setImage(image, forState: .Normal)
            }
            
        }
        alertController.addAction(interestedAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func notGoingAction(sender: UIButton) {
        
        if !buttonState {
            if let image = UIImage(named:"not_going-1.png") {
                sender.setImage(image, forState: .Normal)
                self.response = "Not Going"
                buttonState = true
            }
        }
        else {
            if let image = UIImage(named:"not_going.png") {
                sender.setImage(image, forState: .Normal)
                buttonState = false
                
            }
        }
        
    }
    
    @IBAction func goingAction(sender: UIButton) {
        
        if !buttonState {
            if let image = UIImage(named:"going-1.png") {
                sender.setImage(image, forState: .Normal)
                self.response = "Going"
                buttonState = true
            }
        }
        else {
            if let image = UIImage(named:"going.png") {
                sender.setImage(image, forState: .Normal)
                buttonState = false
                
            }
        }
    }
    override func viewDidDisappear(animated: Bool) {
        updateToDatabase()
        
    }
    
    @IBAction func backButtonAction(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
        vc.selectedIndex = 1
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    func loadUIView() {
        self.getDataService.getPlaceInfo(self.placeID) { (place) in
            
            //self.placeInvitation = place
            self.placeInvitation.image = place.image
            self.placeInvitation.price = place.price
            self.placeInvitation.rating = place.rating
            self.placeInvitation.restaurantName = place.restaurantName
            self.placeInvitation.address = place.address
            
        }
    }
    
    
    
    func updateToDatabase() {
        self.getDataService.getFacebookID { (facebookID) in
            DataService.dataService.setAnswer(self.placeID, facebookID: facebookID, response: self.response)
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        }
        
        if indexPath.row == 1 {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 44
            return UITableViewAutomaticDimension
        }
        
        if indexPath.row == 7 {
            return 150
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell0", forIndexPath: indexPath) as! InvitationTableViewCell
            
            cell.placeImage.af_setImageWithURL(NSURL(string: placeInvitation.image)!)
            
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! InvitationTableViewCell
            
            cell.placeNameLabel?.text = placeInvitation.restaurantName
            
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell6", forIndexPath: indexPath) as! InvitationTableViewCell
            
            for i in self.friendsArray {
                if i.id == self.id {
                    if i.answer.isEqual("Interested") {
                        print(i.answer)
                        self.response = "Interested"
                        cell.interestedButton.setImage(UIImage(named: "interested-1.png"), forState: .Normal)
                    }
                    else if i.answer.isEqual("Going") {
                        self.response = "Going"
                        cell.interestedButton.setImage(UIImage(named: "going-1.png"), forState: .Normal)
                        
                    }
                    else if i.answer.isEqual("Not going") {
                        self.response = "Not going"
                        cell.interestedButton.setImage(UIImage(named: "not_going-1.png"), forState: .Normal)
                    }
                }
            }
            return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell3", forIndexPath: indexPath) as! InvitationTableViewCell
            
            if placeInvitation.price.characters.count == 0 {
                cell.priceLabel?.text = "No Pricing"
            }
            else {
                cell.priceLabel?.text = "Tier: \(placeInvitation.price)"
            }
            
            return cell
        }
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell4", forIndexPath: indexPath) as! InvitationTableViewCell
            
            cell.ratingLabel?.text = placeInvitation.rating
            
            return cell
        }
        if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell5", forIndexPath: indexPath) as! InvitationTableViewCell
            
            if placeInvitation.suggestions.characters.count == 0 {
                cell.reviewsLabel?.text = "No Review"
                
            }
            else {
                cell.reviewsLabel?.text = placeInvitation.suggestions
            }
            
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! InvitationTableViewCell
            cell.addressLabel?.text = placeInvitation.address
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell7", forIndexPath: indexPath) as! InvitationTableViewCell
            cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
            return cell
        }
    }
}

extension InvitationTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
