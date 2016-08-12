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
    @IBOutlet weak var randomPopView: UIView!
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
    
    @IBOutlet weak var inviteButton: UIButton!
    // Variables
    var indexSelected: Int = 0
    let serviceManager = ServiceManager()
    let place = Place()
    let getDataServer = GetDataService()
    var image: String = ""
    
    var indicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skipButton.layer.cornerRadius = 5;
        skipButton.layer.borderWidth = 1;
        skipButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        inviteButton.layer.cornerRadius = 5;
        inviteButton.layer.borderWidth = 1;
        inviteButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        randomPopUpView.layer.cornerRadius = 10.0
        randomPopUpView.layer.borderColor = UIColor.grayColor().CGColor
        randomPopUpView.layer.borderWidth = 0.5
        randomPopUpView.clipsToBounds = true
        
        loadUIView()
        

    }
    
    func loadUIView() {
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        indicator.center = self.restaurantImageView.center
        self.restaurantImageView.addSubview(indicator)
        indicator.bringSubviewToFront(self.restaurantImageView)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.indicator.startAnimating()
        
        serviceManager.randomRestaurantsRequest(indexSelected) { (restaurant) in
            
            dispatch_async(dispatch_get_main_queue(), {
//                UIView.animateWithDuration(0.9, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: .CurveLinear, animations: {

                    
                
                self.restaurantName.text = restaurant.name
                    
                //self.restaurantName.center = CGPoint(x: 200, y:150+90 )
                self.addressLabel.text = restaurant.address
                    //self.addressLabel.center = CGPoint(x: 200, y:150+90 )
                    
                if restaurant.hours.characters.count == 0 {
                    self.hoursLabel.text = "No hours given"
                    //self.hoursLabel.center = CGPoint(x: 200, y:150+90 )
                }
                else {
                    self.hoursLabel.text = restaurant.hours
                    //self.hoursLabel.center = CGPoint(x: 200, y:50 )
                }
                if restaurant.rating.characters.count == 0 {
                    self.ratingLabel.text = "No rating given"
                    //self.ratingLabel.center = CGPoint(x: 200, y:50 )
                }
                else {
                    self.ratingLabel.text = restaurant.rating
                    //self.ratingLabel.center = CGPoint(x: 200, y:50 )
                }
                if restaurant.tips.characters.count == 0 {
                    self.tipsLabel.text = "No Review"
                    //self.tipsLabel.center = CGPoint(x: 200, y:50 )
                    

                }
                else {
                
                    self.tipsLabel.text = "Suggestions: \(restaurant.tips)"
                    //self.tipsLabel.center = CGPoint(x: 200, y:50 )
                }
                if restaurant.price.characters.count == 0 {
                    self.priceLabel.text = "No Price"
                    //self.priceLabel.center = CGPoint(x: 200, y:50 )
                }
                else {
                    self.priceLabel.text = "Tier: \(restaurant.price)"
                    //self.priceLabel.center = CGPoint(x: 200, y:50 )
                }
                self.distanceLabel.text = restaurant.distance
                    //self.distanceLabel.center = CGPoint(x: 200, y:50 )
                self.loadPoster(restaurant.imageURL)
                self.image = restaurant.imageURL
                //self.restaurantImageView.frame = CGRectMake(320.0, 30.0, self.restaurantImageView.frame.size.width, self.restaurantImageView.frame.size.height)
                
                self.indicator.stopAnimating()
                //}, completion: nil)
                
            })
        }
    }
    
    @IBAction func skipAction(sender: AnyObject) {
        loadUIView()
//        self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        self.indicator.frame = CGRectMake(0.0, 0.0, 50.0, 50.0);
//        self.indicator.center = self.restaurantImageView.center
//        self.restaurantImageView.addSubview(self.indicator)
//        self.indicator.bringSubviewToFront(self.restaurantImageView)
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        
//        self.indicator.startAnimating()
//        
//        serviceManager.randomRestaurantsRequest(indexSelected) { (restaurant) in
//            
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                self.restaurantName.text = restaurant.name
//                self.addressLabel.text = restaurant.address
//                if restaurant.hours.characters.count == 0 {
//                    self.hoursLabel.text = "No hours given"
//                }
//                else {
//                    self.hoursLabel.text = restaurant.hours
//                }
//                if restaurant.rating.characters.count == 0 {
//                    self.ratingLabel.text = "No rating given"
//                }
//                else {
//                    self.ratingLabel.text = restaurant.rating
//                }
//                
//                if restaurant.tips.characters.count == 0 {
//                    self.tipsLabel.text = "No Review"
//                }
//                else {
//                    
//                    self.tipsLabel.text = restaurant.tips
//                }
//                if restaurant.price.characters.count == 0 {
//                    self.priceLabel.text = "No Price"
//                }
//                else {
//                    self.priceLabel.text = "Tier: \(restaurant.price)"
//                }
//                self.priceLabel.text = "Tier: \(restaurant.price)"
//                self.distanceLabel.text = restaurant.distance
//                self.loadPoster(restaurant.imageURL)
//                self.image = restaurant.imageURL
//                self.indicator.stopAnimating()
//                
//            })
//        }
    }
    
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    
    
    @IBOutlet weak var skipButton: UIButton!
    func loadPoster(urlString: String) {
        restaurantImageView.af_setImageWithURL(NSURL(string: urlString)!)
        // self.indicator.stopAnimating()
        
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
