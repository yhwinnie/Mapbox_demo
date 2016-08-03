//
//  DataService.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/22/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DataService {
    static let dataService = DataService()
    var ref = FIRDatabase.database().reference()
    
    func savePlaceToFirebase(placeID: String, place: Place) {
        ref.child("requests/\(placeID)/placeID").setValue(placeID)
        ref.child("places/\(placeID)/name").setValue(place.restaurantName)
        ref.child("places/\(placeID)/address").setValue(place.address)
        ref.child("places/\(placeID)/rating").setValue(place.rating)
        ref.child("places/\(placeID)/price").setValue(place.price)
        ref.child("places/\(placeID)/hours").setValue(place.hours)
        ref.child("places/\(placeID)/suggestions").setValue(place.suggestions)
        ref.child("places/\(placeID)/distance").setValue(place.distance)
        ref.child("places/\(placeID)/image").setValue(place.image)
    }
    
    func setAnswer(placeID: String, facebookID: String, response: String) {
        self.ref.child("answers/\(placeID)/\(facebookID)").setValue(response)
        
    }
    
    
    func saveInformationToFirebase(userId: String, uuid: String, friendRequestId: String, friendId: String, userName: String, friendName: String, array: [String: String], date: String) {
        // Save requests to users
        let requestsTo = self.ref.child("users/\(userId)/requests/\(uuid)").setValue(true)
        self.ref.child("users/\(userId)/name").setValue(userName)
        let from_request = self.ref.child("users/\(friendId)/requests/\(friendRequestId)").setValue(true)
        self.ref.child("users/\(friendId)/name").setValue(friendName)
        
        // Save answers
        let answer = self.ref.child("answers/\(uuid)/\(friendId)").setValue("Pending")
        
        // Save requests
        self.ref.child("requests/\(friendRequestId)/to").setValue(array)
        self.ref.child("requests/\(uuid)/from").setValue([userId: userName])
        self.ref.child("requests/\(uuid)/date").setValue(date)

    }
    
}







