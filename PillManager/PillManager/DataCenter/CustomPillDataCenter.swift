//
//  CustomPillDataCenter.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct CustomPillDataCenter {
    
    static let firestoreCollection = "custom-pills"
    
    var savePill: (_ pill: CustomPill, _ completion: ((Error?) -> Void)?) -> Void
    var fetchPills: (_ completion: ((Result<[CustomPill], Error>) -> Void)?) -> Void
    var deletePill: (_ pill: CustomPill, _ completion: ((Error?) -> Void)?) -> Void
    var fetchPillsFromUserDefaults: () -> [CustomPill]
    private var savePillsToUserDefaults: ([CustomPill]) -> Void
}

extension CustomPillDataCenter {
    static let live: CustomPillDataCenter = .init { pill, completion in
        
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        var data: [String: Any] = [
            "id": pill.id,
            "title": pill.title,
            "time": [
                "hour": pill.time.hour,
                "minute": pill.time.minute
            ]
        ]
        
        if let description = pill.description {
            data["description"] = description
        }
        
        db.collection(CustomPillDataCenter.firestoreCollection)
            .document(uid)
            .collection("list")
            .document(pill.id)
            .setData(data, completion: completion)
        
    } fetchPills: { completion in
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(.failure(error))
            return
        }
        
        db.collection(CustomPillDataCenter.firestoreCollection)
            .document(uid)
            .collection("list")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion?(.failure(error))
                } else {
                    let pills = querySnapshot?.documents.compactMap({ $0.data() }).map({CustomPill(data: $0)}) ?? []
                    CustomPillDataCenter.live.savePillsToUserDefaults(pills)
                    completion?(.success(pills))
                }
                
            }
        
    } deletePill: { pill, completion in
        
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        db.collection(CustomPillDataCenter.firestoreCollection)
            .document(uid)
            .collection("list")
            .document(pill.id)
            .delete(completion: completion)
    } fetchPillsFromUserDefaults: {
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "custom-pills-user-defaults-key") as? Data {
            let decoder = JSONDecoder()
            if let loadedPills = try? decoder.decode([CustomPill].self, from: savedData) {
                return loadedPills
            }
        }
        return []
    } savePillsToUserDefaults: { pills in
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(pills) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "custom-pills-user-defaults-key")
        }
    }
    
    static let test: CustomPillDataCenter = .init { pill, completion in
        completion?(nil)
    } fetchPills: { completion in
        
        var customPill1: CustomPill = .init(data: [:])
        customPill1.id = "1"
        customPill1.title = "Morning"
        customPill1.description = "Skin, LACTO-FIT"
        customPill1.time.minute = 30
        customPill1.time.hour = 8
        
        var customPill2: CustomPill = .init(data: [:])
        customPill2.id = "2"
        customPill2.title = "Lunch"
        customPill2.description = "LEMONA-Max"
        customPill2.time.minute = 30
        customPill2.time.hour = 13
        customPill2.isTakenToday = true 
        
        var customPill3: CustomPill = .init(data: [:])
        customPill3.id = "3"
        customPill3.title = "Evening"
        customPill3.description = "Skin, Hair"
        customPill3.time.minute = 00
        customPill3.time.hour = 22
        
        completion?(.success([customPill1, customPill2, customPill3]))
    } deletePill: { pill, completion in
        completion?(nil)
    } fetchPillsFromUserDefaults: {
        return []
    } savePillsToUserDefaults: { pills in
        print("do nothing")
    }
}
