//
//  SignInViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import UIKit

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
        view.addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            verticalStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    private func showOnlyAppleSignInAvailableAlert() {
        let alert: UIAlertController = .init(title: nil, message: "This application only allow apple sign in. Do you wanna go on?", preferredStyle: .actionSheet)
        
        let okay: UIAlertAction = .init(title: "Yes", style: .default) { _ in
            print("DEBUG: start apple sign in")
        }
        
        let no: UIAlertAction = .init(title: "No", style: .cancel)
        
        alert.addAction(okay)
        alert.addAction(no)
        
        present(alert, animated: true)
    }
}
