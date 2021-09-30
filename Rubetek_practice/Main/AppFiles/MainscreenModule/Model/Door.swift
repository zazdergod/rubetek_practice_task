//
//  Door.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 27.09.2021.
//

import Foundation
import RealmSwift

class Door: WorkInstance {
    
    
    override class func getRequest() -> URLRequest? {
        return RubetekApiManager.makeRequest(method: .doors)
    }
    
    override class func mapToInstanceFromJson(data: [String : Any]) -> [Instance] {
        var doorList: [Door] = []
        if let doors = data["data"] as? [[String: Any]] {
            for item in doors {
                if let favorites = item["favorites"] as? Bool,
                   let name = item["name"] as? String,
                   let id = item["id"] as? Int {
                    let snapshot = item["snapshot"] as? String
                    let room = item["room"] as? String
                    let door = Door()
                    door.name = name
                    door.favorites = favorites
                    door.id = id
                    door.snapshot = snapshot
                    door.room = room
                    doorList.append(door)
                }
            }
        }
        return doorList
    }
    
    override func toggleFavorite() {
        let realm = try! Realm()
        if let door = realm.objects(Door.self).filter("id == \(id)").first {
            try! realm.write {
                door.favorites = !door.favorites
            }
        }
    }
    
    override func changeTheName(newName: String) {
        let realm = try! Realm()
        if let door = realm.objects(Door.self).filter("id == \(id)").first {
            try! realm.write {
                door.name = newName
            }
        }
    }
}
