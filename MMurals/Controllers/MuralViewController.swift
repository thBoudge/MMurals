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
    var menuIsOpen = false  // inform if mainMenu is open or close
    var mapToAppear = 0 // inform which map specificity need to appear
    let distanceLocation = DistanceLocation()
    
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
        mapToAppear =  0
        mapImplementation(mapCode: mapToAppear)
    }
    
    @IBAction func compassAllAroundOpen(_ sender: UIButton) {
        mapToAppear =  1
        mapImplementation(mapCode: mapToAppear)
    }
    
    @IBAction func fullMapOpen(_ sender: UIButton) {
        mapToAppear =  2
        mapImplementation(mapCode: mapToAppear)
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
    
}


