//
//  MuralRealm.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation
import RealmSwift
//import MapKit

class MuralRealm: Object {
    
    //MARK: - Persisted Properties
    @objc dynamic var id : Int = 0
    @objc dynamic var artist : String = ""
    @objc dynamic var address : String = ""
    @objc dynamic var year : Int = 0
    @objc dynamic var image : String = ""
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
    
    

    static func addMurals(mural: Mural, realm : Realm = try! Realm()){

        guard let muralsData = mural.features else {return}
    
        for muralData in muralsData {
            let muralToAdd = MuralRealm()
            
            guard let id = muralData.properties?.id else {return}
            guard let artist  = muralData.properties?.artiste else {return}
            guard let address = muralData.properties?.adresse else {return}
            guard let year = muralData.properties?.annee else {return}
            guard let image = muralData.properties?.image else {return}
            guard let latitude = muralData.properties?.latitude else {return}
            guard let longitude = muralData.properties?.longitude else {return}
            
            muralToAdd.id = id
            muralToAdd.artist = artist
            muralToAdd.address = address
            muralToAdd.year = year
            muralToAdd.image = image
            muralToAdd.latitude = latitude
            muralToAdd.longitude = longitude
            
            
            
            try! realm.write {
                realm.add(muralToAdd)
               
            }
        }
    }
    
    
    
}



