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
                    completion?(.success(querySnapshot?.documents.compactMap({ $0.data() }).map({CustomPill(data: $0)}) ?? []))
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
    }
    
    static let test: CustomPillDataCenter = .init { pill, completion in
        completion?(nil)
    } fetchPills: { completion in
        
        var customPill1: CustomPill = .init(data: [:])
        customPill1.id = "1"
        customPill1.title = "아침"
        customPill1.description = "피부, 락토핏"
        customPill1.time.minute = 30
        customPill1.time.hour = 8
        
        var customPill2: CustomPill = .init(data: [:])
        customPill2.id = "2"
        customPill2.title = "점심"
        customPill2.description = "비타민 C"
        customPill2.time.minute = 30
        customPill2.time.hour = 13
        
        var customPill3: CustomPill = .init(data: [:])
        customPill3.id = "3"
        customPill3.title = "저녁"
        customPill3.description = "피부, 머리"
        customPill3.time.minute = 00
        customPill3.time.hour = 22
        
        completion?(.success([customPill1, customPill2, customPill3]))
    } deletePill: { pill, completion in
        completion?(nil)
    }


}
