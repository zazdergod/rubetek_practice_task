//
//  Door.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation
import RealmSwift


class Instance {
    
    let name: String
    let room, snapshot: String?
    let id: Int
    var favorites: Bool
    var rec: Bool?
    
    init(name: String, snapshot: String?, room: String?, id: Int, favorites: Bool, rec: Bool?) {
        self.name = name
        self.snapshot = snapshot
        self.room = room
        self.id = id
        self.favorites = favorites
        self.rec = rec
    }
}

class RealmInstance: Object {
    
    @Persisted var name: String = ""
    @Persisted var room: String? = nil
    @Persisted var snapshot: String? = nil
    @Persisted var id: Int = 0
    @Persisted var favorites: Bool = false
    @Persisted var rec: Bool = false
    @Persisted var isCamera: Bool = true
    
    static func createInstance(instance: Instance, isCamera: Bool) -> RealmInstance {
        let realmInstance = RealmInstance()
        realmInstance.name = instance.name
        realmInstance.snapshot = instance.snapshot
        realmInstance.room = instance.room
        realmInstance.id = instance.id
        realmInstance.favorites = instance.favorites
        if let rec = instance.rec {
            realmInstance.rec = rec
        }
        realmInstance.isCamera = isCamera
        return realmInstance
    }
}
