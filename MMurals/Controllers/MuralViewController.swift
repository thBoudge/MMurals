//
//  MuralViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-09-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import MapKit

class MuralViewController: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var compassView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var compassDirectionButton: UIButton!
    
    //MARK: Contraints OUTLETS
    
    @IBOutlet weak var compassMenuViewheightContraint: NSLayoutConstraint!
    @IBOutlet weak var typeMenuViewWidhContraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    /// inform if mainMenu is open or close
    private var menuIsOpen = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewAppearanceStart()
    }
    
    //MARK: ABAction
    
    //Methode that animate open and close Menu
    @IBAction func openCloseMenu(_ sender: UIButton) {
        menuIsOpen = !menuIsOpen
        compassMenuViewheightContraint.constant = menuIsOpen ? 260 : 0
        typeMenuViewWidhContraint.constant = menuIsOpen ? 260 : 0
        animateOpenCloseMenuButton(menuIsOpen: menuIsOpen)
    }
    
    @IBAction func compassOneDirectionOpen(_ sender: UIButton) {
        animateFadeCompassDirectionButton(toImage: UIImage(named: "compassFinal")!)
    }
    
    @IBAction func compassAllAroundOpen(_ sender: UIButton) {
        animateFadeCompassDirectionButton(toImage: UIImage(named: "fromHereCompass")!)
    }
    
    @IBAction func fullMapOpen(_ sender: UIButton) {
        compassDirectionButton.alpha = 0
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
            let camera = MKMapCamera(lookingAtCenter: coordinate , fromDistance: 300, pitch: 40, heading: 0)
            mapView.camera = camera
        default: break
        }
    }
    //MARK: - Methods
    
    //MARK: View Appearance Method
    
    /// Implement appearance of first page when ViewWillAppear
    private func viewAppearanceStart(){
        typeView.layer.cornerRadius = 25
        compassView.layer.cornerRadius = 25
        compassDirectionButton.alpha = 1
        compassMenuViewheightContraint.constant =  0
        typeMenuViewWidhContraint.constant = 0
    }
    
    //MARK: Animation Methods
    
    /// methods that animate menuButton
    private func animateOpenCloseMenuButton(menuIsOpen: Bool) {
        UIView.animate(
            withDuration: 0.9,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 10,
            options: .allowUserInteraction,
            animations: {
                // Rotation of menuButton + to X
                let angle: CGFloat = self.menuIsOpen ? .pi / 4 : 0.0
                
                self.menuButton.transform = CGAffineTransform(rotationAngle: angle)
                self.view.layoutIfNeeded() // we update change
        },
            completion: nil
        )
    }
    
    /// methods that animate CompassMainButton
   private func animateFadeCompassDirectionButton(toImage: UIImage) {
        //Create & set up temp view
        let temporyView = UIImageView(frame: compassDirectionButton.frame)
        temporyView.image = toImage
        temporyView.alpha = 0.0
        temporyView.center.y += 20
        temporyView.bounds.size.width = compassDirectionButton.bounds.width * 1.3
        compassDirectionButton.superview?.insertSubview(temporyView, aboveSubview: compassDirectionButton)
        
        UIView.animate(
            withDuration: 0.5,
            animations: {
                //Fade temp view in
                temporyView.alpha = 1.0
                temporyView.center.y -= 20
                temporyView.bounds.size = self.compassDirectionButton.bounds.size
        },
            completion: { _ in
                //Update background view & view temp view
                self.compassDirectionButton.setImage(toImage, for: .normal)
                self.compassDirectionButton.alpha = 1
                temporyView.removeFromSuperview()
        }
        )
    }
    

}
