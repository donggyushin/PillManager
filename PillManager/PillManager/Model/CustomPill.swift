//
//  CustomPill.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/24.
//

import Foundation

struct CustomPill: Codable {
    var id: String
    var title: String
    var description: String?
    var time: Time
    var isTakenToday: Bool
    var isTakenYesterday: Bool
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        title = data["title"] as? String ?? ""
        description = data["description"] as? String
        let timeData = data["time"] as? [String: Any] ?? [:]
        time = .init(data: timeData)
        isTakenToday = data["isTakenToday"] as? Bool ?? false
        isTakenYesterday = data["isTakenToday"] as? Bool ?? false 
    }
    
    init(title: String, description: String?, time: Time) {
        self.id = UUID().uuidString
        self.title = title
        self.description = description
        self.time = time
        self.isTakenToday = false
        self.isTakenYesterday = false
    }
}
