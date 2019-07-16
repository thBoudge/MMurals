//
//  ViewController.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-12.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    private let muralsService = MuralsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        muralsService.getMurals { (success, rate) in
            if success, let data = rate   {
                print(data)
            } else {
                
            }
        }
    }


}

