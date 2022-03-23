//
//  DotView.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/23.
//

import UIKit

class DotView: UIView {
    
    private let size: CGFloat, color: UIColor
    
    init(size: CGFloat = 8, color: UIColor = .systemBlue) {
        self.size = size
        self.color = color
        super.init(frame: .zero)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = size / 2
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size)
        ])
        backgroundColor = color
    }
}
