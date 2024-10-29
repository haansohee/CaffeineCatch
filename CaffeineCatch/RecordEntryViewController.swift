//
//  RecordEntryViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/29/24.
//

import Foundation
import UIKit
import RxSwift

final class RecordEntryViewController: UIViewController {
    private let recordEntryView = RecordEntryView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecordEntryView()
        setLayoutConstraints()
        bindAll()
    }
}

extension RecordEntryViewController {
    //MARK: Configure
    private func configureRecordEntryView() {
        recordEntryView.translatesAutoresizingMaskIntoConstraints = false
        recordEntryView.showsVerticalScrollIndicator = false
        view.addSubview(recordEntryView)
        view.backgroundColor = .systemBackground
        navigationItem.title = "📝"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: recordEntryView.recordSaveButton)
    }
    
    //MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            recordEntryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recordEntryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recordEntryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recordEntryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func changeIntakeButtonsProperty(selectedButton: IntakeButton) {
        var buttons = [
            recordEntryView.oneShotButton,
            recordEntryView.twoShotButton,
            recordEntryView.threeShotButton,
            recordEntryView.fourShotButton,
            recordEntryView.directInputButton,
            recordEntryView.waterIntakeButton,
            recordEntryView.nonCaffeineIntakeButton,
            recordEntryView.milkIntakeButton,
            recordEntryView.teaIntakeButton,
            recordEntryView.anotherIntakeButton,
            recordEntryView.shotButton,
            recordEntryView.mgButton
        ]
        
        guard let index = buttons.firstIndex(of: selectedButton) else { return }  // return 될 시 에러 처리 하십시오 담곰씨 (나중에..)
        buttons.remove(at: index)
        
        selectedButton.backgroundColor = .systemBlue
        selectedButton.setTitleColor(.white, for: .normal)
        buttons.forEach {
            $0.tag = 0
            $0.backgroundColor = .systemGray6
            $0.setTitleColor(.label, for: .normal)
        }
        
        switch selectedButton {
        case recordEntryView.directInputButton:
            recordEntryView.directInputTextField.isEnabled = true
            recordEntryView.shotButton.isEnabled = true
            recordEntryView.mgButton.isEnabled = true
            recordEntryView.intakeInputTextField.isEnabled = false
            recordEntryView.shotButton.backgroundColor = .systemGray4
            recordEntryView.mgButton.backgroundColor = .systemGray4
            recordEntryView.intakeInputTextField.text = ""
            
        case recordEntryView.waterIntakeButton,
            recordEntryView.nonCaffeineIntakeButton,
            recordEntryView.milkIntakeButton,
            recordEntryView.teaIntakeButton,
            recordEntryView.anotherIntakeButton:
            recordEntryView.intakeInputTextField.isEnabled = true
            recordEntryView.shotButton.isEnabled = false
            recordEntryView.mgButton.isEnabled = false
            recordEntryView.directInputTextField.isEnabled = false
            recordEntryView.directInputTextField.text = ""
            
        default:
            recordEntryView.directInputTextField.isEnabled = false
            recordEntryView.shotButton.isEnabled = false
            recordEntryView.mgButton.isEnabled = false
            recordEntryView.intakeInputTextField.isEnabled = false
            recordEntryView.directInputTextField.text = ""
            recordEntryView.intakeInputTextField.text = ""
        }
    }
    
    //MARK: Bind
    private func bindAll() {
        bindIntakeButtons()
        bindSohtMgButton()
    }
    
    private func bindIntakeButtons() {
        recordEntryView.oneShotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.oneShotButton)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.twoShotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.twoShotButton)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.threeShotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.threeShotButton)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.fourShotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.fourShotButton)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.directInputButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.directInputButton)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.waterIntakeButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.waterIntakeButton)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.nonCaffeineIntakeButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.nonCaffeineIntakeButton)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.milkIntakeButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.milkIntakeButton)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.teaIntakeButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.teaIntakeButton)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.anotherIntakeButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.recordEntryView else { return }
                self?.changeIntakeButtonsProperty(selectedButton: view.anotherIntakeButton)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSohtMgButton() {
        recordEntryView.shotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.recordEntryView.shotButton.tag = 1
                self?.recordEntryView.mgButton.tag = 0
                self?.recordEntryView.shotButton.backgroundColor = .systemBlue
                self?.recordEntryView.mgButton.backgroundColor = .systemGray4
                self?.recordEntryView.shotButton.setTitleColor(.white, for: .normal)
                self?.recordEntryView.mgButton.setTitleColor(.label, for: .normal)
            })
            .disposed(by: disposeBag)
        
        recordEntryView.mgButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.recordEntryView.shotButton.tag = 0
                self?.recordEntryView.mgButton.tag = 1
                self?.recordEntryView.shotButton.backgroundColor = .systemGray4
                self?.recordEntryView.mgButton.backgroundColor = .systemBlue
                self?.recordEntryView.shotButton.setTitleColor(.label, for: .normal)
                self?.recordEntryView.mgButton.setTitleColor(.white, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
