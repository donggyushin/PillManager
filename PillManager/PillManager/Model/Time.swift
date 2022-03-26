//
//  Time.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/24.
//

import Foundation

struct Time: Codable {
    var hour: Int {
        didSet {
            if hour < 0 { hour = 0 }
            if hour >= 24 { hour = 23 }
        }
    }
    var minute: Int {
        didSet {
            if minute < 0 { minute = 0 }
            if minute > 60 { minute = 59 }
        }
    }
    
    init(data: [String: Any]) {
        hour = data["hour"] as? Int ?? 0
        minute = data["minute"] as? Int ?? 0
    }
    
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
}
