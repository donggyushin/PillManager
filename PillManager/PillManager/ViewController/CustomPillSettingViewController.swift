//
//  CustomPillSettingViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/24.
//

import UIKit
import FirebaseAuth

class CustomPillSettingViewController: UIViewController {
    
    let viewModel: CustomPillSettingViewModel = .live
    
    private lazy var tableView: UITableView = {
        let view: UITableView = .init(frame: .zero, style: UITableView.Style.insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.register(CustomPillCell.self, forCellReuseIdentifier: CustomPillCell.identifier)
        view.register(AddCustomPillCell.self, forCellReuseIdentifier: AddCustomPillCell.identifier)
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
        view.delaysContentTouches = false 
        return view
    }()
    
    override func viewDidLoad() {
        bind()
        configUI()
    }
    
    private func bind() {
        viewModel.$pills.debounce(for: 0.1, scheduler: RunLoop.main).sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.store(in: &viewModel.cancellables)
        
        viewModel.$error.compactMap({ $0 }).sink { [weak self] error in
            let alert: UIAlertController = .init(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            let yes: UIAlertAction = .init(title: "Yes", style: .default) { _ in
                try? Auth.auth().signOut()
            }
            alert.addAction(yes)
            self?.present(alert, animated: true)
        }.store(in: &viewModel.cancellables)
    }
    
    private func configUI() {
        
        // 만약 이게 첫번째 컨트롤러라면
        if let rootViewController = window?.rootViewController as? UINavigationController {
            if rootViewController.viewControllers.first == self {
                navigationItem.rightBarButtonItem = .init(title: nil, image: UIImage(systemName: "gear"), primaryAction: .init(handler: { _ in
                    self.navigationController?.pushViewController(SettingViewController(pillViewModel: PillViewModel.live), animated: true)
                }), menu: nil)
            }
        }
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CustomPillSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != viewModel.pills.count else { return }
        let pill = viewModel.pills[indexPath.row]
        print("DEBUG: \(pill) tapped")
    }
}

extension CustomPillSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rootViewController = window?.rootViewController as? UINavigationController {
            if rootViewController.viewControllers.first == self {
                return viewModel.pills.count
            }
        }
        return viewModel.pills.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == viewModel.pills.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddCustomPillCell.identifier) as? AddCustomPillCell ?? AddCustomPillCell()
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomPillCell.identifier) as? CustomPillCell ?? CustomPillCell()
        cell.pill = viewModel.pills[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
}

extension CustomPillSettingViewController: CustomPillCellDelegate {
    func customPillCell(cell: CustomPillCell, tapped pill: CustomPill) {
        viewModel.buttonTapped(with: pill)
    }
}

extension CustomPillSettingViewController: AddCustomPillCellDelegate {
    func addCustomPillCell(buttonTapped button: AddCustomPillCell) {
        navigationController?.pushViewController(AddCustomPillViewController(), animated: true)
    }
}
