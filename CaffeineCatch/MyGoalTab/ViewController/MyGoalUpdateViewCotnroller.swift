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
        myGoalUpdateView.shotButton.tag = 0
        myGoalUpdateView.mgButton.tag = 0
        myGoalUpdateView.shotButton.backgroundColor = .lightGray
        myGoalUpdateView.mgButton.backgroundColor = .lightGray
        myGoalUpdateView.shotButton.setTitle("shot", for: .normal)
        myGoalUpdateView.mgButton.setTitle("mg", for: .normal)
    }
    
    private func updateShotMgButtonState(enabledButton: AnimationButton,
                                         disabledButton: AnimationButton,
                                         enabledButtonTitle: String,
                                         disabledButtonTitle: String) {
        enabledButton.tag = 1
        enabledButton.backgroundColor = .systemGray4
        enabledButton.setTitle(enabledButtonTitle, for: .normal)
        disabledButton.tag = 0
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
                let isEnabled = !intakeValue.isEmpty && !(intakeValue == "")
                self?.myGoalUpdateView.shotButton.isEnabled = isEnabled ? true : false
                self?.myGoalUpdateView.mgButton.isEnabled = isEnabled ? true : false
                
                if isEnabled {
                    self?.myGoalUpdateView.shotButton.backgroundColor = self?.myGoalUpdateView.shotButton.tag == 1 ? .systemGray4 : .systemBlue
                    self?.myGoalUpdateView.mgButton.backgroundColor = self?.myGoalUpdateView.mgButton.tag == 1 ? .systemGray4 : .systemBlue
                } else {
                    self?.myGoalUpdateView.shotButton.backgroundColor = .lightGray
                    self?.myGoalUpdateView.mgButton.backgroundColor = .lightGray
                    self?.myGoalUpdateView.updateButton.backgroundColor = .lightGray
                    self?.myGoalUpdateView.shotButton.tag = 0
                    self?.myGoalUpdateView.mgButton.tag = 0
                    self?.myGoalUpdateView.updateButton.isEnabled = false
                    self?.myGoalUpdateView.shotButton.setTitle("shot", for: .normal)
                    self?.myGoalUpdateView.mgButton.setTitle("mg", for: .normal)
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
