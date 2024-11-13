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
    
    init(mockData: Data? = nil, mockResponse: URLResponse? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockResponse = mockResponse
        self.mockError = mockError
        
        let configuration = URLSessionConfiguration.ephemeral
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(mockData, mockResponse, mockError)
        return URLSessionDataTask()
    }
}

