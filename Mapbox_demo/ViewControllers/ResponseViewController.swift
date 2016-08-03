//
//  ResponseViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 8/1/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ResponseViewController: UIViewController {
    
    var placeID: String = ""
    var getDataService = GetDataService()
    var response = "Pending"
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUIView()
    }

    
    @IBAction func saveAction(sender: AnyObject) {
        respondAction()
    }
    
    func loadUIView() {
        self.getDataService.getPlaceInfo(self.placeID) { (place) in
            
            self.restaurantName.text = place.restaurantName
            self.addressLabel.text = place.address
            self.hoursLabel.text = place.hours
            self.reviewLabel.text = place.suggestions
            self.priceLabel.text = place.price
            self.loadPoster(place.image)
        }
    }
    
    func loadPoster(urlString: String) {
        restaurantImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    func respondAction() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            response = "Pending"
        case 1:
            response = "Yes"
        case 2:
            response = "No"
        default:
            break
        }
        updateToDatabase()
    }
    
    func updateToDatabase() {
        self.getDataService.getFacebookID { (facebookID) in
            DataService.dataService.setAnswer(self.placeID, facebookID: facebookID, response: self.response)
        }
    }
}
