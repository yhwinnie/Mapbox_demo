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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if index.isEmpty {
            sendButton.enabled = false
        }
        getDataServer.getFriendsInfo { (friendsList) in
            self.friendsArr = friendsList
            self.getPersonalInfo()
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
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
    
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            var convertedDate = dateFormatter.stringFromDate(currentDate)
            
            
            // Save other information
            DataService.dataService.saveInformationToFirebase(self.userId, uuid: self.uuid, friendRequestId: friend.requestID, friendId: friend.id, userName: self.name, friendName: friend.name, array: self.arr, date: convertedDate)
            
            // Save place
            DataService.dataService.savePlaceToFirebase(friend.requestID, place: self.place)
            
        }
        self.performSegueWithIdentifier("ToFriendsList", sender: nil)
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
