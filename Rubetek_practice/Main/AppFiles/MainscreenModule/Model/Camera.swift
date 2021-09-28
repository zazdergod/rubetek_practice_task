//
//  Camera.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 27.09.2021.
//

import Foundation
import RealmSwift


class Camera: Instance {
    
    @Persisted var rec: Bool = false
    
  
    override class func getMethod() -> String {
        "/cameras/"
    }
    
    override class func mapToInstanceFromJson(data: [String : Any]) -> [Instance] {
        var cameraList: [Camera] = []
        if let jsonData = data["data"] as? [String: Any],
           let cameras = jsonData["cameras"] as? [[String: Any]] {
            for item in cameras {
                if let snapshot = item["snapshot"] as? String,
                    let favorites = item["favorites"] as? Bool,
                    let name = item["name"] as? String,
                    let id = item["id"] as? Int,
                    let rec = item["rec"] as? Bool {
                    let room = item["room"] as? String
                    let camera = Camera()
                    camera.snapshot = snapshot
                    camera.favorites = favorites
                    camera.name = name
                    camera.id = id
                    camera.rec = rec
                    camera.room = room
                    cameraList.append(camera)
                }
            }
        }
        return cameraList
    }
    
    override func toggleFavorite() {
        let realm = try! Realm()
        if let camera = realm.objects(Camera.self).filter("id == \(id)").first {
            try! realm.write {
                camera.favorites = !camera.favorites
            }
        }
    }
    
    override func changeTheName(newName: String) {
        let realm = try! Realm()
        if let camera = realm.objects(Camera.self).filter("id == \(id)").first {
            try! realm.write {
                camera.name = newName
            }
        }

    }
}
