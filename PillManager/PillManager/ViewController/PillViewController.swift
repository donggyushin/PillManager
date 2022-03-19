//
//  PillViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import UIKit

class PillViewController: UIViewController {
    
    private let viewModel: PillViewModel = .init(pillDataCenter: PillDataCenter.default)
    
    private lazy var button: UIButton = .init(configuration: .tinted(), primaryAction: .init(handler: { _ in
        self.viewModel.buttonTapped()
    }))
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [button])
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
        view.addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            verticalStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            verticalStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    
    private func bind() {
        viewModel.$status.sink { [weak self] status in
            self?.button.isEnabled = false
            switch status {
            case .not_yet:
                self?.button.setTitle("I have the pill", for: .normal)
                self?.button.isEnabled = true
            case .have:
                self?.button.setTitle("Already I have the pill", for: .normal)
            case .loading:
                self?.button.setTitle("Please wait...", for: .normal)
            }
        }.store(in: &viewModel.cancellables)
        
        viewModel.$error.compactMap({ $0 }).sink { [weak self] error in
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes", style: .default)
            alert.addAction(yes)
            self?.present(alert, animated: true)
        }.store(in: &viewModel.cancellables)
    }
}
