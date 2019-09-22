//
//  MuralViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-09-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import MapKit
import RealmSwift

class MuralViewController: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var compassView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var compassDirectionButton: UIButton!
    
    // Mark: MuralVisit Information Oulets
    
    @IBOutlet weak var timeVisitLabel: UILabel!
    @IBOutlet weak var numberMuralLabel: UILabel!
    
    // MARK: Contraints OUTLETS
    
    @IBOutlet weak var compassMenuViewheightContraint: NSLayoutConstraint!
    @IBOutlet weak var typeMenuViewWidhContraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    let locationServ = LocationService.shared
    var regionRadius: CLLocationDistance = 3000.0
    var muralAnnotationList : [MuralAnnotation] = [] // create a list of MuralAnnotation
    let appDelegate = AppDelegate() // Alert Load data
    var menuIsClose = false  // inform if mainMenu is open or close
    var mapToAppear = 0 // inform which map specificity need to appear
    let distanceLocation = DistanceLocation()
    var drawingTimer: Timer?
//    var polyline = MKPolyline()
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationServ.delegate = self
        locationServ.authorisationDelegate = self
        appDelegate.authorisationDelegate = self
    }
    
    // MARK: - ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewAppearanceStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.addAnnotation()
            self.mapImplementation(mapCode: self.mapToAppear)
        }
    }
    
    
    // MARK: - ABAction
    
    @IBAction func openCloseMenu(_ sender: UIButton) {
        showOrHideMenu()
    }
    
    @IBAction func compassOneDirectionOpen(_ sender: UIButton) {
        openNewMapView(map: 0)
    }
    
    @IBAction func compassAllAroundOpen(_ sender: UIButton) {
        openNewMapView(map: 1)
    }
    
    @IBAction func fullMapOpen(_ sender: UIButton) {
        openNewMapView(map: 2)
    }
    
    @IBAction func changeMapType(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .satelliteFlyover
            guard let coordinate = LocationService.shared.currentLocation?.coordinate else {return}
            let camera = MKMapCamera(lookingAtCenter: coordinate , fromDistance: regionRadius, pitch: 40, heading: 0)
            mapView.camera = camera
        default: break
        }
        labelTextColorIs()
    }
    
    @IBAction func createMuralsVisitRouting(_ sender: UIButton) {
        if numberMuralLabel.text == "Murals: none"{
            alertOn(name: "Sorry, There are no Murals on this direction.", description:  "Please try again or look on the map where is the nearest Murals")
        } else{
        mapView.removeAnnotations(muralAnnotationList)
        muralAnnotationList = muralsVisitList()
        mapToAppear =  3
        mapImplementation(mapCode: mapToAppear)
        mapView.addAnnotations(muralAnnotationList)
        getDirections(sortedLocations: muralAnnotationList)
        menuIsClose = true
        showOrHideMenu()
        }
    }
    
    
    // MARK: - Methods
    
    // MARK: View Appearance Method
    
    /// Implement appearance of first page when ViewWillAppear
    private func viewAppearanceStart(){
        typeView.layer.cornerRadius = 25
        compassView.layer.cornerRadius = 25
        compassMenuViewheightContraint.constant =  0
        typeMenuViewWidhContraint.constant = 0
        timeVisitLabel.backgroundColor = #colorLiteral(red: 1, green: 0.7044478059, blue: 0.9662576318, alpha: 0.3725385274)
    }
    
    /// Create Annotation from [MuralAnnotation) and Add it to MapView
    private func addAnnotation(){
        muralAnnotationList = MuralAnnotation.getMuralAnnotationsList()
        mapView.addAnnotations(self.muralAnnotationList)
        mapView.register(MuralAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func openNewMapView(map: Int){
        if mapToAppear == 3 {
            mapView.removeAnnotations(muralAnnotationList)
            mapView.removeOverlays(mapView.overlays)
            muralAnnotationList.removeAll()
            mapToAppear = map
            self.viewWillAppear(true)
            menuIsClose = false
            showOrHideMenu()
        } else {
            mapToAppear = map
            mapImplementation(mapCode: mapToAppear)
        }
    }
    
}


