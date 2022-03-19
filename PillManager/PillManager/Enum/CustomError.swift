//
//  CustomError.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import Foundation

public enum MyError: Error {
    case not_authorized
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .not_authorized:
            return NSLocalizedString("You are not authorized.", comment: "not_authorized")
        }
    }
}
