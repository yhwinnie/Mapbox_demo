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

class ListTableViewController: UITableViewController, FBSDKAppInviteDialogDelegate {
    
    // Variables
    let getDataServer = GetDataService()
    var invitationArray = [Invitation]()
    var userFacebookId: String = ""
    var details = [NSDate]()
    
    
    // IBOutlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            signOutButton.title = "Sign In"
        }
        
        self.getDataServer.getFacebookID { (facebookID) in
            self.userFacebookId = facebookID
            self.getDataServer.requestInvitations(facebookID, complete: { (invitations) in
                self.invitationArray = invitations
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    
                    self.invitationArray.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
                    
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
            navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationBar.shadowImage = UIImage()
        }
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        //TODO
    }
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        //TODO
    }
    
    
    @IBAction func signOutAction(sender: AnyObject) {
        
        let loginManager = FBSDKLoginManager()
        
        if (sender.title == "Sign Out") {
            loginManager.logOut()
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("tabBar")
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else {
            loginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
                vc.selectedIndex = 1
                self.presentViewController(vc, animated: true, completion: nil)
            })
        }
    }
    
    
    
    @IBAction func inviteFriends(sender: AnyObject) {
        
            
            let content: FBSDKAppInviteContent = FBSDKAppInviteContent()
            content.appLinkURL = NSURL(string: "https://fb.me/1011761262277370")!
            //optionally set previewImageURL
            //content.appInvitePreviewImageURL = NSURL(string: "https://itunes.apple.com/us/app/meal-out/id1142386653?mt=8")!
            // Present the dialog. Assumes self is a view controller
            // which implements the protocol `FBSDKAppInviteDialogDelegate`.
            FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
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
            person += " \(friend)"
        }
        
        cell.requestLabel?.text = "\(fromPerson) invited\(person)"
        cell.placeNameLabel?.text = "\(invitation.restaurantName)"
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        
        let stringDate: String = formatter.stringFromDate(invitation.date)
        
        cell.dateLabel?.text = "\(stringDate)"
        details.append(invitation.date)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let invite = invitationArray[indexPath.row]
        
        if invite.fromPersonID == userFacebookId {
            let viewc = self.storyboard!.instantiateViewControllerWithIdentifier("SeeAnswer1") as! GoingTableViewController
            viewc.placeID = invite.placeID
            self.presentViewController(viewc, animated: true, completion: nil)
            
        } else {
            
            let viewc = self.storyboard!.instantiateViewControllerWithIdentifier("RespondView") as! InvitationTableViewController
            viewc.placeID = invite.placeID
            self.presentViewController(viewc, animated: true, completion: nil)
        }
    }
}
