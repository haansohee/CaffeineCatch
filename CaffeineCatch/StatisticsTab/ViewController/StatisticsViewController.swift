//
//  StatisticsViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/26/24.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statisticsViewModel.fetchCaffeineInfo()
    }
}

extension StatisticsViewController {
    private func configureStatisticsViewController() {
        statisticsView.translatesAutoresizingMaskIntoConstraints = false
        statisticsView.nonCaffenineInTakeCollecionView.delegate = self
        view.addSubview(statisticsView)
        view.backgroundColor = .systemBackground
        navigationItem.title = "이번 달 통계"
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
    
    //MARK: Create CollectionView DataSource
    private func createCollecitonViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionOfInTakeNonCaffeineData> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfInTakeNonCaffeineData>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaffeineIntakeCollectionViewCell.reuseIdentifier, for: indexPath) as? CaffeineIntakeCollectionViewCell else {
                    return UICollectionViewCell() }
                cell.label.font = .systemFont(ofSize: 12.0, weight: .light)
                let labelText = item.intake == 0 ? "기록이 없어요." : "\(item.category) \(item.intake) \(item.unit)"
                cell.label.text = labelText
                return cell
            })
        return dataSource
    }
    
    // MARK: Bind
    private func bind() {
        bindNonCaffeineInTakeCollectionViewSection()
        bindCaffeineInfoSubject()
    }
    
    private func bindNonCaffeineInTakeCollectionViewSection() {
        statisticsViewModel.nonCaffeineSectionData
            .bind(to: statisticsView.nonCaffenineInTakeCollecionView.rx.items(dataSource: createCollecitonViewDataSource())
            )
            .disposed(by: disposeBag)
    }
    
    private func bindCaffeineInfoSubject() {
        statisticsViewModel.caffeineInfoSubject
            .asDriver(onErrorJustReturn: (caffeine: 0, water: 0, nonCaffeine: 0))
            .drive(onNext: {[weak self] subject in
                let caffeineText = subject.caffeine == 0 ? "기록이 없어요." : "\(subject.caffeine) shot"
                let waterText = subject.water == 0 ? "기록이 없어요." : "\(subject.water) mL"
                self?.statisticsView.configureLabel(caffeine: caffeineText, water: waterText)
                self?.statisticsView.configurePieCharts(subject.caffeine, subject.water, subject.nonCaffeine)
            })
            .disposed(by: disposeBag)
    }
}

extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width / 2.0) - 20.0, height: (collectionView.bounds.size.height))
    }
}
