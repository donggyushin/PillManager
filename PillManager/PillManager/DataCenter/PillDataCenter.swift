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
    
    func addPill(completion: ((Error?) -> Void)? = nil) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        db.collection("pills").document(uid).setData([
            "date": Timestamp(date: Date())
        ], completion: completion)
    }
    
    func getPillDate(completion: ((Result<Date?, Error>) -> Void)? = nil) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(.failure(error))
            return
        }
        
        db.collection("pills").document(uid).getDocument { document, error in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(document?.data()?["date"] as? Date))
            }
        }
    }
}
