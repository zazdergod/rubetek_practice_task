//
//  Door.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation
import RealmSwift


//class Instance {
//
//    let name: String
//    let room, snapshot: String?
//    let id: Int
//    var favorites: Bool
//    var rec: Bool?
//
//    init(name: String, snapshot: String?, room: String?, id: Int, favorites: Bool, rec: Bool?) {
//        self.name = name
//        self.snapshot = snapshot
//        self.room = room
//        self.id = id
//        self.favorites = favorites
//        self.rec = rec
//    }
//}
//
//class RealmInstance: Object {
//
//    @Persisted var name: String = ""
//    @Persisted var room: String? = nil
//    @Persisted var snapshot: String? = nil
//    @Persisted var id: Int = 0
//    @Persisted var favorites: Bool = false
//    @Persisted var rec: Bool = false
//    @Persisted var isCamera: Bool = true
//
//    static func createInstance(instance: Instance, isCamera: Bool) -> RealmInstance {
//        let realmInstance = RealmInstance()
//        realmInstance.name = instance.name
//        realmInstance.snapshot = instance.snapshot
//        realmInstance.room = instance.room
//        realmInstance.id = instance.id
//        realmInstance.favorites = instance.favorites
//        if let rec = instance.rec {
//            realmInstance.rec = rec
//        }
//        realmInstance.isCamera = isCamera
//        return realmInstance
//    }
//}

class Instance: Object {
    
    @Persisted var name: String = ""
    @Persisted var snapshot: String? = nil
    @Persisted var id: Int = 0
    @Persisted var favorites: Bool = false
    @Persisted var room: String? = nil
    
    static let baseUrl: String = "https://cars.cprogroup.ru/api/rubetek"
    
    
    static func readInstancesFromCacher() -> [Instance] {
        let realm = try! Realm()
        let data = realm.objects(self)
        if data.count != 0 {
            return data.objects(at: IndexSet([0, data.count - 1]))
        } else {
            return []
        }
        
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
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
               let jsonData = json["data"] as? [String: Any] {
                completionHandler(.success(jsonData))
            }
        }
    }
    
    class func mapToInstanceFromJson(data: [String: Any]) -> [Instance] {
        return []
    }
    
    static func readInstaces(refresh: Bool, completionHandler: @escaping ([Instance]) -> Void) {
        DispatchQueue.main.async {
            let instListFromCacher = readInstancesFromCacher()
            if (refresh || instListFromCacher.count == 0) {
                readInstancesFromNetwork { result in
                    switch result {
                    case .success(let data):
                        let instList = mapToInstanceFromJson(data: data)
                        writeInstances(refresh: refresh, list: instList)
                        completionHandler(instList)
                        
                        
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                
                completionHandler(instListFromCacher)
            }
        }
    }
    
    public func toggleFavorite() { }
    
}
