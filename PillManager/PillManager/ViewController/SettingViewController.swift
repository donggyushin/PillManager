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
            print("DEBUG: Navigate to custom pill controller")
        }))
        view.setTitle("Custom pill", for: .normal)
        return view
    }()
    
    private lazy var notificationButton: UIButton = {
        let view: UIButton = .init(configuration: .plain(), primaryAction: .init(handler: { _ in
            print("DEBUG: Navigate to notification controller")
        }))
        view.setTitle("Notification", for: .normal)
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configUI()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            verticalStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            verticalStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
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
}
