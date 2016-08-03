//
//  ListTableViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/18/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import FBSDKShareKit

class ListTableViewController: UITableViewController {
    
    // Variables
    let getDataServer = GetDataService()
    var invitationArray = [Invitation]()
    var userFacebookId: String = ""
    
    // IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getDataServer.getFacebookID { (facebookID) in
            self.userFacebookId = facebookID
            self.getDataServer.requestInvitations(facebookID, complete: { (invitations) in
                self.invitationArray = invitations
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            })
        }
        uiChanges()
    }
    
    func uiChanges() {
        // set navigation bar appearance
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.translucent = false
            navigationBar.tintColor = UIColor.whiteColor()
            navigationBar.barTintColor = UIColor(red:0.20, green:0.60, blue:0.40, alpha:1.0)
            navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationBar.shadowImage = UIImage()
        }
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    
    @IBAction func signOutAction(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("tabBar")
        self.presentViewController(vc, animated: true, completion: nil)
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
        return self.invitationArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NewsFeedTableViewCell
        
        var person: String = ""
        let invitation = invitationArray[indexPath.row]
        var fromPerson = invitation.fromPersonName
        let toFriends = invitation.to
        
        if userFacebookId == invitation.fromPersonID {
            fromPerson = "You"
        }
        
        for friend in toFriends {
            print(friend)
            person += " \(friend)"
        }
        
        cell.requestLabel?.text = "\(fromPerson) invited\(person)"
        cell.placeNameLabel?.text = "\(invitation.restaurantName)"
        cell.dateLabel?.text = "\(invitation.date)"
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let invite = invitationArray[indexPath.row]
        
        if invite.fromPersonID == userFacebookId {
            let viewc = self.storyboard!.instantiateViewControllerWithIdentifier("SeeAnswer") as! SeeAnswerViewController
            viewc.placeID = invite.placeID 
            self.presentViewController(viewc, animated: true, completion: nil)
            
        } else {
            
            let viewc = self.storyboard!.instantiateViewControllerWithIdentifier("respondView") as! ResponseViewController
            viewc.placeID = invite.placeID 
            self.presentViewController(viewc, animated: true, completion: nil)
        }
    }
}
