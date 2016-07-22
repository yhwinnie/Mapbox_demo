//
//  FriendsViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/22/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKShareKit
import FBSDKMessengerShareKit
import FBAudienceNetwork

class FriendsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource, FBSDKAppInviteDialogDelegate {
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let count = 0
        var arr = ["\(count) Facebook Friends", "Invite Facebook Friends", "Sign Out"]
        
        cell.textLabel!.text = arr[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 1 {
            let content: FBSDKAppInviteContent = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "https://www.mydomain.com/myapplink")!
        //optionally set previewImageURL
        content.appInvitePreviewImageURL = NSURL(string: "https://www.mydomain.com/my_invite_image.jpg")!
        // Present the dialog. Assumes self is a view controller
        // which implements the protocol `FBSDKAppInviteDialogDelegate`.
        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)

        } else {
            let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters:["fields": "email"]
            );
            fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if error == nil {
                    if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                    {
                        var i: Int = 0
                        
                        if userNameArray.count == 0 {
                            print("You do not have friends yet!")
                        } else {
                            while i < userNameArray.count
                            {
                                print(userNameArray[i].valueForKey("name"))
                                i += 1
                            
                        
                            }
                        }
                    }
                }
                else {
                        
                    print("Error Getting Friends \(error)");
                }
            }
        }
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        //TODO
    }
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        //TODO
    }
}
