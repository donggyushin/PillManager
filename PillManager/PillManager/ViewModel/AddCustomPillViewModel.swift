//
//  AddCustomPillViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/26.
//

import Foundation
import Combine

class AddCustomPillViewModel {
    var cancellables: Set<AnyCancellable> = .init()
    
    @Published var selectedDate: Date = .init()
    @Published var title: String = ""
    @Published var description: String?
    @Published var isDoneButtonEnable = false
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isDone = false
    
    private let customPillDataCenter: CustomPillDataCenter
    
    init(customPillDataCenter: CustomPillDataCenter) {
        self.customPillDataCenter = customPillDataCenter
        bind()
    }
    
    public func doneButtonTapped() {
        let hour = calendar.component(.hour, from: selectedDate)
        let minute = calendar.component(.minute, from: selectedDate)
        let time: Time = .init(hour: hour, minute: minute)
        let pill: CustomPill = .init(title: title, description: description, time: time)
        self.isLoading = true
        customPillDataCenter.savePill(pill, { [weak self] error in
            self?.isLoading = false
            self?.error = error
            self?.isDone = true 
        })
    }
    
    private func bind() {
        $title.combineLatest($isLoading, $isDone).sink { [weak self] title, isLoading, isDone in
            self?.isDoneButtonEnable = (title.isEmpty == false && isLoading == false && isDone == false)
        }.store(in: &cancellables)
    }
}
