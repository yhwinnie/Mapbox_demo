//
//  ServiceManager.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/15/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage
import AlamofireNetworkActivityIndicator


class ServiceManager {
    
    let base_url = "https://api.foursquare.com/v2/venues/"

    func randomRestaurantsRequest (complete:
        (restaurant: Restaurant) -> Void) {

        let apiToContact = "\(base_url)explore?client_id=ABW3YVX4M52IS4PN4IORDRFCLQNJIEWPOVLX4GPY2JESYNV1&client_secret=OKMOA1GKFNDRPMQTAVRSRPBWFWHY3HDWH3GM2NK0SENT2VSQ&v=20130815&ll=37.773580,-122.417805&query=restaurants&openNow=1"
        
        Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)

                    let restaurants = json["response"]["groups"][0]["items"]
                    let random = Int(arc4random_uniform(UInt32(restaurants.count)))
                    let randomVenue = restaurants[random]["venue"]
                    
                    let name = randomVenue["name"].stringValue
                    let venue_id = randomVenue["id"].stringValue
                    let address = randomVenue["location"]["formattedAddress"][0].stringValue
                    let rating = "\(Double(round(randomVenue["rating"].doubleValue*100))/100) out of 10"
                    let tips = "Suggestions: \(restaurants[random]["tips"][0]["text"].stringValue)"
                    
                    let tier = randomVenue["price"]["tier"].stringValue
                    let priceComparison = randomVenue["price"]["tier"].intValue
                    
                    let price = self.comparePrice(priceComparison, tier: tier)
                    
                    let distance = "\(Double(round(randomVenue["location"]["distance"].doubleValue/1609.344*100))/100) miles away"
                    
                    let hours = randomVenue["hours"]["status"].stringValue
                
                    var image: String = ""
                    
                    self.imageRequest(venue_id, complete: { (imageURL) in
                        image = imageURL
                        let restaurant = Restaurant(name: name, address: address, rating: rating, price: price, hours: hours, distance: distance, tips: tips, imageURL: image)
                        complete(restaurant: restaurant)
                    })
                }

            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func imageRequest (venue_id: String, complete: (imageURL: String) -> Void) {
        
            let api = "https://api.foursquare.com/v2/venues/\(venue_id)?client_id=ABW3YVX4M52IS4PN4IORDRFCLQNJIEWPOVLX4GPY2JESYNV1&client_secret=OKMOA1GKFNDRPMQTAVRSRPBWFWHY3HDWH3GM2NK0SENT2VSQ&v=20130815"
            Alamofire.request(.GET, api).validate().responseJSON() { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let bestPhoto = json["response"]["venue"]["bestPhoto"]
                        let prefix = bestPhoto["prefix"].stringValue
                        let suffix = bestPhoto["suffix"].stringValue
                        let width = bestPhoto["width"].stringValue
                        let height = bestPhoto["height"].stringValue
                    
                        let imageURL = "\(prefix)\(width)"+"x"+"\(height)\(suffix)"
                        complete(imageURL: imageURL)
                    
                    }
                
                case .Failure(let error):
                    print(error)
            }
        }
    }
        
    
    func comparePrice(priceComparison: Int, tier: String) -> String {
        
        var price: String = "Tier: \(tier)"
        if priceComparison == 1 {
            price = price + ", < $10 an entree"
        }
        else if priceComparison == 2 {
            price = price + ", $10-$20 an entree"
            
        }
        else if priceComparison == 3 {
            price = price + ", $20-$30 an entree"
        }
        else if priceComparison == 4 {
            price = price + ", > $30 an entree"
        }
        return price
    }
}