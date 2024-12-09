//
//  NotificationViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 12/9/24.
//

import Foundation
import UIKit
import RxSwift

final class NotificationViewController: UIViewController {
    private let notificationView = NotificationView()
    private let notificationViewModel: NotificationViewModel
    private let disposeBag = DisposeBag()
    
    init( viewModel: NotificationViewModel = NotificationViewModel()) {
        self.notificationViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.notificationViewModel.fetchUserInformation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNotificationViewController()
        setLayoutConstraint()
        addNotificationStatusUpdate()
        bindAll()
    }
}

extension NotificationViewController {
    //MARK: Configure
    private func configureNotificationViewController() {
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        self.sheetPresentationController?.detents = [.medium()]
        self.sheetPresentationController?.prefersGrabberVisible = true
        self.sheetPresentationController?.preferredCornerRadius = 24.0
        view.addSubview(notificationView)
        view.backgroundColor = .systemBackground
    }
    
    //MARK: Set Layout Constraint
    private func setLayoutConstraint() {
        NSLayoutConstraint.activate([
            notificationView.topAnchor.constraint(equalTo: view.topAnchor),
            notificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
    
    private func addNotificationStatusUpdate() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationStatus), name: NSNotification.Name(NotificationCenterName.updateNotificationStatus.rawValue), object: nil)
    }
    
    @objc private func updateNotificationStatus() {
        notificationViewModel.fetchUserInformation()
    }
    
    private func bindAll() {
        bindNotificationSetSubject()
        bindNotificationTimeUpdateButton()
        bindNotificationStatusButton()
        bindChangedNotificationStatusSubject()
        bindNotificationWillEnterForegroundNotification()
    }
    
    private func bindNotificationSetSubject() {
        notificationViewModel.notificationSetSubject
            .asDriver(onErrorJustReturn: (enabled: false, notificationTime: Date(), authorizationStatus: false))
            .drive(onNext: {[weak self] notificationSetSubject in
                self?.notificationView.configureAttributes(notificationSetSubject.enabled, notificationSetSubject.notificationTime, notificationSetSubject.authorizationStatus)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNotificationTimeUpdateButton() {
        notificationView.notificationTimeUpdateButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let notificationTime = self?.notificationView.datePicker.date,
                      let notificationStatus = self?.notificationView.notificationStatusUpdateButton.isSelected else { return }
                self?.notificationViewModel.changeNotificationTime(notificationStatus, notificationTime)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindNotificationStatusButton() {
        notificationView.notificationStatusUpdateButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                switch self?.notificationView.notificationStatusUpdateButton.tag {
                case 1:
                    self?.notificationViewModel.postNotificationCenter()
                    if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(appSettingsURL) {
                            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                        }
                    } else { return }
                case 0:
                    guard let timeDate = self?.notificationView.datePicker.date,
                          let notificationStatus = self?.notificationView.notificationStatusUpdateButton.isSelected else { return }
                    self?.notificationViewModel.changeNotificationStatus(!notificationStatus, timeDate)
                default: return 
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChangedNotificationStatusSubject() {
        notificationViewModel.changedNotificationStatusSubject
            .subscribe(onNext: {[weak self] changedNotificationStatusSubject in
                guard changedNotificationStatusSubject else {
                    self?.doneAlert(title: "알림 변경", message: "변경에 실패했어요. 잠시 후에 시도해 주세요.")
                    return
                }
                self?.doneAlert(title: "알림 변경", message: "변경이 완료되었어요.")
                self?.notificationViewModel.fetchUserInformation()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNotificationWillEnterForegroundNotification() {
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .asDriver(onErrorRecover: { _ in .never()})
            .drive(onNext: {[weak self] _ in
                self?.notificationViewModel.checkNotificationStatus()
            })
            .disposed(by: disposeBag)
    }
}
