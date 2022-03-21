//
//  UIButton+Extension.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/21.
//

import UIKit

extension UIButton {
    
    func present() {
        self.updateAlpha(1, with: 1)
    }
    
    func hide() {
        self.updateAlpha(0, with: 1)
    }
    
    private func updateAlpha(_ alpha: CGFloat, with duration: TimeInterval) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: [.curveEaseInOut]) {
            self.alpha = alpha
        }.startAnimation()
    }
}
