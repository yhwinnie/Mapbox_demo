//
//  Place.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/29/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import Foundation

class Place {
    var restaurantName: String = ""
    var address: String = ""
    var rating: String = ""
    var price: String = ""
    var distance: String = ""
    var hours: String = ""
    var suggestions: String = ""
    var placeID: String = ""
    var image: String = ""
    
    
    init() {
        
    }
    
    init(placeID: String) {
        self.placeID = placeID
    }
}