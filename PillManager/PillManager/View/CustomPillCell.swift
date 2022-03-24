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
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .body)
        return view
    }()
    
    private lazy var button: UIButton = {
        let view: UIButton = .init(configuration: UIKit.UIButton.Configuration.tinted(), primaryAction: UIAction(handler: { _ in
            guard let pill = self.pill else { return }
            self.delegate?.customPillCell(cell: self, tapped: pill)
        }))
        view.setImage(UIImage(systemName: "pills"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        view.axis = .vertical
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [verticalStackView, button])
        view.axis = .horizontal
        view.alignment = .center
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
        contentView.addSubview(horizontalStackView)
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            horizontalStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            horizontalStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func configUI(pill: CustomPill) {
        titleLabel.text = pill.title
        descriptionLabel.text = pill.description
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0) {
            self.button.tintColor = pill.isTakenToday ? .systemRed : .systemBlue
        }.startAnimation()
    }
}
