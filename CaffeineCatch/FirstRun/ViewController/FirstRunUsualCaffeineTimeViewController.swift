//
//  FirstRunUsualCaffeineTimeViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import Foundation
import UIKit
import RxSwift

final class FirstRunUsualCaffeineTimeViewController: UIViewController {
    private let firstRunUsualCaffeineTimeView = FirstRunUsualCaffeineTimeView()
    private let firstRunViewModel: FirstRunViewModel
    private let nextButton = NextButton()
    private let disposeBag = DisposeBag()
    
    init(firstRunViewModel: FirstRunViewModel = FirstRunViewModel()) {
        self.firstRunViewModel = firstRunViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirstRunUsualCaffeineIntakeView()
        setLayoutConstraints()
        bindAll()
    }
}

extension FirstRunUsualCaffeineTimeViewController {
    // MARK: Configure
    private func configureFirstRunUsualCaffeineIntakeView() {
        firstRunUsualCaffeineTimeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstRunUsualCaffeineTimeView)
        view.backgroundColor = .systemBackground
        nextButton.setTitle("완료", for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
    }
    
    // MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            firstRunUsualCaffeineTimeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            firstRunUsualCaffeineTimeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            firstRunUsualCaffeineTimeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            firstRunUsualCaffeineTimeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func changeNotificationButtonsProperty(selectedButton: AnimationButton) {
        var buttons = [
            firstRunUsualCaffeineTimeView.notificationEnabledButton,
            firstRunUsualCaffeineTimeView.notificationDisenabledButton
        ]
        guard let selectedIndex = buttons.firstIndex(of: selectedButton) else { return }
        buttons.remove(at: selectedIndex)
        selectedButton.backgroundColor = .systemBlue
        selectedButton.setTitleColor(.white, for: .normal)
        selectedButton.isSelected = true
        buttons[0].backgroundColor = .systemGray6
        buttons[0].setTitleColor(.label, for: .normal)
        buttons[0].isSelected = false
        nextButton.isHidden = false
    }
    
    // MARK: Bind
    private func bindAll() {
        bindNotificationButtons()
        bindNextButton()
        bindIsSavedSuccess()
    }
    
    private func bindNotificationButtons() {
        firstRunUsualCaffeineTimeView.notificationEnabledButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunUsualCaffeineTimeView else { return }
                self?.changeNotificationButtonsProperty(selectedButton: view.notificationEnabledButton)
            })
            .disposed(by: disposeBag)
        
        firstRunUsualCaffeineTimeView.notificationDisenabledButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunUsualCaffeineTimeView else { return }
                self?.changeNotificationButtonsProperty(selectedButton: view.notificationDisenabledButton)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNextButton() {
        nextButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let view = self?.firstRunUsualCaffeineTimeView else { return }
                let buttons = [
                    view.notificationEnabledButton,
                    view.notificationDisenabledButton
                ].filter { $0.isSelected }
                guard let selectedButton = buttons.first else { return }
                switch selectedButton {
                case view.notificationEnabledButton:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    let time = dateFormatter.string(from: view.datePicker.date)
                    self?.firstRunViewModel.saveNotificationState(isEnabled: true, time: time)
                    return
                case view.notificationDisenabledButton:
                    self?.firstRunViewModel.saveNotificationState(isEnabled: false)
                    return
                default: return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSavedSuccess() {
        firstRunViewModel.isSavedSuccess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {isSavedSuccess in
                guard isSavedSuccess else {
                    print("싪패 ") // 에러 처리 하십송 담곰씨
                    return
                }
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.changeRootViewController(MainTabBarController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
