//
//  AddCustomPillViewController.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/25.
//

import UIKit
import RxCocoa
import RxSwift

class AddCustomPillViewController: UIViewController {
    
    let viewModel: AddCustomPillViewModel = .init(customPillDataCenter: CustomPillDataCenter.live)
    
    private let disposeBag: DisposeBag = .init()
    
    private lazy var doneButton: UIButton = {
        let view: UIButton = .init(configuration: UIKit.UIButton.Configuration.plain(), primaryAction: UIKit.UIAction(handler: { _ in
            self.viewModel.doneButtonTapped()
        }))
        view.setTitle("done", for: .normal)
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view: UIScrollView = .init()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let view: UIDatePicker = .init()
        view.preferredDatePickerStyle = .compact
        view.datePickerMode = .time
        return view
    }()
    
    private let titleTextField: TextField = .init(placeholder: "Title")
    
    private let descriptionTextView: TextView = {
        let view = TextView(placeholder: "Description")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleTextField, descriptionTextView])
        view.axis = .vertical
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
        bind()
    }
    
    private func bind() {
        timePicker.rx.date.subscribe(onNext: { [weak self] date in
            self?.viewModel.selectedDate = date
        }).disposed(by: disposeBag)
        
        titleTextField.rx.text.compactMap({ $0 }).subscribe(onNext: { [weak self] text in
            self?.viewModel.title = text
        }).disposed(by: disposeBag)
        
        descriptionTextView.rx.text.subscribe(onNext: { [weak self] text in
            self?.viewModel.description = text
        }).disposed(by: disposeBag)
        
        viewModel.$isDoneButtonEnable.sink { [weak self] enable in
            self?.doneButton.isEnabled = enable
        }.store(in: &viewModel.cancellables)
        
        viewModel.$isDone.filter({ $0 }).sink { [weak self] _ in
            
            if let customPillSettingViewController = self?.navigationController?.viewControllers.compactMap({ $0 as? CustomPillSettingViewController }).first {
                customPillSettingViewController.viewModel.pillAdded()
            }
            
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &viewModel.cancellables)
    }
    
    private func configUI() {
        
        navigationItem.rightBarButtonItem = .init(customView: doneButton)
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(timePicker)
        scrollView.addSubview(verticalStackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            timePicker.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            timePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            verticalStackView.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 20),
            verticalStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            verticalStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        
        scrollView.subviews.last?.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50).isActive = true
    }
}
