//
//  SignInViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController {
    
    private lazy var signInButton: UIButton = {
        let view = UIButton(configuration: .tinted(), primaryAction: .init(handler: { _ in
            self.showOnlyAppleSignInAvailableAlert()
        }))
        view.setTitle("Sign In", for: .normal)
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [signInButton])
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
            self?.signInButton.isEnabled = !loading
        }.store(in: &viewModel.cancellables)
        
        viewModel.$error.compactMap({ $0 }).sink { [weak self] error in
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Yes", style: .default)
            alert.addAction(okay)
            self?.present(alert, animated: true)
        }.store(in: &viewModel.cancellables)
    }
    
    private func showOnlyAppleSignInAvailableAlert() {
        let alert: UIAlertController = .init(title: nil, message: "This application only allow apple sign in. Do you wanna go on?", preferredStyle: .actionSheet)
        
        let okay: UIAlertAction = .init(title: "Yes", style: .default) { _ in
            self.viewModel.signInButtonTapped()
        }
        
        let no: UIAlertAction = .init(title: "No", style: .cancel)
        
        alert.addAction(okay)
        alert.addAction(no)
        
        present(alert, animated: true)
    }
}
