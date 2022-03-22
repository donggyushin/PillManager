//
//  PillViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import Foundation
import Combine
import UserNotifications

class PillViewModel {
    
    enum Status: String {
        case have = "I already have pills"
        case not_yet = "I just have pills"
        case loading = "Waiting..."
    }
    
    private static let pillNotificationIdentifier = "pillNotificationIdentifier"
    
    @Published var status: Status = .loading
    @Published var error: Error?
    @Published private var pillDate: Date?
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let pillDataCenter: PillDataCenter
    private let notificationDataCenter: NotificationDataCenter
    
    init(pillDataCenter: PillDataCenter, notificationDataCenter: NotificationDataCenter) {
        self.pillDataCenter = pillDataCenter
        self.notificationDataCenter = notificationDataCenter
        bind()
        fetchPillDate()
        requestSendNotification()
    }
    
    func pillButtonTapped() {
        if status == .not_yet {
            self.status = .loading
            self.pillDataCenter.savePill { [weak self] error in
                self?.error = error
                self?.fetchPillDate()
                self?.removeAllLocalPushNotifications()
            }
        }
    }
    
    func cancelButtonTapped() {
        self.status = .loading
        pillDataCenter.deletePill { [weak self] error in
            self?.error = error
            self?.fetchPillDate()
        }
    }
    
    private func bind() {
        $pillDate.sink { [weak self] date in
            guard let date = date else {
                self?.status = .not_yet
                return
            }
            
            let now = Date()
            
            self?.status = (self?.isSameDay(date1: date, date2: now) ?? false) ? .have : .not_yet
            
        }.store(in: &cancellables)
    }
    
    private func fetchPillDate() {
        status = .loading
        pillDataCenter.fetchPillDate { [weak self] result in
            switch result {
            case .success(let date):
                self?.pillDate = date
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // 알림 전송
    func requestSendNotification() {
        removeAllLocalPushNotifications()
        if notificationDataCenter.fetchIsNotificationDisabled(nil) { return }
        let notiContent = UNMutableNotificationContent()
        notiContent.title = "Night"
        notiContent.body = "Forgot daily pills?"
        notiContent.badge = 1
//        notiContent.userInfo = ["targetScene": "splash"] // 푸시 받을때 오는 데이터

        var dateComponents = DateComponents()
        
        dateComponents.hour = 22
        dateComponents.minute = 0
        
        let trigger:UNCalendarNotificationTrigger = .init(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: PillViewModel.pillNotificationIdentifier,
            content: notiContent,
            trigger: trigger
        )
        
        // 오늘 약을 이미 먹은 경우에는 종료
        if let date = pillDataCenter.fetchPillDateLocal() {
            let now = Date()
            if isSameDay(date1: date, date2: now) { return }
        }

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("DEBUG: error \(error.localizedDescription)")
            }
        }
    }
    
    private func removeAllLocalPushNotifications() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [PillViewModel.pillNotificationIdentifier])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [PillViewModel.pillNotificationIdentifier])
    }
}
