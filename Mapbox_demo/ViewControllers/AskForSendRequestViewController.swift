//
//  AskForSendRequestViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/21/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import FBSDKShareKit

class AskForSendRequestViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        label.textAlignment = NSTextAlignment.Center;
        label.numberOfLines = 0;
        label.font = UIFont.systemFontOfSize(14.0);
        label.text = "Isn't it lonely to go alone?\nWhy don't you invite\n some friends to go with you?";

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func yesButton(sender: AnyObject) {
    

        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
        
            let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture.width(1000).height(1000)"]
            
            let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: params
            );
            fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if error == nil {
                    if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                    {
                        print(userNameArray)
                        var i: Int = 0
                        
                        if userNameArray.count == 0 {
                            print("You do not have friends yet!")
                            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("NoFriends") as! NoFriendsViewController
                            self.presentViewController(vc, animated: true, completion: nil)
                            
                            
                        } else {
                            while i < userNameArray.count
                            {
                                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FriendsList") as! FriendsTableViewController
                                vc.url = String(userNameArray[i].valueForKey("picture")?.valueForKey("data")?.valueForKey("url"))
                                print(vc.url)
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
        else {
            let vc : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView")
            presentViewController(vc, animated: true, completion: nil)
        }
    }
}
