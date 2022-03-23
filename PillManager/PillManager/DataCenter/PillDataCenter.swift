//
//  PillDataCenter.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//
import FirebaseAuth
import Firebase

struct PillDataCenter {
    
    static let pillIdentifier = "pill"
    static let firestoreCollection = "pills"
    
    var savePill: (_ completion: ((Error?) -> Void)?) -> Void
    var fetchPillDate: (_ completion: ((Result<Date?, Error>) -> Void)?) -> Void
    var fetchPillDateLocal: () -> Date?
    var deletePill: (_ completion: ((Error?) -> Void)?) -> Void
    
    private var savePillLocal: (_ date: Date?) -> Void
}

extension PillDataCenter {
    static let live: PillDataCenter = .init { completion in
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        let date = Date()
        db.collection(PillDataCenter.firestoreCollection).document(uid).setData([
            "date": Timestamp(date: date)
        ], completion: completion)
        
        HistoryDataCenter.live.saveDefaultHistory(Date(), nil)
        
    } fetchPillDate: { completion in
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(.failure(error))
            return
        }
        
        completion?(.success(PillDataCenter.live.fetchPillDateLocal()))
        db.collection(PillDataCenter.firestoreCollection).document(uid).getDocument { document, error in
            if let error = error {
                completion?(.failure(error))
            } else {
                if let timestamp = document?.data()?["date"] as? Timestamp {
                    let date = timestamp.dateValue()
                    PillDataCenter.live.savePillLocal(date)
                    completion?(.success(date))
                } else {
                    completion?(.success(nil))
                }
            }
        }
    } fetchPillDateLocal: {
        UserDefaults.standard.object(forKey: PillDataCenter.pillIdentifier) as? Date
    } deletePill: { completion in
        
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        db.collection(PillDataCenter.firestoreCollection).document(uid).delete { error in
            PillDataCenter.live.savePillLocal(nil)
            completion?(error)
        }
        
    } savePillLocal: { date in
        UserDefaults.standard.set(date, forKey: PillDataCenter.pillIdentifier)
    }
}
