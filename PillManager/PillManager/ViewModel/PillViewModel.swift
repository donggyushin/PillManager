//
//  PillViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import Foundation
import Combine
import UserNotifications

final class PillViewModel {
    
    static let live: PillViewModel = .init(pillDataCenter: PillDataCenter.live, notificationDataCenter: NotificationDataCenter.live, historyDataCenter: HistoryDataCenter.live)
    static let test: PillViewModel = .init(pillDataCenter: PillDataCenter.live, notificationDataCenter: NotificationDataCenter.live, historyDataCenter: HistoryDataCenter.live)
    
    enum Status: String {
        case have = "I already have pills"
        case not_yet = "I just have pills"
        case loading = "Waiting..."
    }
    
    private static let pillNotificationIdentifier = "pillNotificationIdentifier"
    
    @Published var status: Status = .loading
    @Published var error: Error?
    @Published var isBlueDotViewVisible: Bool = false
    @Published private var isPillTakenYesterday: Bool = false
    @Published private var pillDate: Date?
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let pillDataCenter: PillDataCenter
    private let notificationDataCenter: NotificationDataCenter
    private let historyDataCenter: HistoryDataCenter
    
    private init(pillDataCenter: PillDataCenter, notificationDataCenter: NotificationDataCenter, historyDataCenter: HistoryDataCenter) {
        self.pillDataCenter = pillDataCenter
        self.notificationDataCenter = notificationDataCenter
        self.historyDataCenter = historyDataCenter
        bind()
        fetchPillDate()
        requestSendNotification()
        fetchYesterdayHistory()
    }
    
    func pillButtonTapped() {
        if status == .not_yet {
            self.status = .loading
            self.pillDataCenter.savePill(historyDataCenter, { [weak self] error in
                self?.error = error
                self?.fetchPillDate()
                self?.removeAllLocalPushNotifications()
            })
        }
    }
    
    func cancelButtonTapped() {
        self.status = .loading
        pillDataCenter.deletePill(historyDataCenter, { [weak self] error in
            self?.error = error
            self?.fetchPillDate()
        })
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
    
    private func bind() {
        $pillDate.sink { [weak self] date in
            guard let date = date else {
                self?.status = .not_yet
                return
            }
            
            let now = Date()
            
            self?.status = (self?.isSameDay(date1: date, date2: now) ?? false) ? .have : .not_yet
            
        }.store(in: &cancellables)
        
        $isPillTakenYesterday.sink { [weak self] result in
            self?.isBlueDotViewVisible = result
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
    
    private func fetchYesterdayHistory() {
        dateComponent.day = -1
        guard let yesterday = calendar.date(byAdding: dateComponent, to: Date()) else { return }
        historyDataCenter.fetchDefaultHistory(yesterday, { [weak self] result in
            self?.isPillTakenYesterday = result
        })
    }
}
