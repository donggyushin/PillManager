//
//  PillDataCenter.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//
import FirebaseAuth
import Firebase

final class PillDataCenter {

    static let `default` = PillDataCenter()

    private init() {}

    func savePill(completion: ((Error?) -> Void)? = nil) {

        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        let date = Date()
        savePillLocal(date: date)
        
        db.collection("pills").document(uid).setData([
            "date": Timestamp(date: date)
        ], completion: completion)
    }

    func fetchPillDate(completion: ((Result<Date?, Error>) -> Void)? = nil) {

        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(.failure(error))
            return
        }
        
        completion?(.success(fetchPillDateLocal()))

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
    }
    
    func fetchPillDateLocal() -> Date? {
        UserDefaults.standard.object(forKey: "pill") as? Date
    }
    
    private func savePillLocal(date: Date) {
        UserDefaults.standard.set(date, forKey: "pill")
    }
}
