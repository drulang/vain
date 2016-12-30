//
//  Location.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import Foundation
import CoreLocation

class Location : Model {
    var displayName:String {
        get {
            if let name = name {
                return name.capitalized
            } else {
                return "-"
            }
        }
    }
    var name:String?
    var coordinate:CLLocationCoordinate2D
    
    init(coordinate:CLLocationCoordinate2D, name:String?) {
        self.name = name
        self.coordinate = coordinate
    }
}
