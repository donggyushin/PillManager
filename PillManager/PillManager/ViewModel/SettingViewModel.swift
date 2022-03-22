//
//  SettingViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/22.
//

import Combine

class SettingViewModel {
    
    @Published var isNotificationDisabled: Bool
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let notificationDataCenter: NotificationDataCenter
    
    init(notificationDataCenter: NotificationDataCenter) {
        self.notificationDataCenter = notificationDataCenter
        isNotificationDisabled = notificationDataCenter.fetchIsNotificationDisabled()
    }
    
    func switchTapped() {
        notificationDataCenter.setIsNotificationDisabled(!isNotificationDisabled)
        isNotificationDisabled = notificationDataCenter.fetchIsNotificationDisabled()
    }
}