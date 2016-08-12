//
//  FriendsTableViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/22/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class FriendsTableViewController: UITableViewController {
    
    let getDataServer = GetDataService()
    var name: String = ""
    var userId: String = ""
    var index = [Int]()
    var arr = [String: String]()
    
    var friendsArr = [Friends]()
    var place = Place()
    var uuid = NSUUID().UUIDString
    
    var indicator: UIActivityIndicatorView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if index.isEmpty {
            sendButton.enabled = false
        }
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        indicator.center = self.tableView.center
        self.tableView.addSubview(indicator)
        indicator.bringSubviewToFront(self.tableView)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.indicator.startAnimating()
        
        getDataServer.getFriendsInfo { (friendsList) in
            self.friendsArr = friendsList
            self.getPersonalInfo()
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
            }
        }
        
    }
    
    // Get personal information
    func getPersonalInfo () {
        self.getDataServer.getFacebookID { (facebookID) in
            self.getDataServer.getUserName({ (name) in
                self.name = name
                self.userId = facebookID
            })
        }
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonAction(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
        vc.selectedIndex = 1
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FriendsTableViewCell
        
        let name = friendsArr[indexPath.row].name
        let picture = friendsArr[indexPath.row].image
        
        cell.friendsNameLabel?.text = name
        cell.imageView2.af_setImageWithURL(NSURL(string: picture)!)
        
        return cell
    }
    
    @IBAction func sendToFriendsAction(sender: AnyObject) {
        
        for i in self.index {
            let friend = friendsArr[i]
            self.arr[friend.id] = friend.name
            friend.requestID = self.uuid
            
            let currentDate = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale.currentLocale()
    
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let convertedDate = dateFormatter.stringFromDate(currentDate)
            
            
            // Save other information
            DataService.dataService.saveInformationToFirebase(self.userId, uuid: self.uuid, friendRequestId: friend.requestID, friendId: friend.id, userName: self.name, friendName: friend.name, array: self.arr, date: convertedDate)
            
            // Save place
            DataService.dataService.savePlaceToFirebase(friend.requestID, place: self.place)
            
        }
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
        vc.selectedIndex = 1
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            if cell.accessoryType == .Checkmark
            {
                cell.accessoryType = .None
                
                let removeIndex = index.indexOf(indexPath.row)
                index.removeAtIndex(removeIndex!)
                if index.isEmpty {
                    sendButton.enabled = false
                }
            }
            else
            {
                sendButton.enabled = true
                cell.accessoryType = .Checkmark
                index.append(indexPath.row)
            }
        }
    }
}
