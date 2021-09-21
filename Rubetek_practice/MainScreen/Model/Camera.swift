//
//  Camera.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation

class Camera: Door {
    
    var rec: Bool
    
    init(name: String, snapshot: String?, room: String, id: Int, favorites: Bool, rec: Bool) {
        super.init(name: name, snapshot: snapshot, room: room, id: id, favorites: favorites)
        self.rec = rec
    }
    
}
