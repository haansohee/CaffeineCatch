//
//  MyGoalUpdateViewCotnroller.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/30/24.
//

import Foundation
import UIKit
import RxSwift

final class MyGoalUpdateViewCotnroller: UIViewController {
    private let myGoalUpdateView = MyGoalUpdateView()
    private let myGoalViewModel = MyGoalViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMyGoalUpdateViewCotnroller()
        setLayoutConstraint()
        bindAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetMyGoalUpdateViewButtonsProperties()
    }
}

extension MyGoalUpdateViewCotnroller {
    //MARK: Configure
    private func configureMyGoalUpdateViewCotnroller() {
        myGoalUpdateView.translatesAutoresizingMaskIntoConstraints = false
        self.modalPresentationCapturesStatusBarAppearance = true
        self.sheetPresentationController?.detents = [.large()]
        self.sheetPresentationController?.prefersGrabberVisible = true
        self.sheetPresentationController?.preferredCornerRadius = 24.0
        view.addSubview(myGoalUpdateView)
        view.backgroundColor = .systemBackground
    }
    
    //MARK: Set Layout Constraint
    private func setLayoutConstraint() {
        NSLayoutConstraint.activate([
            myGoalUpdateView.topAnchor.constraint(equalTo: view.topAnchor),
            myGoalUpdateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myGoalUpdateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myGoalUpdateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
    
    private func resetMyGoalUpdateViewButtonsProperties() {
        myGoalUpdateView.shotButton.isSelected = false
        myGoalUpdateView.mgButton.isSelected = false
        myGoalUpdateView.shotButton.backgroundColor = .lightGray
        myGoalUpdateView.mgButton.backgroundColor = .lightGray
        myGoalUpdateView.shotButton.setTitle("shot", for: .normal)
        myGoalUpdateView.mgButton.setTitle("mg", for: .normal)
    }
    
    private func updateShotMgButtonState(enabledButton: AnimationButton,
                                         disabledButton: AnimationButton,
                                         enabledButtonTitle: String,
                                         disabledButtonTitle: String) {
        enabledButton.isSelected = true
        enabledButton.backgroundColor = .systemGray4
        enabledButton.setTitle(enabledButtonTitle, for: .normal)
        disabledButton.isSelected = false
        disabledButton.backgroundColor = .systemBlue
        disabledButton.setTitle(disabledButtonTitle, for: .normal)
        myGoalUpdateView.goalCaffeineUpdateButton.isEnabled = true
        myGoalUpdateView.goalCaffeineUpdateButton.backgroundColor = .systemBlue
    }
    
    //MARK: Bind
    
    private func bindAll() {
        bindValueInputTextField()
        bindWaterInputTextField()
        bindSohtMgButton()
        bindGoalCaffeineUpdateButton()
        bindGoalWaterUpdateButton()
        bindIsUpdatedGoalCaffeineIntake()
    }
    
    private func bindValueInputTextField() {
        myGoalUpdateView.valueInputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: {[weak self] intakeValue in
                guard let view = self?.myGoalUpdateView else { return }
                guard let isEnabled = self?.myGoalViewModel.isEmptyIntakeValue(intakeValue) else { return }
                view.shotButton.isEnabled = isEnabled
                view.mgButton.isEnabled = isEnabled
                view.waterInputTextField.text = ""
                view.goalWaterUpdateButton.isEnabled = false
                view.goalWaterUpdateButton.backgroundColor = .lightGray
                
                if isEnabled {
                    view.shotButton.backgroundColor = view.shotButton.isSelected ? .systemGray4 : .systemBlue
                    view.mgButton.backgroundColor = view.mgButton.isSelected ? .systemGray4 : .systemBlue
                } else {
                    view.shotButton.backgroundColor = .lightGray
                    view.mgButton.backgroundColor = .lightGray
                    view.goalCaffeineUpdateButton.backgroundColor = .lightGray
                    view.shotButton.isSelected = false
                    view.mgButton.isSelected = false
                    view.goalCaffeineUpdateButton.isEnabled = false
                    view.shotButton.setTitle("shot", for: .normal)
                    view.mgButton.setTitle("mg", for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindWaterInputTextField() {
        myGoalUpdateView.waterInputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: {[weak self] intakeValue in
                guard let view = self?.myGoalUpdateView else { return }
                guard let isEnabled = self?.myGoalViewModel.isEmptyIntakeValue(intakeValue) else { return }
                view.valueInputTextField.text = ""
                view.goalCaffeineUpdateButton.isEnabled = false
                view.goalCaffeineUpdateButton.backgroundColor = .lightGray
                view.mgButton.isEnabled = false
                view.shotButton.isEnabled = false
                view.shotButton.isSelected = false
                view.mgButton.isSelected = false
                view.mgButton.backgroundColor = .lightGray
                view.shotButton.backgroundColor = .lightGray
                view.goalCaffeineUpdateButton.backgroundColor = .lightGray
                view.goalCaffeineUpdateButton.isEnabled = false
                view.shotButton.setTitle("shot", for: .normal)
                view.mgButton.setTitle("mg", for: .normal)
                view.goalWaterUpdateButton.isEnabled = isEnabled
                view.goalWaterUpdateButton.backgroundColor = isEnabled ? .systemBlue : .lightGray
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSohtMgButton() {
        myGoalUpdateView.shotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.myGoalUpdateView else { return }
                self?.updateShotMgButtonState(enabledButton: view.shotButton,
                                              disabledButton: view.mgButton,
                                              enabledButtonTitle: "shot ✔️",
                                              disabledButtonTitle: "mg")
            })
            .disposed(by: disposeBag)
        
        myGoalUpdateView.mgButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.myGoalUpdateView else { return }
                self?.updateShotMgButtonState(enabledButton: view.mgButton,
                                              disabledButton: view.shotButton,
                                              enabledButtonTitle: "mg ✔️",
                                              disabledButtonTitle: "shot")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindGoalCaffeineUpdateButton() {
        myGoalUpdateView.goalCaffeineUpdateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let view = self?.myGoalUpdateView else { return }
                guard let intakeValue = view.valueInputTextField.validatedText(),
                      let intakeValueInt = Int(intakeValue) else { return }
                guard view.mgButton.isSelected || view.shotButton.isSelected else { return }  // 에러 처리 하십시옹 담곰씨
                let unitValue = view.mgButton.isSelected ? IntakeUnitName.mg.rawValue : IntakeUnitName.shot.rawValue
                self?.myGoalViewModel.updateGoalCaffeineIntake(intakeValueInt, unitValue)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindGoalWaterUpdateButton() {
        myGoalUpdateView.goalWaterUpdateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let view = self?.myGoalUpdateView else { return }
                guard let intakeValue = view.waterInputTextField.validatedText(),
                      let intakeValueToInt = Int(intakeValue) else { return }  // 에러 처리 하십시옹 담곰씨
                self?.myGoalViewModel.updateGoalWaterIntake(intakeValueToInt, IntakeUnitName.mL.rawValue)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedGoalCaffeineIntake() {
        myGoalViewModel.isUpdatedGoalCaffeineIntake
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdatedGoalCaffeineIntake in
                guard isUpdatedGoalCaffeineIntake else { return }  // 에러 처리, 성공 처리 하십시옹 담곰씨
                print("업데이트 완료")
            })
            .disposed(by: disposeBag)
    }
}
