//
//  RubetekApiManager.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 29.09.2021.
//

import Foundation

class RubetekApiManager {
    
    enum RubetekMethod {
        case doors
        case cameras
    }
    
    class func getBaseUrl(method: RubetekMethod) -> String {
        switch method {
        case .doors, .cameras:
            return "https://cars.cprogroup.ru/api/rubetek"
        }
    }
    
    class func getHTTPMethod(method: RubetekMethod) -> String {
        switch method {
        case .doors, .cameras:
            return "GET"
        }
    }
    
    class func getRubetekMethod(method: RubetekMethod) -> String {
        switch method {
        case .doors:
            return "/doors/"
        case .cameras:
            return "/cameras/"
        }
    }
    
    static func makeRequest(method: RubetekMethod) -> URLRequest? {
        let urlString = getBaseUrl(method: method) + getRubetekMethod(method: method)
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = getHTTPMethod(method: method)
        return request
    }
}
