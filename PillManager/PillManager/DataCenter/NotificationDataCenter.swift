//
//  NotificationDataCenter.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/22.
//
import FirebaseAuth
import Firebase

struct NotificationDataCenter {
    
    static let isNotificationDisabledKey = "isNotificationDisabledKey"
    static let firestoreCollection = "notifications"
    
    var fetchIsNotificationDisabled: (_ completion: ((Result<Bool, Error>) -> Void)?) -> Bool
    var setIsNotificationDisabled: (_ isNotificationDisabled: Bool, _ completion: ((Error?) -> Void)?) -> Void
    
    
}

extension NotificationDataCenter {
    static let live: NotificationDataCenter = .init { completion in
        
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(.failure(error))
            return UserDefaults.standard.bool(forKey: NotificationDataCenter.isNotificationDisabledKey)
        }
        
        db.collection(NotificationDataCenter.firestoreCollection).document(uid).getDocument { document, error in
            if let error = error {
                completion?(.failure(error))
            } else if let isNotificationDisabled = document?.data()["isNotificationDisabled"] as? Bool {
                completion?(.success(isNotificationDisabled))
            }
        }
        
        return UserDefaults.standard.bool(forKey: NotificationDataCenter.isNotificationDisabledKey)
    } setIsNotificationDisabled: { isNotificationDisabled, completion in
        
        guard let uid = Auth.auth().currentUser?.uid else {
            let error: MyError = .not_authorized
            completion?(error)
            return
        }
        
        db.collection(NotificationDataCenter.firestoreCollection).document(uid).setData([
            "isNotificationDisabled": isNotificationDisabled
        ], completion: completion)
        
        UserDefaults.standard.set(isNotificationDisabled, forKey: NotificationDataCenter.isNotificationDisabledKey)
    }

}
