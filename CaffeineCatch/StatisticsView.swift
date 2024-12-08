//
//  StatisticsView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/26/24.
//

import UIKit

final class StatisticsView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이번 달 나의 섭취 기록 통계예요. 📊"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
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
    
    private let nonCaffeineDatasLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "우유 150mL"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chart.pie.fill")
        imageView.tintColor = .lightGray
        return imageView
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
            nonCaffeineDatasLabel,
            waterStatisticsLabel,
            waterDatasLabel,
            imageView
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
            
            nonCaffeineDatasLabel.topAnchor.constraint(equalTo: nonCaffeineStatisticsLabel.bottomAnchor, constant: 12.0),
            nonCaffeineDatasLabel.leadingAnchor.constraint(equalTo: caffeineDatasLabel.leadingAnchor),
            nonCaffeineDatasLabel.trailingAnchor.constraint(equalTo: caffeineDatasLabel.trailingAnchor),
            nonCaffeineDatasLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            waterStatisticsLabel.topAnchor.constraint(equalTo: nonCaffeineDatasLabel.bottomAnchor, constant: 36.0),
            waterStatisticsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            waterStatisticsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            waterStatisticsLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            waterDatasLabel.topAnchor.constraint(equalTo: waterStatisticsLabel.bottomAnchor, constant: 12.0),
            waterDatasLabel.leadingAnchor.constraint(equalTo: caffeineDatasLabel.leadingAnchor),
            waterDatasLabel.trailingAnchor.constraint(equalTo: caffeineDatasLabel.trailingAnchor),
            waterDatasLabel.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            
            imageView.topAnchor.constraint(equalTo: waterDatasLabel.bottomAnchor, constant: 24.0),
            imageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24.0)
        ])
    }
    
    func configureLabel(caffeine: [String?], nonCaffeine: [String?], waters: [String?]) {
        caffeine.forEach {
            guard let text = caffeineDatasLabel.text else { return }
            caffeineDatasLabel.text = "\(text), " + ($0 ?? "")
        }
        
        nonCaffeine.forEach {
            guard let text = nonCaffeineDatasLabel.text else { return }
            nonCaffeineDatasLabel.text = "\(text), " + ($0 ?? "")
        }
        
        waters.forEach {
            guard let text = waterDatasLabel.text else { return }
            waterDatasLabel.text = "\(text), " + ($0 ?? "")
        }
    }
}
