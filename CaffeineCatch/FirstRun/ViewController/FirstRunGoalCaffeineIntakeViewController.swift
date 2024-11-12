//
//  FirstRunGoalCaffeineIntakeViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import Foundation
import UIKit
import RxSwift

final class FirstRunGoalCaffeineIntakeViewController: UIViewController {
    private let firstRunGoalCaffeineIntakeView = FirstRunGoalCaffeineIntakeView()
    private let firstRunViewModel: FirstRunViewModel
    private let nextButton = NextButton()
    private let disposeBag = DisposeBag()
    
    init(firstRunViewModel: FirstRunViewModel = FirstRunViewModel()) {
        self.firstRunViewModel = firstRunViewModel
        super.init(nibName: nil, bundle: nil)
        self.firstRunViewModel.recommandGoalCaffeineIntake()
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
    
    override func viewWillAppear(_ animated: Bool) {
        print("goal view will appear")
        firstRunViewModel.recommandGoalCaffeineIntake()
    }
}

extension FirstRunGoalCaffeineIntakeViewController {
    // MARK: Configure
    private func configureFirstRunUsualCaffeineIntakeView() {
        firstRunGoalCaffeineIntakeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstRunGoalCaffeineIntakeView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
    }
    
    // MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            firstRunGoalCaffeineIntakeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            firstRunGoalCaffeineIntakeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            firstRunGoalCaffeineIntakeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            firstRunGoalCaffeineIntakeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func changeUnitButtonsProperty(selectedButton: IntakeButton) {
        var buttons = [
            firstRunGoalCaffeineIntakeView.shotButton,
            firstRunGoalCaffeineIntakeView.mgButton
        ]
        guard let selectedIndex = buttons.firstIndex(of: selectedButton) else { return  }
        buttons.remove(at: selectedIndex)
        selectedButton.isSelected = true
        selectedButton.backgroundColor = .systemBlue
        selectedButton.setTitleColor(.white, for: .normal)
        buttons[0].backgroundColor = .systemGray6
        buttons[0].isSelected = false
        buttons[0].setTitleColor(.label, for: .normal)
    }
    
    private func changeButtonsProperty(selectedButton: AnimationButton) {
        var buttons = [
            firstRunGoalCaffeineIntakeView.recommandButton,
            firstRunGoalCaffeineIntakeView.directInputButton
        ]
        guard let selectedIndex = buttons.firstIndex(of: selectedButton) else { return  }
        buttons.remove(at: selectedIndex)
        selectedButton.backgroundColor = .systemBlue
        selectedButton.setTitleColor(.white, for: .normal)
        selectedButton.isSelected = true
        buttons[0].backgroundColor = .systemGray6
        buttons[0].setTitleColor(.label, for: .normal)
        buttons[0].isSelected = false
        let isSelected = firstRunGoalCaffeineIntakeView.directInputButton.isSelected
        firstRunGoalCaffeineIntakeView.directInputTextField.isEnabled = isSelected ? true : false
        firstRunGoalCaffeineIntakeView.shotButton.isEnabled = isSelected ? true : false
        firstRunGoalCaffeineIntakeView.mgButton.isEnabled = isSelected ? true : false
        firstRunGoalCaffeineIntakeView.shotButton.backgroundColor = isSelected ? .systemGray6 : .lightGray
        firstRunGoalCaffeineIntakeView.shotButton.setTitleColor(isSelected ? .label : .white, for: .normal)
        firstRunGoalCaffeineIntakeView.mgButton.backgroundColor = isSelected ? .systemGray6 : .lightGray
        firstRunGoalCaffeineIntakeView.mgButton.setTitleColor(isSelected ? .label : .white, for: .normal)
        nextButton.isHidden = false
    }
    
    // MARK: Bind
    private func bindAll() {
        bindRecommandButton()
        bindDirectInputButton()
        bindShotMgButton()
        bindNextButton()
        bindCaffeineIntakeSubject()
        bindIsSavedSuccess()
    }
    
    private func bindRecommandButton() {
        firstRunGoalCaffeineIntakeView.recommandButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunGoalCaffeineIntakeView else { return }
                self?.changeButtonsProperty(selectedButton: view.recommandButton)
                view.directInputTextField.text = ""
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDirectInputButton() {
        firstRunGoalCaffeineIntakeView.directInputButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunGoalCaffeineIntakeView else { return }
                self?.changeButtonsProperty(selectedButton: view.directInputButton)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindShotMgButton() {
        firstRunGoalCaffeineIntakeView.shotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunGoalCaffeineIntakeView else { return }
                self?.changeUnitButtonsProperty(selectedButton: view.shotButton)
            })
            .disposed(by: disposeBag)
        
        firstRunGoalCaffeineIntakeView.mgButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunGoalCaffeineIntakeView else { return }
                self?.changeUnitButtonsProperty(selectedButton: view.mgButton)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNextButton() {
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunGoalCaffeineIntakeView else { return }
                let buttons = [
                    view.recommandButton,
                    view.directInputButton
                ].filter { $0.isSelected }
                guard let selectedButton = buttons.first else { return }  // 선택해야해욧! 선택해야 보이는 거긴 하지만 ㅎ..
                
                switch selectedButton {
                case view.recommandButton:
                    self?.firstRunViewModel.saveGoalCaffeineIntake()
                    return
                    
                case view.directInputButton:
                    let unitButtons = [
                        view.shotButton,
                        view.mgButton
                    ].filter { $0.isSelected }
                    guard let selectedButton = unitButtons.first,
                          let unitValue = selectedButton.titleLabel?.text,
                          let intakeValue = view.directInputTextField.text,
                          !intakeValue.isEmpty,
                          intakeValue != "" else { return }  // 선택, 입력해야해욧!!!!!!!!!!!!!!!!!!
                    self?.firstRunViewModel.saveGoalCaffeineIntake("\(intakeValue) \(unitValue)")
                    return
                    
                default: return // 에러 처리
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCaffeineIntakeSubject() {
        firstRunViewModel.caffeineIntakeSubject
            .asDriver(onErrorJustReturn: "0")
            .drive(onNext: {[weak self] caffeineIntakeSubject in
                guard caffeineIntakeSubject != "0" else { return }
                self?.firstRunGoalCaffeineIntakeView.recommandLabel.text = "회원님의 카페인 섭취량을 기반으로 \n 회원님의 목표 섭취량을\n\(caffeineIntakeSubject)로 추천해요."
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSavedSuccess() {
        firstRunViewModel.isSavedSuccess
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isSavedSuccess in
                guard isSavedSuccess else {
                    print("저장실패..")
                    return }
                print("저장성공^^..")
                self?.navigationController?.pushViewController(FirstRunUsualCaffeineTimeViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

