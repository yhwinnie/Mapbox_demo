//
//  SeeAnswerViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/29/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SeeAnswerViewController: UIViewController {
    
    let getDataService = GetDataService()
    
    // IBOutlets
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var suggestionsLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    // Variables
    var placeID: String = ""
    var friendsArray = [FriendsNameFacebookID]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggestionsLabel.textAlignment = NSTextAlignment.Center;
        suggestionsLabel.numberOfLines = 0;
        suggestionsLabel.font = UIFont.systemFontOfSize(14.0);
        self.view.addSubview(suggestionsLabel);

        loadUIView()
        loadInvited()
    }
    
    func loadPoster(urlString: String) {
        restaurantImageView.af_setImageWithURL(NSURL(string: urlString)!)
    }
    
    func loadUIView() {
        
        getDataService.getPlaceInfo(self.placeID) { (place) in

            self.restaurantNameLabel.text = place.restaurantName
            self.addressLabel.text = place.address
            self.hoursLabel.text = place.hours
            self.suggestionsLabel.text = place.suggestions
            self.priceLabel.text = place.price
            self.loadPoster(place.image)
        }
    }
    
    func loadInvited() {
        getDataService.getFriendsAnswes(self.placeID) { (friendsInfo) in
        
        self.friendsArray = friendsInfo
            
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            }
        }
    }
}

extension SeeAnswerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let answer = friendsArray[indexPath.row]
        cell.textLabel!.text = "\(answer.name): \(answer.answer)"
        
        return cell
    }
}
