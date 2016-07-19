//
//  Categories.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/18/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import Foundation
enum NewsCategory {
    case Entertainment
    case Tech
    case Sport
    case All
    case Travel
    case Style
    case Specials
    
    static func allValues() -> [NewsCategory] {
        return [.Entertainment, .Tech, .Sport, .All, .Travel, .Style, .Specials]
    }
}