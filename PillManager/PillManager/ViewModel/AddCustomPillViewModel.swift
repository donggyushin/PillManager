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
    
    init() {
        bind()
    }
    
    private func bind() {
        $title.sink { [weak self] text in
            self?.isDoneButtonEnable = !text.isEmpty
        }.store(in: &cancellables)
    }
}
