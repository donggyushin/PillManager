//
//  CustomPillCell.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/24.
//

import UIKit

protocol CustomPillCellDelegate: AnyObject {
    func customPillCell(cell: CustomPillCell, tapped pill: CustomPill)
}

class CustomPillCell: UITableViewCell {
    
    weak var delegate: CustomPillCellDelegate?
    
    static let identifier = "CustomPillCellIdentifier"
    var pill: CustomPill? {
        didSet {
            guard let pill = pill else { return }
            configUI(pill: pill)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .title3)
        return view
    }()
    
    private let blueDot: DotView = .init()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.numberOfLines = 0 
        return view
    }()
    
    private lazy var button: UIButton = {
        let view: UIButton = .init(configuration: UIKit.UIButton.Configuration.plain(), primaryAction: UIAction(handler: { _ in
            guard let pill = self.pill else { return }
            self.delegate?.customPillCell(cell: self, tapped: pill)
        }))
        view.setImage(UIImage(systemName: "pills"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(blueDot)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(button)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        blueDot.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            blueDot.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            blueDot.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 8),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: button.leftAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
    }
    
    private func configUI(pill: CustomPill) {
        titleLabel.text = pill.title
        descriptionLabel.text = pill.description
        button.tintColor = pill.isTakenToday ? .systemRed : .systemBlue
        blueDot.isHidden = !pill.isTakenYesterday
    }
}
