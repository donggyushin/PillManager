//
//  CustomPill.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/24.
//

import Foundation

struct CustomPill: Codable {
    var id: String = UUID().uuidString
    var title: String
    var description: String?
    var time: Time
    var isTakenToday = false
    var isTakenYesterday = false 
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        title = data["title"] as? String ?? ""
        description = data["description"] as? String
        let timeData = data["time"] as? [String: Any] ?? [:]
        time = .init(data: timeData)
    }
}
