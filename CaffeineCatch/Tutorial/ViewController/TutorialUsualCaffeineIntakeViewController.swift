//
//  TutorialUsualCaffeineIntakeViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import Foundation
import UIKit
import RxSwift

final class TutorialUsualCaffeineIntakeViewController: UIViewController {
    private let tutorialUsualCaffeineIntakeView = TutorialUsualCaffeineIntakeView()
    private let tutorialViewModel: TutorialViewModel
    private let nextButton = NextButton()
    private let disposeBag = DisposeBag()
    
    init(viewModel: TutorialViewModel = TutorialViewModel()) {
        self.tutorialViewModel = viewModel
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
//        NotificationManaged.shared.scheduleDailyNotification(time: "04:56", notificationEnabled: true)
//        NotificationManaged.shared.setAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension TutorialUsualCaffeineIntakeViewController {
    // MARK: Configure
    private func configureFirstRunUsualCaffeineIntakeView() {
        tutorialUsualCaffeineIntakeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tutorialUsualCaffeineIntakeView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
    }
    
    // MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            tutorialUsualCaffeineIntakeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tutorialUsualCaffeineIntakeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tutorialUsualCaffeineIntakeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tutorialUsualCaffeineIntakeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func changeShotButtonsProperty(selectedButton: IntakeButton) {
        var buttons = [
            tutorialUsualCaffeineIntakeView.twoShotOrLessButton,
            tutorialUsualCaffeineIntakeView.twoShotButton,
            tutorialUsualCaffeineIntakeView.threeShotButton,
            tutorialUsualCaffeineIntakeView.fourShotOrMoreButton
        ]
        guard let selectedIndex = buttons.firstIndex(of: selectedButton) else { return  }
        buttons.remove(at: selectedIndex)
        selectedButton.backgroundColor = .systemBlue
        selectedButton.setTitleColor(.white, for: .normal)
        selectedButton.isSelected = true
        buttons.forEach {
            $0.isSelected = false
            $0.setTitleColor(.label, for: .normal)
            $0.backgroundColor = .systemGray6
            
        }
        nextButton.isHidden = false
    }
    
    // MARK: Bind
    private func bindAll() {
        bindShotButtons()
        bindNextButton()
        bindIsSavedSuccess()
    }
    
    private func bindShotButtons() {
        tutorialUsualCaffeineIntakeView.twoShotOrLessButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialUsualCaffeineIntakeView else { return }
                self?.changeShotButtonsProperty(selectedButton: view.twoShotOrLessButton)
            })
            .disposed(by: disposeBag)
        
        tutorialUsualCaffeineIntakeView.twoShotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialUsualCaffeineIntakeView else { return }
                self?.changeShotButtonsProperty(selectedButton: view.twoShotButton)
            })
            .disposed(by: disposeBag)
        
        tutorialUsualCaffeineIntakeView.threeShotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialUsualCaffeineIntakeView else { return }
                self?.changeShotButtonsProperty(selectedButton: view.threeShotButton)
            })
            .disposed(by: disposeBag)
        
        tutorialUsualCaffeineIntakeView.fourShotOrMoreButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialUsualCaffeineIntakeView else { return }
                self?.changeShotButtonsProperty(selectedButton: view.fourShotOrMoreButton)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNextButton() {
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialUsualCaffeineIntakeView else { return }
                let buttons = [
                    view.twoShotOrLessButton,
                    view.twoShotButton,
                    view.threeShotButton,
                    view.fourShotOrMoreButton
                ].filter { $0.isSelected }
                guard let selectedButton = buttons.first else { return }  // 선택해야해욧!! 선택해야 보이는 버튼이지만. 쩄뜬. 에러 처리 담곰씨
                switch selectedButton {
                case view.twoShotOrLessButton:
                    self?.tutorialViewModel.saveUsualCaffeineIntake(1)
                    return
                case view.twoShotButton:
                    self?.tutorialViewModel.saveUsualCaffeineIntake(2)
                    return
                case view.threeShotButton:
                    self?.tutorialViewModel.saveUsualCaffeineIntake(3)
                    return
                case view.fourShotOrMoreButton:
                    self?.tutorialViewModel.saveUsualCaffeineIntake(4)
                    return
                default: return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSavedSuccess() {
        tutorialViewModel.isSavedSuccess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isSavedSuccess in
                guard isSavedSuccess else {
                    print("저장실패..")
                    return }
                print("저장성공^^..")
                self?.navigationController?.pushViewController(TutorialGoalCaffeineIntakeViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
