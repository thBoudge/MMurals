//
//  MuralAnnotationView.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-01.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit

class MuralAnnotationView: MKMarkerAnnotationView {

    // MARK: - Annotation Propertie
    
    override var annotation: MKAnnotation?{
        
        willSet{
             if let muralAnnotation = newValue as? MuralAnnotation {
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
    
    // MARK: - Methods
    
    /// Method that open a page from URL (MuralRealm.imageUrl)
    static func didSelectAnnotation(view: MKAnnotationView, pointArray: [MuralAnnotation]?){
        guard let muralCoordinate = view.annotation?.coordinate else {return}
        guard let muralsPoints = pointArray  else {return}
        
        for coordinatePoint in muralsPoints {
            if muralCoordinate.latitude == coordinatePoint.coordinate.latitude && muralCoordinate.longitude == coordinatePoint.coordinate.longitude && coordinatePoint.id != 0 {
                
                guard let urlString = coordinatePoint.imageUrl else {return}
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    

}


