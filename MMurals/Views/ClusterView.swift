//
//  ClusterView.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-01.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit

class ClusterView: MKMarkerAnnotationView {
    
// MARK: - Annotation Propertie
    
    override var annotation: MKAnnotation? {
        willSet {
            markerTintColor = .purple
        }
    }

}
