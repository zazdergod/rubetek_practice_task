//
//  Door.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation
import RealmSwift


class Instance: Object {
    
    @Persisted var id: Int = 0
    class func getRequest() -> URLRequest? { nil }
    
    static let cacher = try! Realm()
    
    static func readInstancesFromCacher() -> [Instance] {
        var instList: [Instance] = []
        let realm = try! Realm()
        let data = realm.objects(self)
        for item in data {
            instList.append(item)
        }
        return instList
    }
    
    
    static func writeInstances(refresh: Bool, list: [Instance]) {
        if refresh {
            let data = cacher.objects(self)
            do {
                try! cacher.write { cacher.delete(data) }
            }
        }
        for item in list {
            try! cacher.write { cacher.add(item) }
        }
    }
    
    static func readInstancesFromNetwork(completionHandler: @escaping (Result<[String: Any], Error>) -> Void) {
        NetworkService.makeRequest(request: getRequest()) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                completionHandler(.success(json))
            }
        }
    }
    
    class func mapToInstanceFromJson(data: [String: Any]) -> [Instance] {
        return []
    }
    
    static func readInstaces(refresh: Bool, completionHandler: @escaping ([Instance]) -> Void) {
        
        let instListFromCacher = readInstancesFromCacher()
        if (refresh || instListFromCacher.isEmpty) {
            readInstancesFromNetwork { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        let instList = mapToInstanceFromJson(data: data)
                        writeInstances(refresh: refresh, list: instList)
                        completionHandler(instList)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            
            completionHandler(instListFromCacher)
        }
        
    }
}


