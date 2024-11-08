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
        self.sheetPresentationController?.detents = [.medium()]
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
        myGoalUpdateView.updateButton.isEnabled = true
        myGoalUpdateView.updateButton.backgroundColor = .systemBlue
    }
    
    //MARK: Bind
    
    private func bindAll() {
        bindValueInputTextField()
        bindSohtMgButton()
    }
    
    private func bindValueInputTextField() {
        myGoalUpdateView.valueInputTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: {[weak self] intakeValue in
                guard let view = self?.myGoalUpdateView else { return }
                let isEnabled = !intakeValue.isEmpty && !(intakeValue == "")
                view.shotButton.isEnabled = isEnabled ? true : false
                view.mgButton.isEnabled = isEnabled ? true : false
                
                if isEnabled {
                    view.shotButton.backgroundColor = view.shotButton.isSelected ? .systemGray4 : .systemBlue
                    view.mgButton.backgroundColor = view.mgButton.isSelected ? .systemGray4 : .systemBlue
                } else {
                    view.shotButton.backgroundColor = .lightGray
                    view.mgButton.backgroundColor = .lightGray
                    view.updateButton.backgroundColor = .lightGray
                    view.shotButton.isSelected = false
                    view.mgButton.isSelected = false
                    view.updateButton.isEnabled = false
                    view.shotButton.setTitle("shot", for: .normal)
                    view.mgButton.setTitle("mg", for: .normal)
                }
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
}
