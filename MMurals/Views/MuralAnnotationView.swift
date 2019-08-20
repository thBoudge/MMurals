//
//  MuralAnnotationView.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-01.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MuralAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation?{
        
        willSet{
             if let muralAnnotation = newValue as? MuralAnnotation {
            //add an emoji as pointform
                let image = UIImage(named: "muralPoint")
                let startImage = UIImage(named: "standing-up-man-")
                glyphTintColor = .purple
                markerTintColor = .white
                if muralAnnotation.id != 0 {
                glyphImage = image
                } else {
                glyphImage = startImage
                }
                //add a cluster
                clusteringIdentifier = "Mural"
            }
        
        }

    }
    

    

}


