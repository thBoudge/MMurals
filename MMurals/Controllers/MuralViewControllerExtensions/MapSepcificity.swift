//
//  MapSpecificity.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-09-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit


extension MuralViewController {
    
    
    /// map specificity depend on type of buttons
    /// 0: Map of compassOneDirection 1: Map of compassMuktipleDirection 2: Map of complete map 3: Map of visitMap
    func mapImplementation(mapCode: Int){
        
        switch mapCode {
        case 0:
            regionRadius = 3000.0
            centerLocation()
            locationServ.locationManager?.startUpdatingHeading()
            locationServ.locationManager?.startUpdatingLocation()
            animateFadeCompassDirectionButton(toImage: UIImage(named: "compassFinal")!)
            compassOneDirectionMapViewIsAllowed()
        case 1:
            regionRadius = 3000.0
            centerLocation()
            locationServ.locationManager?.stopUpdatingHeading()
            addMuralsNumberAndTimeVisit()
            animateFadeCompassDirectionButton(toImage: UIImage(named: "fromHereCompass")!)
            compassMultipleDirectionMapViewIsAllowed()
        case 2:
            locationServ.locationManager?.startUpdatingLocation()
            locationServ.locationManager?.stopUpdatingHeading()
            compassDirectionButton.alpha = 0
            regionRadius = 5000.0
            mapMapViewIsAllowed()
        case 3:
            regionRadius = 2000.0
            compassDirectionButton.alpha = 0
            centerLocation()
            visitMapViewIsAllowed()
        default:
            break
        }
    }
    
    
    /// mapView specification when we press mapButtom
    func mapMapViewIsAllowed(){
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true
        timeVisitLabel.isHidden = true
        numberMuralLabel.isHidden = true
    }
    
    
    /// mapView specification when we press OnedrectionButtom
    func compassOneDirectionMapViewIsAllowed(){
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.showsUserLocation = false
        mapView.isUserInteractionEnabled = false
        timeVisitLabel.isHidden = false
        numberMuralLabel.isHidden = false
        timeVisitLabel.backgroundColor = #colorLiteral(red: 1, green: 0.7044478059, blue: 0.9662576318, alpha: 0.37)
        numberMuralLabel.backgroundColor = #colorLiteral(red: 1, green: 0.7044478059, blue: 0.9662576318, alpha: 0.37)
    }
    
    /// mapView specification when we press OnedrectionButtom
    func compassMultipleDirectionMapViewIsAllowed(){
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.showsUserLocation = false
        mapView.isUserInteractionEnabled = false
        timeVisitLabel.isHidden = false
        numberMuralLabel.isHidden = false
        timeVisitLabel.backgroundColor = #colorLiteral(red: 1, green: 0.7044478059, blue: 0.9662576318, alpha: 0.37)
        numberMuralLabel.backgroundColor = #colorLiteral(red: 1, green: 0.7044478059, blue: 0.9662576318, alpha: 0.37)
    }
    
    /// mapView specification when we press OnedrectionButtom
    func visitMapViewIsAllowed(){
        mapView.removeAnnotations(muralAnnotationList)
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true
        timeVisitLabel.isHidden = false
        numberMuralLabel.isHidden = false
        timeVisitLabel.backgroundColor = #colorLiteral(red: 1, green: 0.7044478059, blue: 0.9662576318, alpha: 0.37)
        numberMuralLabel.backgroundColor = #colorLiteral(red: 1, green: 0.7044478059, blue: 0.9662576318, alpha: 0.37)
    }
    
    
    /// Create a Region that will be show on MapView
    func centerLocation(){
        // create a region
        guard let locationUser = locationServ.currentLocation?.coordinate else {return}
        let region = MKCoordinateRegion(center: locationUser, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        //we pass region to MapView
        mapView.setRegion(region, animated: true)
        
    }
    
    /// change labelText Color depend on type of mapView
    func labelTextColorIs (){
        if mapView.mapType == .standard {
            timeVisitLabel.textColor = #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)
            numberMuralLabel.textColor = #colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)
        }else{
            timeVisitLabel.textColor = #colorLiteral(red: 0.0145530412, green: 0.1988869011, blue: 0.9993705153, alpha: 1)
            numberMuralLabel.textColor = #colorLiteral(red: 0.0145530412, green: 0.1988869011, blue: 0.9993705153, alpha: 1)
        }
        
    }
}
