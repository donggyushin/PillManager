//
//  PillViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import Foundation
import Combine

class PillViewModel {
    
    enum Status: String {
        case have
        case not_yet
        case loading
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
}
