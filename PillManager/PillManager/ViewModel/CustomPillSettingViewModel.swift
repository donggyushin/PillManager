//
//  CustomPillSettingViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/24.
//

import Foundation
import Combine
import UIKit

final class CustomPillSettingViewModel {
    
    static let live: CustomPillSettingViewModel = .init(customPillDataCenter: CustomPillDataCenter.live, historyDataCenter: HistoryDataCenter.live)
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var pills: [CustomPill] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    private let customPillDataCenter: CustomPillDataCenter
    private let historyDataCenter: HistoryDataCenter
    
    private init(customPillDataCenter: CustomPillDataCenter, historyDataCenter: HistoryDataCenter) {
        self.customPillDataCenter = customPillDataCenter
        self.historyDataCenter = historyDataCenter
        self.pills = customPillDataCenter.fetchPillsFromUserDefaults()
        bind()
        fetchPills()
    }
    
    public func buttonTapped(with pill: CustomPill) {
        let now = Date()
        pill.isTakenToday ? historyDataCenter.removeCustomPillHistory(now, pill) { [weak self] error in
            self?.error = error
            if error == nil {
                self?.checkIsTodayTaken(pills: self?.pills ?? [])
                self?.checkIsYesterdayTaken(pills: self?.pills ?? [])
            }
        } : historyDataCenter.saveCustomPillHistory(now, pill) { [weak self] error in
            self?.error = error
            if error == nil {
                self?.checkIsTodayTaken(pills: self?.pills ?? [])
                self?.checkIsYesterdayTaken(pills: self?.pills ?? [])
            }
        }
    }
    
    public func pillAdded() {
        fetchPills()
    }
    
    private func bind() {
        $pills.debounce(for: 1, scheduler: RunLoop.main).sink { pills in
            guard let rootViewController = window?.rootViewController as? UINavigationController else { return }
            guard let firstViewController = rootViewController.viewControllers.first else { return }
            var newViewControllers = rootViewController.viewControllers
            if pills.isEmpty {
                // 첫번째 컨트롤러가 PillViewController 이어야만 함
                if !(firstViewController is PillViewController) {
                    newViewControllers.remove(at: 0)
                    newViewControllers.insert(PillViewController(), at: 0)
                }
            } else {
                // 첫번째 컨트롤러가 CustomPillSettingViewController 이어야만 함
                if !(firstViewController is CustomPillSettingViewController) {
                    newViewControllers.remove(at: 0)
                    newViewControllers.insert(CustomPillSettingViewController(), at: 0)
                }
            }
            DispatchQueue.main.async {
                rootViewController.setViewControllers(newViewControllers, animated: false)
            }
            
        }.store(in: &cancellables)
    }
    
    private func fetchPills() {
        isLoading = true
        customPillDataCenter.fetchPills { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let pills):
                self?.pills = pills
                self?.checkIsTodayTaken(pills: pills)
                self?.checkIsYesterdayTaken(pills: pills)
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    private func checkIsTodayTaken(pills: [CustomPill]) {
        let now = Date()
        pills.enumerated().forEach({ index, pill in
            self.historyDataCenter.fetchCustomPillHistory(now, pill) { result in
                var pill = self.pills[index]
                pill.isTakenToday = result
                self.pills.remove(at: index)
                self.pills.insert(pill, at: index)
            }
        })
    }
    
    private func checkIsYesterdayTaken(pills: [CustomPill]) {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        guard let yesterday = calendar.date(byAdding: dayComponent, to: Date()) else { return }
        pills.enumerated().forEach({ index, pill in
            self.historyDataCenter.fetchCustomPillHistory(yesterday, pill) { result in
                var pill = self.pills[index]
                pill.isTakenYesterday = result
                self.pills.remove(at: index)
                self.pills.insert(pill, at: index)
            }
        })
    }
}
