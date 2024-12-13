//
//  SplashViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/18/24.
//

import Foundation
import UIKit
import RxSwift

final class SplashViewController: UIViewController {
    private let splashViewModel: SplashViewModel
    private let disposeBag = DisposeBag()
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cup5.png")
        return imageView
    }()
    
    init(splashViewModel: SplashViewModel = SplashViewModel(
        isTutorialComplete: UserDefaults.standard.bool(forKey: UserDefaultsForKeyName.tutorial.rawValue))) {
            self.splashViewModel = splashViewModel
            super.init(nibName: nil, bundle: nil)
            self.splashViewModel.checkTutorial()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplashViewController()
        setLayoutConstrainst()
        bindTutorialSubject()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SplashViewController {
    private func configureSplashViewController() {
        view.addSubview(splashImageView)
        view.backgroundColor = .systemGray5
    }
    
    private func setLayoutConstrainst() {
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            splashImageView.heightAnchor.constraint(equalToConstant: 300.0),
            splashImageView.widthAnchor.constraint(equalToConstant: 250.0)
        ])
    }
    
    private func bindTutorialSubject() {
        splashViewModel.isTutorialCompleteSubject
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { tutorialSubject in
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                let rootViewController = tutorialSubject ? MainTabBarController() : UINavigationController(rootViewController: TutorialUsualCaffeineIntakeViewController())
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    sceneDelegate.changeRootViewController(rootViewController, animated: true)
                })
            })
            .disposed(by: disposeBag)
    }
}
