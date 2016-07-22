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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
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
        
        
        var ref = FIRDatabase.database().reference()
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            
            if ((error) != nil) {
                print(user);
            }
        }
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let email = FIRAuth.auth()?.currentUser?.email
        
        print(email)
        
        ref.child("users/(userID)/email").setValue(email)
        
        let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Friends")
        presentViewController(vc, animated: true, completion: nil)

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
