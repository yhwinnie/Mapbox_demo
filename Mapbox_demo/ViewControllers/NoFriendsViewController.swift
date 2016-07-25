//
//  NoFriendsViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/25/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FBSDKMessengerShareKit
import FBAudienceNetwork

class NoFriendsViewController: UIViewController, FBSDKAppInviteDialogDelegate {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.textAlignment = NSTextAlignment.Center;
        label.numberOfLines = 0;
        label.font = UIFont.systemFontOfSize(14.0);
        label.text = "Seems like you don't have any friends yet.\nWhy don't you invite your friends to use the app?";
        self.view.addSubview(label);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        //TODO
    }
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        //TODO
    }
    
    
    
    @IBAction func inviteFriendsAction(sender: AnyObject) {
        
        let content: FBSDKAppInviteContent = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "https://www.mydomain.com/myapplink")!
        //optionally set previewImageURL
        content.appInvitePreviewImageURL = NSURL(string: "https://www.mydomain.com/my_invite_image.jpg")!
        // Present the dialog. Assumes self is a view controller
        // which implements the protocol `FBSDKAppInviteDialogDelegate`.
        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
        
        
    }
}
