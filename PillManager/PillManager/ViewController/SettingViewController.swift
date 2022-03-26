//
//  SettingViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/21.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    private lazy var customPillButton: UIButton = {
        let view: UIButton = .init(configuration: .plain(), primaryAction: .init(handler: { _ in
            self.navigationController?.pushViewController(CustomPillSettingViewController(), animated: true)
        }))
        view.setTitle("Custom pill", for: .normal)
        return view
    }()
    
    private lazy var notificationButton: UIButton = {
        let view: UIButton = .init(configuration: .plain(), primaryAction: .init(handler: { _ in
            self.viewModel.switchTapped()
        }))
        view.setTitle("Notification", for: .normal)
        return view
    }()
    
    private lazy var notificationSwitch: UISwitch = {
        let view: UISwitch = .init(frame: .zero, primaryAction: .init(handler: { _ in
            self.viewModel.switchTapped()
        }))
        view.onTintColor = .systemBlue
        return view
    }()
    
    private lazy var logoutButton: UIButton = {
        let view: UIButton = .init(configuration: .plain(), primaryAction: .init(handler: { _ in
            self.signOutButtonTapped()
        }))
        view.setTitle("Sign out", for: .normal)
        view.tintColor = .systemRed
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [customPillButton, notificationButton, UIView(), logoutButton])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 20
        return view
    }()
    
    private let pillViewModel: PillViewModel
    private lazy var viewModel: SettingViewModel = .init(notificationDataCenter: NotificationDataCenter.live, pillViewModel: pillViewModel)
    
    init(pillViewModel: PillViewModel) {
        self.pillViewModel = pillViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configUI()
        bind()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(verticalStackView)
        view.addSubview(notificationSwitch)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        notificationSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            verticalStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            verticalStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            notificationSwitch.centerYAnchor.constraint(equalTo: notificationButton.centerYAnchor),
            notificationSwitch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    private func signOutButtonTapped() {
        let alert = UIAlertController(title: nil, message: "Are you sure that you want to sign out?", preferredStyle: .actionSheet)
        let yes: UIAlertAction = .init(title: "Yes", style: .default) { _ in
            try? Auth.auth().signOut()
        }
        let no: UIAlertAction = .init(title: "No", style: .cancel)
        
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true)
    }
    
    private func bind() {
        viewModel.$isNotificationDisabled.sink { [weak self] isNotificationDisabled in
            self?.notificationSwitch.setOn(!isNotificationDisabled, animated: true)
        }.store(in: &viewModel.cancellables)
    }
}
