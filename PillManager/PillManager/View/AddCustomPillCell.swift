//
//  AddCustomPillCell.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/25.
//

import UIKit

protocol AddCustomPillCellDelegate: AnyObject {
    func addCustomPillCell(buttonTapped button: AddCustomPillCell)
}

class AddCustomPillCell: UITableViewCell {
    
    static let identifier = "AddCustomPillCellIdentifier"
    
    weak var delegate: AddCustomPillCellDelegate?
    
    private lazy var button: UIButton = {
        let view: UIButton = .init(configuration: UIKit.UIButton.Configuration.bordered(), primaryAction: UIKit.UIAction(handler: { _ in
            self.delegate?.addCustomPillCell(buttonTapped: self)
        }))
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        backgroundColor = .systemBackground
        contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            button.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            button.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
