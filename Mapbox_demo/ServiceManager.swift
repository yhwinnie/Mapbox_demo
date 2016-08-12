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
import CoreLocation
import Mapbox
import MapboxGeocoder
import MapboxDirections

class ServiceManager {
    
    
    
    let base_url = "https://api.foursquare.com/v2/venues/"
    
    func requestActivitiesPlaces(searchBarText: String?, complete: (activitiesPlacesList: [Pin], coordinates: CLLocationCoordinate2D) -> Void) {
        
        convertAddressToLatLon(searchBarText!) { (coordinates) in
            
            
            let lat = coordinates.latitude
            let lng = coordinates.longitude
            
            
            let apiToContact = "\(self.base_url)explore?client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20130815&ll=\(lat),\(lng)&query=POI&openNow=1"
            
            Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let activityPlaces = json["response"]["groups"][0]["items"]
                        
                        var activitiesPlacesList = [Pin]()
                        
                        for index in 0 ..< activityPlaces.count {
                            let name = activityPlaces[index]["venue"]["name"].stringValue
                            let address = activityPlaces[index]["venue"]["location"]["formattedAddress"][0].stringValue
                            let lat = activityPlaces[index]["venue"]["location"]["lat"].doubleValue
                            let lng = activityPlaces[index]["venue"]["location"]["lng"].doubleValue
                            let point = MGLPointAnnotation()
                            point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            
                            let pin = Pin(name: name, address: address, coordinates: point.coordinate)
                            
                            activitiesPlacesList.append(pin)
                        }
                        complete(activitiesPlacesList: activitiesPlacesList, coordinates: coordinates)
                    }
                    
                case .Failure(let error):
                    print(error)
                    
                }
            }
        }
    }
    
    func convertAddressToLatLon(address: String?, complete: (coordinates: CLLocationCoordinate2D) -> Void) {
        
        let address = address
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                complete(coordinates: coordinates)
            }
        })
    }
    
    
    func requestBobaPlaces(searchBarText: String, complete: (bobaPlacesList: [Pin], coordinates: CLLocationCoordinate2D) -> Void) {
        
        convertAddressToLatLon(searchBarText) { (coordinates) in
            
            
            let lat = coordinates.latitude
            let lng = coordinates.longitude
            
            
            
            let apiToContact = "\(self.base_url)explore?client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20130815&ll=\(lat),\(lng)&query=coffee&openNow=1"
            
            Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let bobaPlaces = json["response"]["groups"][0]["items"]
                        
                        var bobaPlacesList = [Pin]()
                        
                        for index in 0 ..< bobaPlaces.count {
                            let name = bobaPlaces[index]["venue"]["name"].stringValue
                            let address = bobaPlaces[index]["venue"]["location"]["formattedAddress"][0].stringValue
                            let lat = bobaPlaces[index]["venue"]["location"]["lat"].doubleValue
                            let lng = bobaPlaces[index]["venue"]["location"]["lng"].doubleValue
                            let point = MGLPointAnnotation()
                            point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            let pin = Pin(name: name, address: address, coordinates: point.coordinate)
                            
                            bobaPlacesList.append(pin)
                        }
                        complete(bobaPlacesList: bobaPlacesList, coordinates: coordinates)
                    }
                    
                case .Failure(let error):
                    print(error)
                    
                }
            }
        }
        
    }
    
    
    func allNearbyRestaurantsRequest (searchBarText: String, complete: (listRestaurants: [Pin], coordinates: CLLocationCoordinate2D) -> Void) {
        
        convertAddressToLatLon(searchBarText) { (coordinates) in
            
            
            let lat = coordinates.latitude
            let lng = coordinates.longitude
            
            let apiToContact = "\(self.base_url)explore?client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20130815&ll=\(lat),\(lng)&query=restaurants&openNow=1"
            
            
            Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let restaurants = json["response"]["groups"][0]["items"]
                        //let random = Int(arc4random_uniform(UInt32(restaurants.count)))
                        //let randomVenue = restaurants[random]["venue"]
                        
                        var listRestaurants = [Pin]()
                        
                        for index in 0 ..< restaurants.count {
                            let name = restaurants[index]["venue"]["name"].stringValue
                            let address = restaurants[index]["venue"]["location"]["formattedAddress"][0].stringValue
                            let lat = restaurants[index]["venue"]["location"]["lat"].doubleValue
                            let lng = restaurants[index]["venue"]["location"]["lng"].doubleValue
                            let point = MGLPointAnnotation()
                            point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            let pin = Pin(name: name, address: address, coordinates: point.coordinate)
                            
                            
                            listRestaurants.append(pin)
                        }
                        complete(listRestaurants: listRestaurants, coordinates: coordinates)
                        
                    }
                    
                case .Failure(let error):
                    print(error)
                    
                }
            }
        }
    }
    
    
    func randomRestaurantsRequest (indexSelected:Int, complete:
        (restaurant: Restaurant) -> Void) {
        
        convertAddressToLatLon(searchBarText14) { (coordinates) in
            
            
            let lat = coordinates.latitude
            let lng = coordinates.longitude
            
            
            var query: String = ""
            
            if indexSelected == 0 {
                query = "restaurants"
            }
            else if indexSelected == 1 {
                query = "coffee"
            }
            else if indexSelected == 2 {
                query = "POI"
            }
            
            
            
            let apiToContact = "\(self.base_url)explore?client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20130815&ll=\(lat),\(lng)&query=\(query)&openNow=1"
            
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
                        let tips = "\(restaurants[random]["tips"][0]["text"].stringValue)"
                        
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
    }
    
    func randomNearbyRestaurantRequest(indexSelected: Int, complete: (restaurant: Restaurant) -> Void) {
        convertAddressToLatLon(searchBarText14) { (coordinates) in
            
            
            let lat = coordinates.latitude
            let lng = coordinates.longitude
            
            
            var query: String = ""
            
            if indexSelected == 0 {
                query = "restaurants"
            }
            else if indexSelected == 1 {
                query = "coffee"
            }
            else if indexSelected == 2 {
                query = "POI"
            }
            
            
            let apiToContact = "\(self.base_url)search?client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20130815&ll=\(lat),\(lng)&query=\(query)&openNow=1"
            
            Alamofire.request(.GET, apiToContact).validate().responseJSON() { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        let restaurants = json["response"]["venues"]
                        let random = Int(arc4random_uniform(UInt32(restaurants.count)))
                        let randomVenue = restaurants[random]
                        
                        
                        _ = randomVenue["name"].stringValue
                        _ = randomVenue["id"].stringValue
                        _ = randomVenue["location"]["formattedAddress"][0].stringValue
                        // let rating = "\(Double(round(randomVenue["rating"].doubleValue*100))/100) out of 10"
                        //let tips = "Suggestions: \(restaurants[random]["tips"][0]["text"].stringValue)"
                        
                        //let tier = randomVenue["price"]["tier"].stringValue
                        //let priceComparison = randomVenue["price"]["tier"].intValue
                        
                        //let price = self.comparePrice(priceComparison, tier: tier)
                        
                        //let distance = "\(Double(round(randomVenue["location"]["distance"].doubleValue/1609.344*100))/100) miles away"
                        
                        //let hours = randomVenue["hours"]["status"].stringValue
                        
                        //                        var image: String = ""
                        //
                        //                        self.imageRequest(venue_id, complete: { (imageURL) in
                        //                            image = imageURL
                        //                            let restaurant = Restaurant(name: name, address: address, rating: rating, price: price, hours: hours, distance: distance, tips: tips, imageURL: image)
                        //                            complete(restaurant: restaurant)
                        //                        })
                    }
                    
                case .Failure(let error):
                    print(error)
                    
                }
            }
        }
    }
    
    
    
    
    func imageRequest (venue_id: String, complete: (imageURL: String) -> Void) {
        
        let api = "https://api.foursquare.com/v2/venues/\(venue_id)?client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&v=20130815"
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
        
        var price: String = "\(tier)"
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