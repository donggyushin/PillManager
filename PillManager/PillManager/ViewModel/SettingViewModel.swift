//
//  SettingViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/22.
//

import Combine

class SettingViewModel {
    
    @Published var isNotificationDisabled: Bool
    @Published var error: Error?
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let notificationDataCenter: NotificationDataCenter
    private let pillViewModel: PillViewModel
    
    init(notificationDataCenter: NotificationDataCenter, pillViewModel: PillViewModel) {
        self.notificationDataCenter = notificationDataCenter
        self.pillViewModel = pillViewModel
        isNotificationDisabled = notificationDataCenter.fetchIsNotificationDisabled(nil)
        _ = notificationDataCenter.fetchIsNotificationDisabled({ [weak self] result in
            switch result {
            case .failure(let error):
                self?.error = error
            case .success(let isNotificationDisabled):
                self?.isNotificationDisabled = isNotificationDisabled
            }
        })
    }
    
    func switchTapped() {
        notificationDataCenter.setIsNotificationDisabled(!isNotificationDisabled, { [weak self] error in
            self?.error = error
        })
        isNotificationDisabled = notificationDataCenter.fetchIsNotificationDisabled({ [weak self] result in
            switch result {
            case .success(let isNotificationDisabled):
                self?.isNotificationDisabled = isNotificationDisabled
            case .failure(let error):
                self?.error = error
            }
        })
        pillViewModel.requestSendNotification()
    }
}
