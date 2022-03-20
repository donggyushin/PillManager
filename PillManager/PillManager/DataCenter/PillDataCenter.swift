//
//  PillDataCenter.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//
import FirebaseAuth
import Firebase

struct PillDataCenter {
    var savePill: (_ completion: ((Error?) -> Void)?) -> Void
    var fetchPillDate: (_ completion: ((Result<Date?, Error>) -> Void)?) -> Void
    var fetchPillDateLocal: () -> Date?
    private var savePillLocal: (_ date: Date) -> Void
}

extension PillDataCenter {
    static let live: PillDataCenter = .init { completion in
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        let date = Date()
        
        PillDataCenter.live.savePillLocal(date)
        
        db.collection("pills").document(uid).setData([
            "date": Timestamp(date: date)
        ], completion: completion)
    } fetchPillDate: { completion in
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(.failure(error))
            return
        }
        
        completion?(.success(PillDataCenter.live.fetchPillDateLocal()))

        db.collection("pills").document(uid).getDocument { document, error in
            if let error = error {
                completion?(.failure(error))
            } else {
                if let timestamp = document?.data()?["date"] as? Timestamp {
                    completion?(.success(timestamp.dateValue()))
                } else {
                    completion?(.success(nil))
                }
            }
        }
    } fetchPillDateLocal: {
        UserDefaults.standard.object(forKey: "pill") as? Date
    } savePillLocal: { date in
        UserDefaults.standard.set(date, forKey: "pill")
    }
}
