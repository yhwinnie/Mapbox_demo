//
//  UserSelection.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/15/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import Foundation

enum Selection {
    case Restaurants
    case Places

}

class UserSelection {
    static var address: String = ""
    static var selection: Selection = .Restaurants
}
