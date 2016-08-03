//
//  GetDataService.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/28/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import Foundation
import FBSDKShareKit
import Firebase


class GetDataService {
    
    static var ref = FIRDatabase.database().reference()
    var request = [Invitation]()
    
    // Get all invitations
    func requestInvitations(currentUserid: String, complete: (invitations: [Invitation]) -> Void) {
        
        GetDataService.ref.child("users").child(currentUserid).child("requests").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            for snap in snapshot.children {
                let child = snap as! FIRDataSnapshot
                let req = Invitation()
                req.placeID = child.key
                self.getRequestInfo(req, complete: { (req) in
                    self.request.append(req)
                    if self.request.count == Int(snapshot.childrenCount) {
                        complete(invitations: self.request)
                    }
                })
            }
        })
    }
    
    // Get one single invitation
    func getRequestInfo(req: Invitation, complete: (req: Invitation) -> Void) {
        
        GetDataService.ref.child("requests").child(req.placeID).observeEventType(.Value, withBlock: { (snapshot) in
            var array = [String]()
            let fromPerson = snapshot.value!["from"] as! NSDictionary
            let toFriends = snapshot.value!["to"] as! NSDictionary
            let getPlaceID = snapshot.value!["placeID"]
            
            let date = snapshot.value!["date"]
            req.date = date as! String
            
            for (key, value) in fromPerson {
                req.fromPersonID = key as! String
                req.fromPersonName = value as! String
            }
            for value in toFriends.allValues {
                array.append(value as! String)
            }
            
            self.getPlaceName(req, complete: { (req) in
                req.to = array
                complete(req: req)
                
            })
        })
    }
    
    // Get restaurant name
    func getPlaceName(req: Invitation, complete: (req: Invitation) -> Void) {
        GetDataService.ref.child("places/\(req.placeID)").observeEventType(.Value, withBlock: { (snapshot) in
            
            let restaurantName = snapshot.value!["name"] as! String
            req.restaurantName = restaurantName
            complete(req: req)
        })
    }
    
    
    
    // Get the current user's facebook id
    func getFacebookID(complete: (facebookID: String) -> Void) {
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name"])
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil) {
                let userID = result.valueForKey("id")! as! String
                complete(facebookID: userID)
            }
        })
    }
    
    // Get the current user's name
    func getUserName(complete: (name: String) -> Void) {
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name"])
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil) {
                let userID = result.valueForKey("name")! as! String
                complete(name: userID)
            }
        })
    }
    
    func getFriendsInfo(complete: (friends: [Friends]) -> Void) {
        
        var friendsArray = [Friends]()
        let params = ["fields": "id, name, picture"]
        
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: params)
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                if let userNameArray : NSArray = result.valueForKey("data") as? NSArray
                {
                    if userNameArray.count == 0 {
                        print("You do not have friends yet!")
                    } else {
                        
                        for friend in userNameArray {
                            let friends = Friends()
                            friends.name = friend.valueForKey("name") as! String
                            friends.image = friend.valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as! String
                            friends.id = friend.valueForKey("id") as! String
                            friendsArray.append(friends)
                        }
                    }
                }
            } else {
                print("Error Getting Friends \(error)");
            }
            complete(friends: friendsArray)
        }
    }
    
    
    // Get information about the place the user want to go to
    func getPlaceInfo(placeID: String, complete: (place: Place) -> Void) {
        GetDataService.ref.child("places/\(placeID)").observeEventType(.Value, withBlock: { (snapshot) in
            
            let placeInfo = Place()
            
            let restaurantName = snapshot.value!["name"] as! String
            let address = snapshot.value!["address"] as! String
            let rating = snapshot.value!["rating"] as! String
            let price = snapshot.value!["price"] as! String
            let hours = snapshot.value!["hours"] as! String
            let suggestions = snapshot.value!["suggestions"] as! String
            let imageString = snapshot.value!["image"] as! String
            
            
            placeInfo.restaurantName = restaurantName
            placeInfo.address = address
            placeInfo.rating = rating
            placeInfo.price = price
            placeInfo.hours = hours
            placeInfo.suggestions = suggestions
            placeInfo.image = imageString
            
            complete(place: placeInfo)
        })
    }
    
    // Request the answers from invited friends
    func getFriendsAnswes(placeID: String, complete: (friendsInfo: [FriendsNameFacebookID]) -> Void) {
        
        GetDataService.ref.child("answers/\(placeID)").observeEventType(.Value, withBlock: { (snapshot) in
            
            var friendsArray = [FriendsNameFacebookID]()
            let dict = snapshot.value! as! NSDictionary
            for (key, value) in dict {
                self.getNameWithFacebookID(key as! String, complete: { (name) in
                    let friends = FriendsNameFacebookID()
                    friends.name = name
                    friends.answer = value as! String
                    friendsArray.append(friends)
                    complete(friendsInfo: friendsArray)
                })
            }
        })
    }
    
    // Get users name from their facebook id
    func getNameWithFacebookID(facebookID: String, complete: (name: String) -> Void) {
        GetDataService.ref.child("users/\(facebookID)").observeEventType(.Value, withBlock: { (snapshot) in
            let userName = snapshot.value!["name"] as! String
            complete(name: userName)
        })
    }
    
}