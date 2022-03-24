//
//  CustomPillSettingViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/24.
//

import Foundation
import Combine

class CustomPillSettingViewModel {
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var pills: [CustomPill] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    private let customPillDataCenter: CustomPillDataCenter
    
    init(customPillDataCenter: CustomPillDataCenter) {
        self.customPillDataCenter = customPillDataCenter
        bind()
        fetchPills()
    }
    
    public func buttonTapped(with pill: CustomPill) {
        print("DEBUG: button tapped with \(pill)")
    }
    
    private func bind() {
        
    }
    
    private func fetchPills() {
        isLoading = true
        customPillDataCenter.fetchPills { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let pills):
                self?.pills = pills
            case .failure(let error):
                self?.error = error
            }
        }
    }
}
