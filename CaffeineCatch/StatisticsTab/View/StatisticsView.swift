//
//  StatisticsView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/26/24.
//

import UIKit
//import Charts
import DGCharts

final class StatisticsView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "📊 이번 달 나의 섭취 기록 통계"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    private let caffeineStatisticsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나의 카페인 섭취 기록"
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        return label
    }()
    
    private let nonCaffeineStatisticsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나의 논카페인 섭취 기록"
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        return label
    }()
    
    private let waterStatisticsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나의 물 섭취 기록"
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        return label
    }()
    
    private let caffeineDatasLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 shot (150mg)"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    let nonCaffenineInTakeCollecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CaffeineIntakeCollectionViewCell.self, forCellWithReuseIdentifier: CaffeineIntakeCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private let waterDatasLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "물 300mL"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    private let pieChartView: PieChartView = {
        let pieChartView = PieChartView()
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        let entries = [
            PieChartDataEntry(value: 100.0, label: "테스트")
        ]
        let dataSet = PieChartDataSet(entries: entries, label: "섭취 기록 통계")
        dataSet.colors = ChartColorTemplates.pastel()
        pieChartView.data = PieChartData(dataSet: dataSet)
        return pieChartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatisticsView {
    private func addSubviews() {
        [
            titleLabel,
            caffeineStatisticsLabel,
            caffeineDatasLabel,
            nonCaffeineStatisticsLabel,
            nonCaffenineInTakeCollecionView,
            waterStatisticsLabel,
            waterDatasLabel,
            pieChartView
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            caffeineStatisticsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36.0),
            caffeineStatisticsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            caffeineStatisticsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            caffeineStatisticsLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            caffeineDatasLabel.topAnchor.constraint(equalTo: caffeineStatisticsLabel.bottomAnchor, constant: 12.0),
            caffeineDatasLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 36.0),
            caffeineDatasLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -36.0),
            caffeineDatasLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            nonCaffeineStatisticsLabel.topAnchor.constraint(equalTo: caffeineDatasLabel.bottomAnchor, constant: 36.0),
            nonCaffeineStatisticsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nonCaffeineStatisticsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            nonCaffeineStatisticsLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            nonCaffenineInTakeCollecionView.topAnchor.constraint(equalTo: nonCaffeineStatisticsLabel.bottomAnchor, constant: 12.0),
            nonCaffenineInTakeCollecionView.leadingAnchor.constraint(equalTo: caffeineDatasLabel.leadingAnchor),
            nonCaffenineInTakeCollecionView.trailingAnchor.constraint(equalTo: caffeineDatasLabel.trailingAnchor),
            nonCaffenineInTakeCollecionView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            waterStatisticsLabel.topAnchor.constraint(equalTo: nonCaffenineInTakeCollecionView.bottomAnchor, constant: 36.0),
            waterStatisticsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            waterStatisticsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            waterStatisticsLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            waterDatasLabel.topAnchor.constraint(equalTo: waterStatisticsLabel.bottomAnchor, constant: 12.0),
            waterDatasLabel.leadingAnchor.constraint(equalTo: caffeineDatasLabel.leadingAnchor),
            waterDatasLabel.trailingAnchor.constraint(equalTo: caffeineDatasLabel.trailingAnchor),
            waterDatasLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            pieChartView.topAnchor.constraint(equalTo: waterDatasLabel.bottomAnchor, constant: 24.0),
            pieChartView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            pieChartView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24.0)
        ])
    }
    
    func configureLabel(caffeine: String, water: String) {
        caffeineDatasLabel.text = caffeine
        waterDatasLabel.text = water
    }
    
    func configurePieCharts(_ caffeine: Int, _ water: Int, _ nonCaffeine: Int) {
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        let entries = [
            PieChartDataEntry(value: Double(caffeine), label: "카페인"),
            PieChartDataEntry(value: Double(water), label: "물"),
            PieChartDataEntry(value: Double(nonCaffeine), label: "논카페인")
        ]
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = [
            UIColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 0.8),  // 파란색
            UIColor(red: 245 / 255, green: 166 / 255, blue: 35 / 255, alpha: 0.8),  // 주황색
            UIColor(red: 126 / 255, green: 211 / 255, blue: 33 / 255, alpha: 0.8)   // 초록색
            ]
        pieChartView.data = PieChartData(dataSet: dataSet)
    }
}
