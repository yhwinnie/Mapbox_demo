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
    var name: String = ""
    var url: String = ""
    var count: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func signOut(sender: AnyObject) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("tabBar")
        self.presentViewController(vc, animated: true, completion: nil)
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FriendsTableViewCell
        
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: params
        );
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                {
                    
                    //self.count = userNameArray.count
                    self.count = userNameArray.count
                    
                    if userNameArray.count == 0 {
                        print("You do not have friends yet!")
                    } else {
                        //var i: Int = 0
                        
                        let id = userNameArray[indexPath.row].valueForKey("id") as! String
                        print(id)
                        
                        cell.friendsNameLabel.text = userNameArray[indexPath.row].valueForKey("name") as! String
                        var picture = userNameArray[indexPath.row].valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as! String
                        var url = NSURL(string: picture)
                        if let url = url {
                            cell.imageView2.af_setImageWithURL(url)
       
                        }
                    }
                } else {
                    print("Error Getting Friends \(error)");
                }
            }
        }

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark
            {
                cell.accessoryType = .None
            }
            else
            {
                cell.accessoryType = .Checkmark
                var ref = FIRDatabaseReference.init()
                ref = FIRDatabase.database().reference()
                let userID = FIRAuth.auth()?.currentUser?.uid
                
                if let userID = userID {
                    print(userID)
                    ref.child("users/requests/request1").setValue(true)
                    ref.child("requests/request1/From").setValue(userID)
                    
                }
            }
        }
    }

    



    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
