//
//  CompassViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-08-16.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit

class CompassViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var timeVisitLabel: UILabel!
    @IBOutlet weak var numberMuralLabel: UILabel!
    @IBOutlet weak var compassMapView: MKMapView!
    
    // MARK: - Properties
    
    let locationServ = LocationService.shared
    let regionRadius: CLLocationDistance = 3000.0
    var muralAnnotationList : [MuralAnnotation] = []
    let distanceLocation = DistanceLocation()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compassMapView.showsUserLocation = true
        locationServ.delegate = self
        locationServ.locationManager?.startUpdatingHeading()
        centerLocation()
        addMuralsAnnotation()
    }
    
    // MARK: - IBAction
    
    @IBAction func goToRouteDirection(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
    // MARK: prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoutingViewSegue" {
        let destinationVC = segue.destination as! RoutingViewController
        let points = muralsVisitList()
        destinationVC.pointArray = points
        }
        locationServ.locationManager?.stopUpdatingHeading()
     }
    
    // MARK: Methods
    
    /// Method that create CLCircularRegion on top half screen in order to return [MuralAnnotation] (all muralAnnotation that are n that region
    private func getMuralsToVisit() -> [MuralAnnotation]{
        let x = compassMapView.frame.width / 2.0
        let y = compassMapView.frame.height / 4.0
        let centerCGPoint = CGPoint(x: x, y: y)
        
        let centerCoordinate = compassMapView.convert(centerCGPoint, toCoordinateFrom: compassMapView)
        
        let selectedRegion = CLCircularRegion(center: centerCoordinate, radius: 1000, identifier: "selectedRegion")
        
        let muralsSelectedList = muralAnnotationList.filter { (mural) -> Bool in
           if selectedRegion.contains(mural.coordinate){
                return true
            }
            return false
        }
        return muralsSelectedList
    }
    
    /// Methods that will sort MuralAnnotion from [MuralAnnotation] by coordinate in order to create best way to visit Murals
    func muralsVisitList() ->[MuralAnnotation]{
       
        var points : [MuralAnnotation] = []
        guard let userPosition = locationServ.currentLocation?.coordinate else {return []}
        let startPoint = MuralAnnotation(coordinate: userPosition, title: "Start Point", subtitle: "", id: 0)
        points.append(startPoint)
        points += getMuralsToVisit()
        
        let sortedLocations = distanceLocation.locationsSortedByDistanceFromPreviousLocation(locations: points)
        return sortedLocations
    }
    
    /// Create a Region that will be show on MapView
    private func centerLocation(){
        // create a region
        guard let locationUser = locationServ.currentLocation?.coordinate else {return}
        let region = MKCoordinateRegion(center: locationUser, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            
        //we pass region to MapView
        compassMapView.setRegion(region, animated: true)
        
    }
    
    
    /// Create Annotation from [MuralAnnotation) and Add it to compassMapView
    private func addMuralsAnnotation(){
        muralAnnotationList = MuralAnnotation.getMuralAnnotationsList()
        compassMapView.addAnnotations(self.muralAnnotationList)
        compassMapView.register(MuralAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        compassMapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
}

// MARK: - LocationServiceDelegate Extension 

extension CompassViewController: LocationServiceDelegate {
    
    func onLocationHeadingUpdate(newHeading: CLHeading) {
        //  let angle = newHeading.trueHeading * .pi / 180
        // Animation to turn map when we turn devise
        UIView.animate(withDuration: 0.5) {
            self.compassMapView.camera.heading = newHeading.magneticHeading
        }
        addMuralsNumberAndTimeVisit()
    }
    
    func onLocationUpdate(location: CLLocation) {}
    
    func onLocationDidFailWithError(error: Error) {
        print("Error while trying to update device location : \(error)")
    }
    
    /// Call when MapView Orientation change , get figures, calculate and change label NumberMuralLabel and NtimeVisitLabel
    private func addMuralsNumberAndTimeVisit(){
        let pointsSorted = muralsVisitList()
        if pointsSorted.count > 1{
            let distance =  distanceLocation.calculateDistanceBetweenTwoMurals(murals: pointsSorted)
            let time =  Int(distance * 5000 / 3600)
            let timeHour =  time / 3600
            let timeMinutes =  time % 3600 / 60
            numberMuralLabel.text = "Murals: \(pointsSorted.count - 1)"
            timeVisitLabel.text = "Time: \(timeHour)h \(timeMinutes)min"
        }else{
            numberMuralLabel.text = "Murals: none"
            timeVisitLabel.text = ""
        }
    }
}


