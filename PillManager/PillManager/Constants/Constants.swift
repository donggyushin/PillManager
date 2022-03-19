//
//  Constants.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import Firebase
import UIKit

public let db = Firestore.firestore()

public var window: UIWindow? {
    guard let scene = UIApplication.shared.connectedScenes.first,
          let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
          let window = windowSceneDelegate.window else {
              return nil
          }
    return window
}

public var calendar: Calendar = .current
