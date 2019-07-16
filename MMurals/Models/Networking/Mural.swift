//
//  Mural.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-16.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation

// MARK: - Mural
struct Mural: Codable {
    let type, name: String?
    let crs: CRS?
    let features: [Feature]?
}

// MARK: - CRS
struct CRS: Codable {
    let type: String?
    let properties: CRSProperties?
}

// MARK: - CRSProperties
struct CRSProperties: Codable {
    let name: String?
}

// MARK: - Feature
struct Feature: Codable {
    let type: FeatureType?
    let properties: FeatureProperties?
    let geometry: Geometry?
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: GeometryType?
    let coordinates: [Double]?
}

enum GeometryType: String, Codable {
    case point = "Point"
}

// MARK: - FeatureProperties
struct FeatureProperties: Codable {
    let id: Int?
    let vignette: String? // have add type String as this calue is never used on Json file
    let fichier: String?
    let artiste, organisation: String?
    let adresse: String?
    let annee: Int?
    let programmeEntente: String?
    let latitude, longitude: Double?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id, vignette, fichier, artiste, organisation, adresse, annee
        case programmeEntente
        case latitude, longitude, image
    }
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}
