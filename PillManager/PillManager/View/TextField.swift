//
//  TextField.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/26.
//

import UIKit

class TextField: UITextField {
    init(placeholder: String? = nil) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        clearButtonMode = .whileEditing
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        borderStyle = .roundedRect
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemGroupedBackground
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
