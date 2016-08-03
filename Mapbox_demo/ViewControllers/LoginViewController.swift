//
//  LoginViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/21/16.
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


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, FBSDKAppInviteDialogDelegate {
    
    var place = Place()
    let getDataServer = GetDataService()
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        label.textAlignment = NSTextAlignment.Center;
        label.numberOfLines = 0;
        label.font = UIFont.systemFontOfSize(14.0);
        label.text = "Seems like you have not logged in yet,\nto send request you need to log in \nwith Facebook.";
        
        
        // Optional: Place the button in the center of your view.
        self.loginButton.delegate = self
        loginButton.center = self.view.center
        self.view!.addSubview(loginButton)
        
        self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User did logout")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User logged in")
        
        let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            
            if (error == nil) {

            }
        }
        
        getDataServer.getFriendsInfo { (friends) in
            if friends.count == 0 {
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("NoFriends") as! NoFriendsViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            else {
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FriendsList") as! FriendsTableViewController
                vc.place = self.place
                
                self.presentViewController(vc, animated: true, completion: nil)
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
