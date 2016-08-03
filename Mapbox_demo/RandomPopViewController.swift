//
//  RandomPopViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/14/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import AlamofireNetworkActivityIndicator
import FBSDKLoginKit



class RandomPopViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var randomPopUpView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // Variables
    var indexSelected: Int = 0
    let serviceManager = ServiceManager()
    let place = Place()
    let getDataServer = GetDataService()
    var image: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomPopUpView.layer.cornerRadius = 10.0
        randomPopUpView.layer.borderColor = UIColor.grayColor().CGColor
        randomPopUpView.layer.borderWidth = 0.5
        randomPopUpView.clipsToBounds = true
        
        serviceManager.randomRestaurantsRequest(indexSelected) { (restaurant) in
            dispatch_async(dispatch_get_main_queue(), {
                self.restaurantName.text = restaurant.name
                self.addressLabel.text = restaurant.address
                self.hoursLabel.text = restaurant.hours
                self.ratingLabel.text = restaurant.rating
                self.tipsLabel.text = restaurant.tips
                self.priceLabel.text = restaurant.price
                self.distanceLabel.text = restaurant.distance
                self.loadPoster(restaurant.imageURL)
                self.image = restaurant.imageURL
                
            })
        }
    }
    
    @IBAction func skipAction(sender: AnyObject) {
        
        serviceManager.randomRestaurantsRequest(indexSelected) { (restaurant) in
            dispatch_async(dispatch_get_main_queue(), {
                self.restaurantName.text = restaurant.name
                self.addressLabel.text = restaurant.address
                self.hoursLabel.text = restaurant.hours
                self.ratingLabel.text = restaurant.rating
                self.tipsLabel.text = restaurant.tips
                self.priceLabel.text = restaurant.price
                self.distanceLabel.text = restaurant.distance
                self.loadPoster(restaurant.imageURL)
                self.image = restaurant.imageURL
            })
        }
    }
    
    @IBOutlet weak var skipButton: UIButton!
    func loadPoster(urlString: String) {
        restaurantImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    @IBAction func goButton(sender: AnyObject) {
        
        
        self.place.restaurantName = self.restaurantName.text!
        self.place.address = self.addressLabel.text!
        self.place.distance = self.distanceLabel.text!
        self.place.rating = self.ratingLabel.text!
        self.place.hours = self.hoursLabel.text!
        self.place.price = self.priceLabel.text!
        self.place.suggestions = self.tipsLabel.text!
        self.place.image = image
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            
            self.getDataServer.getFriendsInfo({ (friends) in
                if friends.count == 0 {
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("NoFriends") as! NoFriendsViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                else {
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("FriendsList") as! FriendsTableViewController
                    vc.place = self.place
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            })
        }
        else {
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
            vc.place = self.place
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        super.touchesBegan(touches, withEvent:event)
    }
}
