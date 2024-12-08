//
//  StatisticsViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/26/24.
//

import Foundation
import UIKit
import RxSwift

final class StatisticsViewController: UIViewController {
    private let statisticsView = StatisticsView()
    private let statisticsViewModel: StatisticsViewModel
    private let disposeBag = DisposeBag()
    
    init(statisticsViewModel: StatisticsViewModel = StatisticsViewModel()) {
        self.statisticsViewModel = statisticsViewModel
        super.init(nibName: nil, bundle: nil)
        statisticsViewModel.fetchCaffeineInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStatisticsViewController()
        setLayoutConstraints()
        bind()
        
    }
}

extension StatisticsViewController {
    private func configureStatisticsViewController() {
        statisticsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statisticsView)
        view.backgroundColor = .systemBackground
    }
    
    //MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            statisticsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statisticsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            statisticsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            statisticsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Bind
    private func bind() {
//        statisticsViewModel.caffeineInfoSubject
//            .asDriver(onErrorJustReturn: false)
//            .drive(onNext: {[weak self] caffeineInfoSubject in
//                guard caffeineInfoSubject else {
//                    print("no caffeineInfoSubject")
//                    return
//                }
//                print("ddd")
//                print(self?.statisticsViewModel.caffeineInfoDatas)
//            })
//            .disposed(by: disposeBag)
//        statisticsViewModel.testSubject
//            .asDriver(onErrorJustReturn: [])
//            .drive(onNext: {[weak self] testSubject in
//            })
//            .disposed(by: disposeBag)
    }
}
