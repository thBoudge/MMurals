//
//  MuralAnnotation.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-31.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import MapKit

class MuralAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var title: String?
    var imageUrl : String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, imageUrl: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
       self.imageUrl = imageUrl
    }
}
