//
//  MuralAnnotation.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-31.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit
import RealmSwift

class MuralAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    var id : Int
    var coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var title: String?
    var imageUrl : String?

    // MARK: - Init
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, id : Int) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = "http://ville.montreal.qc.ca/murales/detail/\(id)"
    }
    
    // MARK: - Methods
    
    /// Method that collect data from RealmDataBase and return [MuralAnnotation]
    static func getMuralAnnotationsList() -> [MuralAnnotation] {
        var muralAnnotationList : [MuralAnnotation] = []
        let muralsList = MuralPersistentData.all()
        
        for mural in muralsList {
            let locatePoint = CLLocation(latitude: mural.latitude, longitude: mural.longitude)
            let newMural = MuralAnnotation(coordinate: locatePoint.coordinate, title: mural.artist, subtitle: String(mural.year), id: mural.id)
            muralAnnotationList.append(newMural)
        }
        return muralAnnotationList
    }
}
