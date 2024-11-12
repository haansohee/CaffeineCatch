//
//  FirstRunUsualCaffeineIntakeViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import Foundation
import UIKit
import RxSwift

final class FirstRunUsualCaffeineIntakeViewController: UIViewController {
    private let firstRunUsualCaffeineIntakeView = FirstRunUsualCaffeineIntakeView()
    private let firstRunViewModel: FirstRunViewModel
    private let nextButton = NextButton()
    private let disposeBag = DisposeBag()
    
    init(viewModel: FirstRunViewModel = FirstRunViewModel()) {
        self.firstRunViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
//        self.firstRunViewModel.deleteAllData()
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
        super.viewWillAppear(animated)
        print("usual intake view will appear")
    }
}

extension FirstRunUsualCaffeineIntakeViewController {
    // MARK: Configure
    private func configureFirstRunUsualCaffeineIntakeView() {
        firstRunUsualCaffeineIntakeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstRunUsualCaffeineIntakeView)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
    }
    
    // MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            firstRunUsualCaffeineIntakeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            firstRunUsualCaffeineIntakeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            firstRunUsualCaffeineIntakeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            firstRunUsualCaffeineIntakeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func changeShotButtonsProperty(selectedButton: IntakeButton) {
        var buttons = [
            firstRunUsualCaffeineIntakeView.twoShotOrLessButton,
            firstRunUsualCaffeineIntakeView.twoShotButton,
            firstRunUsualCaffeineIntakeView.threeShotButton,
            firstRunUsualCaffeineIntakeView.fourShotOrMoreButton
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
        firstRunUsualCaffeineIntakeView.twoShotOrLessButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunUsualCaffeineIntakeView else { return }
                self?.changeShotButtonsProperty(selectedButton: view.twoShotOrLessButton)
            })
            .disposed(by: disposeBag)
        
        firstRunUsualCaffeineIntakeView.twoShotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunUsualCaffeineIntakeView else { return }
                self?.changeShotButtonsProperty(selectedButton: view.twoShotButton)
            })
            .disposed(by: disposeBag)
        
        firstRunUsualCaffeineIntakeView.threeShotButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunUsualCaffeineIntakeView else { return }
                self?.changeShotButtonsProperty(selectedButton: view.threeShotButton)
            })
            .disposed(by: disposeBag)
        
        firstRunUsualCaffeineIntakeView.fourShotOrMoreButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunUsualCaffeineIntakeView else { return }
                self?.changeShotButtonsProperty(selectedButton: view.fourShotOrMoreButton)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNextButton() {
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let view = self?.firstRunUsualCaffeineIntakeView else { return }
                let buttons = [
                    view.twoShotOrLessButton,
                    view.twoShotButton,
                    view.threeShotButton,
                    view.fourShotOrMoreButton
                ].filter { $0.isSelected }
                guard let selectedButton = buttons.first else { return }  // 선택해야해욧!! 선택해야 보이는 버튼이지만. 쩄뜬. 에러 처리 담곰씨
                print("selectedButton: \(selectedButton.titleLabel?.text)")
                switch selectedButton {
                case view.twoShotOrLessButton:
                    self?.firstRunViewModel.saveUsualCaffeineIntake(Caffeine.oneShot.rawValue)
                    return
                case view.twoShotButton:
                    self?.firstRunViewModel.saveUsualCaffeineIntake(Caffeine.twoShot.rawValue)
                    return
                case view.threeShotButton:
                    self?.firstRunViewModel.saveUsualCaffeineIntake(Caffeine.threeShot.rawValue)
                    return
                case view.fourShotOrMoreButton:
                    self?.firstRunViewModel.saveUsualCaffeineIntake(Caffeine.fourShot.rawValue)
                    return
                default: return
                }
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
                self?.navigationController?.pushViewController(FirstRunGoalCaffeineIntakeViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
