//
//  SignInViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController {
    
    private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let view = ASAuthorizationAppleIDButton()
        view.addTarget(self, action: #selector(appleSignInButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [appleSignInButton])
        return view
    }()
    
    private lazy var viewModel: SignInViewModel = .init(viewController: self)
    
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
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            verticalStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    private func bind() {
        viewModel.$loading.sink { [weak self] loading in
            self?.appleSignInButton.isEnabled = !loading
        }.store(in: &viewModel.cancellables)
        
        viewModel.$error.compactMap({ $0 }).sink { [weak self] error in
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Yes", style: .default)
            alert.addAction(okay)
            self?.present(alert, animated: true)
        }.store(in: &viewModel.cancellables)
    }
    
    @objc private func appleSignInButtonTapped() {
        self.viewModel.signInButtonTapped()
    }
}
