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
    
    @Published var status: Status = .loading
    @Published var error: Error?
    @Published private var pillDate: Date?
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let pillDataCenter: PillDataCenter
    
    init(pillDataCenter: PillDataCenter) {
        self.pillDataCenter = pillDataCenter
        bind()
        fetchPillDate()
        requestSendNoti()
        testNoti()
    }
    
    func buttonTapped() {
        if status == .not_yet {
            self.status = .loading
            self.pillDataCenter.addPill { [weak self] error in
                self?.error = error
                self?.fetchPillDate()
            }
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
        pillDataCenter.getPillDate { [weak self] result in
            switch result {
            case .success(let date):
                self?.pillDate = date
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        calendar.dateComponents([.day], from: date1, to: date2).day == 0
    }
    
    // 알림 전송
    private func requestSendNoti() {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = "Night"
        notiContent.body = "Forgot daily pills?"
        notiContent.badge = .init(value: 1)
//        notiContent.userInfo = ["targetScene": "splash"] // 푸시 받을때 오는 데이터

        // 알림이 trigger되는 시간 설정
        var dateComponents = DateComponents()
        
        dateComponents.hour = 22
        dateComponents.minute = 0
        
        let trigger:UNCalendarNotificationTrigger = .init(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notiContent,
            trigger: trigger
        )

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("DEBUG: error \(error.localizedDescription)")
            }
        }

    }
    
    private func testNoti() {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = "Night"
        notiContent.body = "Forgot daily pills?"
        notiContent.badge = .init(value: 1)
        
        let trigger: UNTimeIntervalNotificationTrigger = .init(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notiContent,
            trigger: trigger
        )

        notificationCenter.add(request) { (error) in
            print("DEBUG: 여기 오낭?")
            if let error = error {
                print("DEBUG: error \(error.localizedDescription)")
            }
        }
    }
}
