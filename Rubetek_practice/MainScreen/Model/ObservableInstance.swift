//
//  ObservableInstance.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation

class ObservableInstance {
    
    let name, room: String
    let snapshot: String?
    let id: Int
    var favorites: Bool
    
    init(name: String, snapshot: String?, room: String, id: Int, favorites: Bool, rec: Bool) {
        self.name = name
        self.snapshot = snapshot
        self.room = room
        self.id = id
        self.favorites = favorites
    }
}
