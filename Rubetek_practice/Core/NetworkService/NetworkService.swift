//
//  NetworkService.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation

class NetworkService {
    
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
    }
    
    
    
    static func makeRequest(request: URLRequest?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)  {
        guard let request = request else { return }
//        let urlString = baseUrl + method
//        guard let url = URL(string: urlString) else { return }
//        var request = URLRequest(url: url)
//        request.allHTTPHeaderFields = headers
//        request.httpMethod = hhtpMethod
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
