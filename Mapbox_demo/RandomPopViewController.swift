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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomPopUpView.layer.cornerRadius = 10.0
        randomPopUpView.layer.borderColor = UIColor.grayColor().CGColor
        randomPopUpView.layer.borderWidth = 0.5
        randomPopUpView.clipsToBounds = true
        
        let serviceManager = ServiceManager()
        
        serviceManager.randomRestaurantsRequest { (restaurant) in
            dispatch_async(dispatch_get_main_queue(), {
                self.restaurantName.text = restaurant.name
                self.addressLabel.text = restaurant.address
                self.hoursLabel.text = restaurant.hours
                self.ratingLabel.text = restaurant.rating
                self.tipsLabel.text = restaurant.tips
                self.priceLabel.text = restaurant.price
                self.distanceLabel.text = restaurant.distance
                self.loadPoster(restaurant.imageURL)
            })
        }
    }
    
    
    func loadPoster(urlString: String) {
        restaurantImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        self.dismissViewControllerAnimated(true, completion: nil)
        super.touchesBegan(touches, withEvent:event)
    }
}