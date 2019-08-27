//
//  AppDelegate.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-12.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK : PROPERTIES
    
    var window: UIWindow?
    private let muralsService = MuralsService()
    var authorisationDelegate : AlertSelectionDelegate?
    
    // MARK : AppDelegate Methods
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        if let date = UserDefaults.standard.object(forKey: "date") as? Date {
            let calendar = Date()
            let dateInterval = calendar.timeIntervalSince(date)
            if dateInterval >= 1814400.0  {
                UserDefaults.standard.removeObject(forKey: "date")
                UserDefaults.standard.set(Date(), forKey: "date")
                loadMurals()
            }
        }else{
            UserDefaults.standard.set(Date(), forKey: "date")
            loadMurals()
        }
        
        //Locate realm File
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "yep")
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    // MARK : Methods
    
    private func loadMurals(){
            self.muralsService.getMurals { (success, response) in
                if success, let data = response  {
                    MuralRealm.addMurals(mural: data)
                } else {
                    //alert in case of no success or empty data
                    self.authorisationDelegate?.alertOn(name: "Problem to dowLoad Data", description: "We could not dowload data, Please control that you are connected and start again MMurals")
                }
            }
    }
}

