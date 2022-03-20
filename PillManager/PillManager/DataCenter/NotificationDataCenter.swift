//
//  NotificationDataCenter.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import Foundation

struct NotificationDataCenter {
    var saveNotificationIdentifier: (_ notificationId: String) -> Void
    var fetchNotificationIdentifier: () -> String?
    
    static let notificationIdentifier = "notificationIdentifier"
}

extension NotificationDataCenter {
    static let live: NotificationDataCenter = .init { notificationId in
        UserDefaults.standard.set(notificationId, forKey: NotificationDataCenter.notificationIdentifier)
    } fetchNotificationIdentifier: {
        UserDefaults.standard.string(forKey: NotificationDataCenter.notificationIdentifier)
    }
}
