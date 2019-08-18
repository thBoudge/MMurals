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

    var window: UIWindow?
    private let muralsService = MuralsService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let date = UserDefaults.standard.object(forKey: "date") as? Date {
            let calendar = Date()
            //                Calendar.current 79563.63482797146
            //file:///var/mobile/Containers/Data/Application/2844032A-D042-4022-9855-D28C5917AF3E/Documents/default.realm
            let dateInterval = calendar.timeIntervalSince(date) 
//            print(date)
//            print(calendar)
//            print(dateInterval)
            if dateInterval >= 1814400.0  {
                UserDefaults.standard.removeObject(forKey: "date")
                UserDefaults.standard.set(Date(), forKey: "date")
                loadMurals()
            }

        }else{
//            print("no userdefaults")
//            print(Date())
            UserDefaults.standard.set(Date(), forKey: "date")
            DispatchQueue.main.async {
                self.loadMurals()
            }
            
            
            
        }
        

        
        //MARK: - Locate realm File
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "yep")
        
        
        
        return true
    }
    
    private func loadMurals(){
        
        muralsService.getMurals { (success, response) in
            if success, let data = response  {
                //                print(data)
                //////////////// tempory need to be done depending data update date \\\\\\\\\\\\\\\\\\\\\\\\
//                let realm = try! Realm()
                MuralRealm.addMurals(mural: data)
//                let numberOfPersistentData = realm.objects(MuralRealm.self).count
//
//                guard let numberOfAPIData = data.features?.count else {return}
//
//
//                if numberOfAPIData > numberOfPersistentData {
//                    // Delete all objects from the realm
//                    try! realm.write {
//                        realm.deleteAll()
//                    }
//                    MuralRealm.addMurals(mural: data)
//
//                }
                //                MuralRealm.addMurals(mural: data)
                /////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
            } else {
                
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

