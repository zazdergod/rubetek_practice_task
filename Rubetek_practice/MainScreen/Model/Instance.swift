//
//  Door.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation


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
