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
    
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        label.textAlignment = NSTextAlignment.Center;
        label.numberOfLines = 0;
        label.font = UIFont.systemFontOfSize(14.0);
        label.text = "Seems like you have not logged in yet,\nto send request you need to log in \nwith Facebook.";
        self.view.addSubview(label);
        
        
        
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
        
        var ref = FIRDatabaseReference.init()
        ref = FIRDatabase.database().reference()
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            
            if (error == nil) {
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                if let userID = userID {
                    print(userID)
                    ref.child("users/\(userID)/userID").setValue(userID)
                }
            }
        }
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, full_picture"]
        
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: params
        );
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                {
                    var i: Int = 0
                    
                    if userNameArray.count == 0 {
                        print("You do not have friends yet!")
                        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("NoFriends") as! NoFriendsViewController
                        self.presentViewController(vc, animated: true, completion: nil)
                        
                        
                    } else {
                        while i < userNameArray.count
                        {
                            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FriendsList") as! FriendsTableViewController
                            vc.url = String(userNameArray[i].valueForKey("full_picture")?.valueForKey("data")?.valueForKey("url"))
                            vc.name = String(userNameArray[i].valueForKey("name")!)
                            self.presentViewController(vc, animated: true, completion: nil)
                            
                            
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
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        //TODO
    }
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        //TODO
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
