//
//  MuralsService.swift
//  MMurals
//
//  Created by Thomas Bouges on 2019-07-12.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation

class MuralsService {
    //MARK: Properties
    private let muralURL = URL(string: valueForAPI(named: "MuralAPI"))!
    
    private var task : URLSessionDataTask?
    
    private var muralSession : URLSession
    
    //Mark: Init()
    init(muralSession: URLSession = URLSession(configuration: .default)) {
        self.muralSession = muralSession
    }
    
    //MARK: Methods
    //Methods That called and return response
    func getMurals(callback: @escaping (Bool, Mural?) -> Void) {
        
        let request = URLRequest(url: muralURL)
        
        print(request)
        
        task?.cancel()
        
        task = muralSession.dataTask(with: request){ (data, response, error) in
            DispatchQueue.main.async {
                //Check if data != nil and error is = nil
                guard let data = data, error == nil else {
                    callback(false, nil)
                    
                    return
                }
                // control that response is a  HTTPURLResponse and that status is 200
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    
                    return
                }
                
                // MARK: - 5 Translation JSON in String
                if let responseJSON = try? JSONDecoder().decode(Mural.self, from: data){
                    print(responseJSON)
//                    let value = responseJSON.rates[self.symbols]
                    let value = responseJSON 
                    callback(true,value)
//                    print(value!)
                }
            }
        }
        
        task?.resume()
        
    }
}
