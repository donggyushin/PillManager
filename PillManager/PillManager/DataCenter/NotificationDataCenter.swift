//
//  NotificationDataCenter.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/22.
//
import Foundation

struct NotificationDataCenter {
    var fetchIsNotificationDisabled: () -> Bool
    var setIsNotificationDisabled: (_ isNotificationDisabled: Bool) -> Void
    
    static let isNotificationDisabledKey = "isNotificationDisabledKey"
}

extension NotificationDataCenter {
    static let live: NotificationDataCenter = .init {
        UserDefaults.standard.bool(forKey: NotificationDataCenter.isNotificationDisabledKey)
    } setIsNotificationDisabled: { isNotificationDisabled in
        UserDefaults.standard.set(isNotificationDisabled, forKey: NotificationDataCenter.isNotificationDisabledKey)
    }

}
