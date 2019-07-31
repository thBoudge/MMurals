//
//  ViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-12.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    
    private let muralsService = MuralsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadMurals()
    }
    
    private func loadMurals(){
        
        muralsService.getMurals { (success, response) in
            if success, let data = response  {
//                print(data)
                //////////////// tempory need to be done depending data update date \\\\\\\\\\\\\\\\\\\\\\\\
                let realm = try! Realm()
                let numberOfPersistentData = realm.objects(MuralRealm.self).count
                guard let numberOfAPIData = data.features?.count else {return}
                try! realm.write {
                    realm.deleteAll()
                }
                if numberOfAPIData > numberOfPersistentData {
                    // Delete all objects from the realm
                    try! realm.write {
                        realm.deleteAll()
                    }
                    MuralRealm.addMurals(mural: data)
                }
//                MuralRealm.addMurals(mural: data)
                /////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
            } else {
                
            }
        }
    }


}

