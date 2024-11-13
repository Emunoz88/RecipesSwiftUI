//
//  MockURLSession.swift
//  RecepiesSwiftUI
//
//  Created by Munoz, Edgar on 11/12/24.
//
import Foundation
import Combine

class MockURLSession: URLSession {
    
    var mockData: Data?
    var mockError: Error?
    var mockResponse: URLResponse?
    
    // Custom initializer that sets up the mock data, response, and error
    init(mockData: Data? = nil, mockResponse: URLResponse? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockResponse = mockResponse
        self.mockError = mockError
        
        // Initialize URLSession with a configuration
        let configuration = URLSessionConfiguration.ephemeral
        //super.init(configuration: configuration)
    }

    // Override dataTask(with:) to simulate the network request
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        // Simulate a network call by calling the completion handler with mock data/error
        completionHandler(mockData, mockResponse, mockError)
        return URLSessionDataTask()
    }
}

