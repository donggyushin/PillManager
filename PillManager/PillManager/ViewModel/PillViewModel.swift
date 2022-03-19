//
//  PillViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import Foundation
import Combine

class PillViewModel {
    
    var cancellables: Set<AnyCancellable> = .init()
    
    enum Status: String {
        case have
        case not_yet
        case loading
    }
    
    @Published var status: Status = .loading
}
