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
    
    @objc var name: String = ""
    @objc var room: String? = nil
    @objc var snapshot: String? = nil
    @objc var id: Int = 0
    @objc var favorites: Bool = false
    @objc var rec: Bool = false
    
    static func createInstance(instance: Instance) -> RealmInstance {
        let realmInstance = RealmInstance()
        realmInstance.name = instance.name
        realmInstance.snapshot = instance.snapshot
        realmInstance.room = instance.room
        realmInstance.id = instance.id
        realmInstance.favorites = instance.favorites
        if let rec = instance.rec {
            realmInstance.rec = rec
        }
        return realmInstance
    }
}
