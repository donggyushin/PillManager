//
//  PillViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import UIKit
import FirebaseAuth

class PillViewController: UIViewController {
    
    private let viewModel: PillViewModel = .init(pillDataCenter: PillDataCenter.live, notificationDataCenter: NotificationDataCenter.live)
    
    private lazy var pillButton: UIButton = .init(configuration: .tinted(), primaryAction: .init(handler: { _ in
        self.viewModel.pillButtonTapped()
    }))
    
    private lazy var cancelButton: UIButton = {
        let view: UIButton = .init(configuration: .tinted(), primaryAction: .init(handler: { _ in
            self.viewModel.cancelButtonTapped()
        }))
        view.setTitle("Cancel", for: .normal)
        view.tintColor = .systemRed
        view.alpha = 0
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [pillButton, cancelButton])
        view.axis = .vertical
        view.spacing = 0 
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
        bind()
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(verticalStackView)
        navigationItem.rightBarButtonItem = .init(title: nil, image: UIImage(systemName: "gear"), primaryAction: .init(handler: { _ in
            self.navigationController?.pushViewController(SettingViewController(), animated: true)
        }), menu: nil)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            verticalStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    private func bind() {
        viewModel.$status.sink { [weak self] status in
            
            self?.pillButton.isEnabled = status == .not_yet
            self?.pillButton.setTitle(status.rawValue, for: .normal)
            
            self?.cancelButton.isEnabled = status == .have
            status == .have ? self?.cancelButton.present() : self?.cancelButton.hide()
            
        }.store(in: &viewModel.cancellables)
        
        viewModel.$error.compactMap({ $0 }).sink { [weak self] error in
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default) { _ in
                try? Auth.auth().signOut()
            }
            alert.addAction(yes)
            self?.present(alert, animated: true)
        }.store(in: &viewModel.cancellables)
    }
}
