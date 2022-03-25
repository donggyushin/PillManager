//
//  TextView.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/26.
//

import UIKit

class TextView: UITextView {
    
    var horizontalPadding: CGFloat = 4.5
    var verticalPadding: CGFloat = 7.5
    
    private let placeholder: String?
    
    private lazy var placeholderLabel: UILabel = {
        let view = UILabel()
        view.text = placeholder
        view.textColor = .systemFill
        return view
    }()
    
    init(placeholder: String? = nil) {
        self.placeholder = placeholder
        super.init(frame: .zero, textContainer: nil)
        self.delegate = self
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        addSubview(placeholderLabel)
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalPadding),
            placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: horizontalPadding),
            placeholderLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -horizontalPadding)
        ])
    }
}

extension TextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
