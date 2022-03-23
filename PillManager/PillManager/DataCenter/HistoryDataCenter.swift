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
    
    var saveDefaultTodayHistory: (_ completion: ((Error?) -> Void)?) -> Void
}

extension HistoryDataCenter {
    static let live: HistoryDataCenter = .init { completion in
        
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(nil)
            return
        }
        
        let now = Date()
        
        db.collection(HistoryDataCenter.firestoreCollection)
            .document(uid)
            .collection("defaults")
            .document("\(now.get(.year))-\(now.get(.month))-\(now.get(.year))")
            .setData([
                "date": Timestamp(date: now)
            ], completion: completion)
    }
}
