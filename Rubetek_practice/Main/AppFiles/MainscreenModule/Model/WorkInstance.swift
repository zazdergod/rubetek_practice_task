//
//  WorkInstance.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 29.09.2021.
//

import Foundation
import RealmSwift

class WorkInstance: Instance {
    
    @Persisted var name: String = ""
    @Persisted var snapshot: String? = nil
    @Persisted var favorites: Bool = false
    @Persisted var room: String? = nil
    
    
    
    public func toggleFavorite() {
        do {
            try! WorkInstance.cacher.write { [weak self] in
                guard let favorites = self?.favorites else { return }
                self?.favorites = !favorites
            }
        }
    }
    
    public func changeTheName(newName: String) {
        do {
            try! WorkInstance.cacher.write { [weak self] in
                self?.name = newName
            }
        }
    }
}
