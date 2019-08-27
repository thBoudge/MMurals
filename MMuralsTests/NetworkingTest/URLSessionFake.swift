//
//  URLSessionFake.swift
//  TripToolsTests
//
//  Created by Thomas Bouges on 2019-04-13.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import Foundation

// MARK: - URLSessionFake

class URLSessionFake: URLSession {
    
    // MARK: - Properties

    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    // MARK: - Init()

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    // MARK: - Override URLSession

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
}


// MARK: - URLSessionDataTaskFake


class URLSessionDataTaskFake: URLSessionDataTask {
    
    // MARK: - Properties

    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    // MARK: - Override URLSessionDataTask

    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    
    override func cancel() {}
}
