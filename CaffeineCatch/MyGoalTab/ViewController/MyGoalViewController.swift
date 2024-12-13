//
//  MyPageViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

final class MyGoalViewController: UIViewController {
    private let myGoalView = MyGoalView()
    private let myGoalViewModel: MyGoalViewModel
    private let notificationViewModel: NotificationViewModel
    private let disposeBag = DisposeBag()
    
    init(myPageViewModel: MyGoalViewModel = MyGoalViewModel(),
         notificationViewModel: NotificationViewModel = NotificationViewModel()) {
        self.myGoalViewModel = myPageViewModel
        self.notificationViewModel = notificationViewModel
        super.init(nibName: nil, bundle: nil)
        self.myGoalViewModel.loadSectionData()
        self.myGoalViewModel.fetchMyGoalCaffeineIntake()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManaged.shared.setAuthorization()
        configureMyPageViewController()
        setLayoutConstraints()
        addNotificationUpdateMyGoalCaffeineIntake()
        bindAll()
    }
}

extension MyGoalViewController {
    //MARK: Configure
    private func configureMyPageViewController() {
        myGoalView.translatesAutoresizingMaskIntoConstraints = false
        myGoalView.averageCaffeineCollectionView.delegate = self
        navigationItem.title = "목표"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: myGoalView.notificationButton)
        view.addSubview(myGoalView)
        view.backgroundColor = .secondarySystemBackground
    }
    
    //MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            myGoalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myGoalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myGoalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            myGoalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Create CollectionView DataSource
    private func createCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionOfAverageCaffeineData>{
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfAverageCaffeineData>(configureCell: {dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AverageCaffeineCollectionViewCell.reuseIdentifier, for: indexPath) as? AverageCaffeineCollectionViewCell else { return UICollectionViewCell() }
            cell.configureAverageCaffeineLabel(item.caffeineData, item.mgData)
            return cell
        })
        return dataSource
    }
    
    // MARK: NotificationCenter
    private func addNotificationUpdateMyGoalCaffeineIntake() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyGoalCaffeineIntake), name: NSNotification.Name(NotificationCenterName.UpdateGoalCaffeineIntake.rawValue), object: nil)
    }
    
    @objc private func updateMyGoalCaffeineIntake() {
        myGoalViewModel.fetchMyGoalCaffeineIntake()
    }
    
    //MARK: Bind
    private func bindAll() {
        bindAverageCaffeineCollectionViewSection()
        bindMyGoalCaffeineIntakeSubject()
        bindNotificationButton()
        bindGoalUpdateButton()
    }
    
    private func bindNotificationButton() {
        myGoalView.notificationButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.present(NotificationViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAverageCaffeineCollectionViewSection() {
        myGoalViewModel.averageCaffeineSectionData
            .bind(to: myGoalView.averageCaffeineCollectionView.rx.items(dataSource: createCollectionViewDataSource()))
            .disposed(by: disposeBag)
    }
    
    private func bindMyGoalCaffeineIntakeSubject() {
        myGoalViewModel.userInfoSubject
            .asDriver(onErrorJustReturn: ("0", false))
            .drive(onNext: {[ weak self] userInfoSubject in
                let goalIntake = userInfoSubject.intakeValue
                let isZeroCaffeine = userInfoSubject.isZeroCaffeineUser
                let fullText = isZeroCaffeine ? "제로 카페인! 나의 목표는\n\(goalIntake) 마시기예요" : "나의 하루 카페인 섭취량 목표는\n\n\(goalIntake) 이하예요."
                let attributedText = NSMutableAttributedString(string: fullText)
                let range = (fullText as NSString).range(of: goalIntake)
                attributedText.addAttribute(.foregroundColor, value: UIColor(red: 255/255, green: 107/255, blue: 0/255, alpha: 1.0), range: range)
                self?.myGoalView.goalSettingLabel.attributedText = attributedText
            })
            .disposed(by: disposeBag)
    }
    
    private func bindGoalUpdateButton() {
        myGoalView.goalUpdateButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.present(MyGoalUpdateViewCotnroller(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: CollectionView Delegate
extension MyGoalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.size.width - 20) / 3
        return CGSize(width: size, height: size)
    }
}
