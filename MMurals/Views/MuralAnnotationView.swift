//
//  MuralAnnotationView.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-01.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import MapKit

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
//
                //                //We inform AnnotationVuew that we want to display additional information (imageMural)
                //                //******************* droit auteur plutot faire apparaitre page du site web ********\\
                //                canShowCallout = true
//                // add an image as additional information
//                guard let imageUrl = muralAnnotation.imageUrl else {return }
//                guard let url = URL(string: imageUrl) else {return}
//                guard let data = try? Data(contentsOf: url) else {return }
//                if data.count == 0 {
//                    let image = UIImage(named: "no-graffiti" )
//                    let imageView = UIImageView(image: image)
//                    detailCalloutAccessoryView = imageView
//                }else {
//                    let image  = UIImage(data: data)
//                    let imageView = UIImageView(image: image)
//                    detailCalloutAccessoryView = imageView
//                }
                
            }
        
        }

    }
    
    
}


