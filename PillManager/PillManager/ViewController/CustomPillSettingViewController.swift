//
//  CustomPillSettingViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/24.
//

import UIKit

class CustomPillSettingViewController: UIViewController {
    
    private let viewModel: CustomPillSettingViewModel = .init(customPillDataCenter: CustomPillDataCenter.test)
    
    private lazy var tableView: UITableView = {
        let view: UITableView = .init(frame: .zero, style: UITableView.Style.insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.register(CustomPillCell.self, forCellReuseIdentifier: CustomPillCell.identifier)
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
        return view
    }()
    
    override func viewDidLoad() {
        bind()
        configUI()
    }
    
    private func bind() {
        viewModel.$pills.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &viewModel.cancellables)
    }
    
    private func configUI() {
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
    
}

extension CustomPillSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomPillCell.identifier) as? CustomPillCell ?? CustomPillCell()
        cell.pill = viewModel.pills[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
}
