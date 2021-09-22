//
//  Cacher.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation
import RealmSwift


class InstanceList: Object {
    var doorsList = List<RealmInstance>()
    var camerasList = List<RealmInstance>()
}

class Cacher {
    
    private var instaceList: InstanceList
    private let realm: Realm
    
    init() {
        instaceList = InstanceList()
        do {
           
            realm = try! Realm.init()
        }
    }
    

    
    
    public func read(isCamera: Bool) -> [Instance] {
        if let data = realm.objects(InstanceList.self).first {
            var instList: [Instance] = []
            if isCamera {
                for item in data.camerasList {
                    instList.append(Instance(name: item.name,
                                             snapshot: item.snapshot,
                                             room: item.room,
                                             id: item.id,
                                             favorites: item.favorites,
                                             rec: item.rec))
                }
            } else {
                for item in data.doorsList {
                    instList.append(Instance(name: item.name,
                                             snapshot: item.snapshot,
                                             room: item.room,
                                             id: item.id,
                                             favorites: item.favorites,
                                             rec: item.rec))
                }
            }
            return instList
        }
        return []
    }
    
    public func addList(list: [Instance], isCamera: Bool) {
        let realmList = List<RealmInstance>()
        let instList = realm.objects(InstanceList.self).first
        if instList == nil {
            try! realm.write {
                realm.add(InstanceList())
            }
        }
        for item in list {
            realmList.append(RealmInstance.createInstance(instance: item))
        }
        if isCamera {
            if let instList = realm.objects(InstanceList.self).first {
                
                    try! realm.write({
                        instList.camerasList = realmList
                    })
                
            }
        } else {
            if let instList = realm.objects(InstanceList.self).first {
                
                    try! realm.write({
                        instList.doorsList = realmList
                    })
                
                
            }
        }
    }
}

