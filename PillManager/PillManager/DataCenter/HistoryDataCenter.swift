//
//  HistoryDataCenter.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/23.
//

import Foundation
import Firebase
import FirebaseAuth

struct HistoryDataCenter {
    
    static let firestoreCollection = "histories"
    
    var saveDefaultHistory: (_ date: Date, _ completion: ((Error?) -> Void)?) -> Void
    var fetchDefaultHistory: (_ date: Date, _ completion: ((Bool) -> Void)?) -> Void
    var removeDefaultHistory: (_ date: Date, _ completion: ((Error?) -> Void)?) -> Void
    var saveCustomPillHistory: (_ date: Date, _ pill: CustomPill, _ completion: ((Error?) -> Void)?) -> Void
    var removeCustomPillHistory: (_ date: Date, _ pill: CustomPill, _ completion: ((Error?) -> Void)?) -> Void
    var fetchCustomPillHistory: (_ date: Date, _ pill: CustomPill, _ completion: ((Bool) -> Void)?) -> Void
}

extension HistoryDataCenter {
    static let live: HistoryDataCenter = .init { date, completion in
        
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(nil)
            return
        }
        
        let dateString = "\(date.get(.year))-\(date.get(.month))-\(date.get(.day))"
        
        db.collection(HistoryDataCenter.firestoreCollection)
            .document(uid)
            .collection("defaults")
            .document(dateString)
            .setData([
                "date": Timestamp(date: date)
            ], completion: completion)
    } fetchDefaultHistory: { date, completion in
        
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(false)
            return
        }
        
        let dateString = "\(date.get(.year))-\(date.get(.month))-\(date.get(.day))"
        
        db.collection(HistoryDataCenter.firestoreCollection)
            .document(uid)
            .collection("defaults")
            .document(dateString)
            .getDocument { document, error in
                if error != nil {completion?(false)}
                else {completion?(document?.data() != nil)}
            }
    } removeDefaultHistory: { date, completion in
        
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        let dateString = "\(date.get(.year))-\(date.get(.month))-\(date.get(.day))"
        
        db.collection(HistoryDataCenter.firestoreCollection)
            .document(uid)
            .collection("defaults")
            .document(dateString)
            .delete(completion: completion)
    } saveCustomPillHistory: { date, pill, completion in
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        let dateString = "\(date.get(.year))-\(date.get(.month))-\(date.get(.day))"
        
        db.collection(HistoryDataCenter.firestoreCollection)
            .document(uid)
            .collection("custom-pills")
            .document(pill.id)
            .collection("dates")
            .document(dateString)
            .setData([
                "date": Timestamp(date: date)
            ], completion: completion)
        
    } removeCustomPillHistory: { date, pill, completion in
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        let dateString = "\(date.get(.year))-\(date.get(.month))-\(date.get(.day))"
        
        db.collection(HistoryDataCenter.firestoreCollection)
            .document(uid)
            .collection("custom-pills")
            .document(pill.id)
            .collection("dates")
            .document(dateString)
            .delete(completion: completion)
    } fetchCustomPillHistory: { date, pill, completion in
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(false)
            return
        }
        
        let dateString = "\(date.get(.year))-\(date.get(.month))-\(date.get(.day))"
        
        db.collection(HistoryDataCenter.firestoreCollection)
            .document(uid)
            .collection("custom-pills")
            .document(pill.id)
            .collection("dates")
            .document(dateString)
            .getDocument { document, _ in
                completion?(document?.data() != nil)
            }
    }
}
