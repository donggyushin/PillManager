//
//  SettingViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/21.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    private lazy var logoutButton: UIButton = {
        let view: UIButton = .init(configuration: .plain(), primaryAction: .init(handler: { _ in
            try? Auth.auth().signOut()
        }))
        view.setTitle("Sign out", for: .normal)
        view.tintColor = .systemRed
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [logoutButton])
        view.axis = .vertical
        view.alignment = .leading
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
}
