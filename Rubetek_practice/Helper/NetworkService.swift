//
//  NetworkService.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 21.09.2021.
//

import Foundation

class NetworkService {
    
    let baseUrl = "https://cars.cprogroup.ru/api/rubetek"
    
    private func convertArray(oldArray: [[String: Any]]) -> [Instance] {
        var array = [Instance]()
        for item in oldArray {
            if let favorites = item["favorites"] as? Bool,
               let name = item["name"] as? String,
               let id = item["id"] as? Int {
                let snapshot = item["snapshot"] as? String
                let room = item["room"] as? String
                let rec = item["rec"] as? Bool
                let newItem = Instance(name: name, snapshot: snapshot, room: room, id: id, favorites: favorites, rec: rec)
                array.append(newItem)
            }
        }
        
        return array
    }
    
//    private func convertCamerasArray(cameras: [[String: Any]], rooms: [String]) -> RequestCameraResult {
//
//        var roomsArray = [String: [Instance]]()
//        var camerasArray = [Instance]()
//        for item in cameras {
//            if let snapshot = item["snapshot"] as? String,
//               let favorites = item["favorites"] as? Bool,
//               let name = item["name"] as? String,
//               let id = item["id"] as? Int,
//               let rec = item["rec"] as? Bool {
//                let room = item["room"] as? String
//                let camera = Instance(name: name, snapshot: snapshot, room: room, id: id, favorites: favorites, rec: rec)
//                camerasArray.append(camera)
//            }
//        }
//        for room in rooms {
//            let cameras = camerasArray.filter {
//                $0.room == room
//            }
//            if cameras.count != 0 {
//                roomsArray[room] = cameras
//            }
//        }
//        return roomsArray
//    }
    
    
    public func requestCameras(completion: @escaping (_ cameras: [Instance]?, _ rooms: [String]?, _ error: Error?) -> Void) {
        let urlString = baseUrl + "/cameras/"
        guard let url = URL(string: urlString) else { return }
        let header: [String: String] = ["Content-Type": "application/json"]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, nil, error)
            } else if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                   let jsonData = json["data"] as? [String: Any],
                   let rooms = jsonData["room"] as? [String],
                   let cameras = jsonData["cameras"] as? [[String: Any]] {
                    let convertedCameras = self.convertArray(oldArray: cameras)
                    completion(convertedCameras, rooms, nil)
                    
                }
            }
            
        }.resume()
    }
    
    
    public func requestDoors(completion: @escaping (_ doors: [Instance]?, _ error: Error?) -> Void) {
        let urlString = baseUrl + "/doors/"
        guard let url = URL(string: urlString) else { return }
        let header: [String: String] = ["Content-Type": "application/json"]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                   let jsonData = json["data"] as? [[String: Any]] {
                    let convertedRooms = self.convertArray(oldArray: jsonData)
                    completion(convertedRooms, nil)
                }
            }
            
        }.resume()
    }
}
