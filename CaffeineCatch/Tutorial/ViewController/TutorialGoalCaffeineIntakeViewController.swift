//
//  TutorialGoalCaffeineIntakeViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import Foundation
import UIKit
import RxSwift

final class TutorialGoalCaffeineIntakeViewController: UIViewController {
    private let tutorialGoalCaffeineIntakeView = TutorialGoalCaffeineIntakeView()
    private let tutorialViewModel: TutorialViewModel
    private let nextButton = NextButton()
    private let disposeBag = DisposeBag()
    
    init(viewModel: TutorialViewModel = TutorialViewModel()) {
        self.tutorialViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.tutorialViewModel.recommandGoalCaffeineIntake()
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
        tutorialViewModel.recommandGoalCaffeineIntake()
    }
}

extension TutorialGoalCaffeineIntakeViewController {
    // MARK: Configure
    private func configureFirstRunUsualCaffeineIntakeView() {
        tutorialGoalCaffeineIntakeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tutorialGoalCaffeineIntakeView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
    }
    
    // MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            tutorialGoalCaffeineIntakeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tutorialGoalCaffeineIntakeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tutorialGoalCaffeineIntakeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tutorialGoalCaffeineIntakeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func changeUnitButtonsProperty(selectedButton: IntakeButton) {
        var buttons = [
            tutorialGoalCaffeineIntakeView.shotButton,
            tutorialGoalCaffeineIntakeView.mgButton,
            tutorialGoalCaffeineIntakeView.waterButton
        ]
        guard let selectedIndex = buttons.firstIndex(of: selectedButton) else { return  }
        buttons.remove(at: selectedIndex)
        selectedButton.isSelected = true
        selectedButton.backgroundColor = .systemBlue
        selectedButton.setTitleColor(.white, for: .normal)
        buttons.forEach {
            $0.backgroundColor = .systemGray6
            $0.isSelected = false
            $0.setTitleColor(.label, for: .normal)
        }
    }
    
    private func changeButtonsProperty(selectedButton: AnimationButton) {
        var buttons = [
            tutorialGoalCaffeineIntakeView.recommandButton,
            tutorialGoalCaffeineIntakeView.directInputButton
        ]
        guard let selectedIndex = buttons.firstIndex(of: selectedButton) else { return  }
        buttons.remove(at: selectedIndex)
        selectedButton.backgroundColor = .systemBlue
        selectedButton.setTitleColor(.white, for: .normal)
        selectedButton.isSelected = true
        buttons[0].backgroundColor = .systemGray6
        buttons[0].setTitleColor(.label, for: .normal)
        buttons[0].isSelected = false
        let isSelected = tutorialGoalCaffeineIntakeView.directInputButton.isSelected
        tutorialGoalCaffeineIntakeView.directInputTextField.isEnabled = isSelected ? true : false
        tutorialGoalCaffeineIntakeView.shotButton.isEnabled = isSelected ? true : false
        tutorialGoalCaffeineIntakeView.mgButton.isEnabled = isSelected ? true : false
        tutorialGoalCaffeineIntakeView.waterButton.isEnabled = isSelected ? true : false
        tutorialGoalCaffeineIntakeView.shotButton.backgroundColor = isSelected ? .systemGray6 : .lightGray
        tutorialGoalCaffeineIntakeView.shotButton.setTitleColor(isSelected ? .label : .white, for: .normal)
        tutorialGoalCaffeineIntakeView.mgButton.backgroundColor = isSelected ? .systemGray6 : .lightGray
        tutorialGoalCaffeineIntakeView.mgButton.setTitleColor(isSelected ? .label : .white, for: .normal)
        tutorialGoalCaffeineIntakeView.waterButton.backgroundColor = isSelected ? .systemGray6 : .lightGray
        tutorialGoalCaffeineIntakeView.waterButton.setTitleColor(isSelected ? .label : .white, for: .normal)
        nextButton.isHidden = false
    }
    
    // MARK: Bind
    private func bindAll() {
        bindRecommandButton()
        bindDirectInputButton()
        bindUnitButton()
        bindNextButton()
        bindCaffeineIntakeSubject()
        bindIsSavedSuccess()
    }
    
    private func bindRecommandButton() {
        tutorialGoalCaffeineIntakeView.recommandButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialGoalCaffeineIntakeView else { return }
                self?.changeButtonsProperty(selectedButton: view.recommandButton)
                view.directInputTextField.text = ""
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDirectInputButton() {
        tutorialGoalCaffeineIntakeView.directInputButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialGoalCaffeineIntakeView else { return }
                self?.changeButtonsProperty(selectedButton: view.directInputButton)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUnitButton() {
        tutorialGoalCaffeineIntakeView.shotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialGoalCaffeineIntakeView else { return }
                self?.changeUnitButtonsProperty(selectedButton: view.shotButton)
            })
            .disposed(by: disposeBag)
        
        tutorialGoalCaffeineIntakeView.mgButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialGoalCaffeineIntakeView else { return }
                self?.changeUnitButtonsProperty(selectedButton: view.mgButton)
            })
            .disposed(by: disposeBag)
        
        tutorialGoalCaffeineIntakeView.waterButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialGoalCaffeineIntakeView else { return }
                self?.changeUnitButtonsProperty(selectedButton: view.waterButton)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNextButton() {
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.tutorialGoalCaffeineIntakeView else { return }
                let buttons = [
                    view.recommandButton,
                    view.directInputButton,
                    view.waterButton
                ].filter { $0.isSelected }
                guard let selectedButton = buttons.first else {
                    let title = "카페인 캐치"
                    let message = "버튼 하나를 선택해야 해요."
                    self?.doneAlert(title: title, message: message)
                    return }
                
                switch selectedButton {
                case view.recommandButton:
                    self?.tutorialViewModel.saveGoalCaffeineIntake()
                    return
                    
                case view.directInputButton:
                    let unitButtons = [
                        view.shotButton,
                        view.mgButton,
                        view.waterButton
                    ].filter { $0.isSelected }
                    guard let selectedButton = unitButtons.first,
                          let intakeValue = view.directInputTextField.text,
                          !intakeValue.isEmpty,
                          intakeValue != "",
                          let intakeValueToInt = Int(intakeValue) else {
                        let title = "카페인 캐치"
                        let message = "단위 버튼을 선택하고, 목표량은 숫자로만 입력해야 해요."
                        self?.doneAlert(title: title, message: message)
                        return }
                    let isWater = selectedButton == view.waterButton
                    let intakeCategory = isWater ? IntakeCategory.water.rawValue : IntakeCategory.caffeine.rawValue
                    let intakeUnit = isWater ? IntakeUnitName.mL.rawValue : IntakeUnitName.shot.rawValue
                    self?.tutorialViewModel.saveGoalCaffeineIntake(intakeCategory: intakeCategory,
                                                                   intakeUnitValue: intakeUnit,
                                                                   intakeValue: intakeValueToInt,
                                                                   isWater: isWater)
                    return
                    
                default:
                    let title = "카페인 캐치"
                    let message = "잠시 후 시도해 주세요."
                    self?.doneAlert(title: title, message: message)
                    return 
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCaffeineIntakeSubject() {
        tutorialViewModel.caffeineIntakeSubject
            .asDriver(onErrorJustReturn: "0")
            .drive(onNext: {[weak self] caffeineIntakeSubject in
                guard caffeineIntakeSubject != "0" else { return }
                self?.tutorialGoalCaffeineIntakeView.recommandLabel.text = "회원님의 카페인 섭취량을 기반으로 \n 회원님의 목표 섭취량을\n\(caffeineIntakeSubject)로 추천해요."
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
                self?.navigationController?.pushViewController(TutorialUsualCaffeineTimeViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

