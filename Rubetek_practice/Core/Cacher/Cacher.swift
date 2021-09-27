////
////  Cacher.swift
////  Rubetek_practice
////
////  Created by Ilya Buzyrev on 21.09.2021.
////
//
//import Foundation
//import RealmSwift
//
//
//
//class Cacher {
//    
//    
//    private let realm: Realm
//    
//    init() {
//        realm = try! Realm.init()
//    }
//    
//    
//    public func read(isCamera: Bool) -> [Instance] {
//        let data = realm.objects(RealmInstance.self).filter("isCamera == \(isCamera ? 1 : 0)")
//        if data.count != 0 {
//            var instlist: [Instance] = []
//            for item in data {
//                let instance = Instance(name: item.name,
//                                        snapshot: item.snapshot,
//                                        room: item.room,
//                                        id: item.id,
//                                        favorites: item.favorites,
//                                        rec: item.rec)
//                instlist.append(instance)
//            }
//            return instlist
//        }
//        return []
//    }
//    
//    public func addList(refresh: Bool, list: [Instance], isCamera: Bool) {
//        if refresh {
//            let data = realm.objects(RealmInstance.self).filter("isCamera == \(isCamera ? 1 : 0)")
//            do {
//                try! realm.write {
//                    realm.delete(data)
//                }
//            }
//        }
//        for item in list {
//            let realmInstance = RealmInstance.createInstance(instance: item, isCamera: isCamera)
//            do {
//                try! realm.write {
//                    realm.add(realmInstance)
//                }
//    
//            }
//        }
//    }
//}
//
