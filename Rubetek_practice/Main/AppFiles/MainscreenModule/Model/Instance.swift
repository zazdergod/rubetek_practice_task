//
//  Door.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation
import RealmSwift


class Instance: Object {
    
    @Persisted var name: String = ""
    @Persisted var snapshot: String? = nil
    @Persisted var id: Int = 0
    @Persisted var favorites: Bool = false
    @Persisted var room: String? = nil
    
    static let baseUrl: String = "https://cars.cprogroup.ru/api/rubetek"
    
    
    static func readInstancesFromCacher() -> [Instance] {
        var instList: [Instance] = []
        let realm = try! Realm()
        let data = realm.objects(self)
        for item in data {
            instList.append(item)
        }
        return instList
    }
    
    class func getMethod() -> String { "" }
    
    static func writeInstances(refresh: Bool, list: [Instance]) {
        let realm = try! Realm()
        if refresh {
            let data = realm.objects(self)
            do {
                try! realm.write { realm.delete(data) }
            }
        }
        for item in list {
            try! realm.write { realm.add(item) }
        }
    }
    
    static func readInstancesFromNetwork(completionHandler: @escaping (Result<[String: Any], Error>) -> Void) {
        NetworkService.makeRequest(baseUrl: baseUrl,
                                   method: getMethod(),
                                   hhtpMethod: NetworkService.HTTPMethod.GET.rawValue,
                                   headers: ["Content-Type": "application/json"],
                                   params: nil) { data, response, error in
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
            if (refresh || instListFromCacher.count == 0) {
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
    
    public func toggleFavorite() { }
    
    public func changeTheName(newName: String) { }
    
}
