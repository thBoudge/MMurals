//
//  MuralAnnotation.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-31.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class MuralAnnotation: NSObject, MKAnnotation {
    var id : Int
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var title: String?
    var imageUrl : String?

    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, id : Int) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = "http://ville.montreal.qc.ca/murales/detail/\(id)"
    }
    
    
    
    
}
