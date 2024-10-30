//
//  MyPageView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import UIKit

final class MyGoalView: UIView {
    
    private let goalSettingView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor(red: 164/255, green: 178/255, blue: 244/255, alpha: 1.0)
        view.image = UIImage(systemName: "cup.and.saucer.fill")
        return view
    }()
    
    private let goalSettingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.numberOfLines = 0
        label.text = "나의 하루 카페인 섭취량\n목표는 2shot 이하예요. ✊🏻"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let goalUpdateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("목표 수정하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    private let recommandedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13.0)
        label.numberOfLines = 0
        label.text = "식약처가 권고하는 1일 카페인 섭취량은 \n몸무게 60kg 기준 성인은 400mg, 청소년은 150mg 이하예요."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let averageCaffeineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15.0, weight: .semibold)
        label.text = "식품별 평균 카페인 함유량"
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let averageCaffeineCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AverageCaffeineCollectionViewCell.self, forCellWithReuseIdentifier: AverageCaffeineCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
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

extension MyGoalView {
    private func addSubviews() {
        goalSettingView.addSubview(goalSettingLabel)
        [
            goalSettingView,
            goalUpdateButton,
            recommandedLabel,
            averageCaffeineLabel,
            averageCaffeineCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            goalSettingView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            goalSettingView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            goalSettingView.widthAnchor.constraint(equalToConstant: 340.0),
            goalSettingView.heightAnchor.constraint(equalToConstant: 240.0),
            
            goalSettingLabel.centerXAnchor.constraint(equalTo: goalSettingView.centerXAnchor),
            goalSettingLabel.centerYAnchor.constraint(equalTo: goalSettingView.centerYAnchor),
            goalSettingLabel.widthAnchor.constraint(equalTo: goalSettingView.widthAnchor),
            goalSettingLabel.heightAnchor.constraint(equalTo: goalSettingView.heightAnchor),
            
            goalUpdateButton.topAnchor.constraint(equalTo: goalSettingView.bottomAnchor, constant: 12.0),
            goalUpdateButton.centerXAnchor.constraint(equalTo: goalSettingView.centerXAnchor),
            goalUpdateButton.widthAnchor.constraint(equalToConstant: 120.0),
            goalUpdateButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            recommandedLabel.topAnchor.constraint(equalTo: goalUpdateButton.bottomAnchor, constant: 4.0),
            recommandedLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            recommandedLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            recommandedLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
//            goalSettingTextField.topAnchor.constraint(equalTo: goalSettingLabel.topAnchor),
//            goalSettingTextField.leadingAnchor.constraint(equalTo: goalSettingLabel.trailingAnchor, constant: 8.0),
//            goalSettingTextField.widthAnchor.constraint(equalToConstant: 120.0),
//            goalSettingTextField.heightAnchor.constraint(equalTo: goalSettingLabel.heightAnchor),
//            
//            goalSettingButton.topAnchor.constraint(equalTo: goalSettingLabel.topAnchor),
//            goalSettingButton.leadingAnchor.constraint(equalTo: goalSettingTextField.trailingAnchor, constant: 12.0),
//            goalSettingButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//            goalSettingButton.heightAnchor.constraint(equalTo: goalSettingLabel.heightAnchor),
            
            averageCaffeineLabel.topAnchor.constraint(equalTo: recommandedLabel.bottomAnchor, constant: 24.0),
            averageCaffeineLabel.leadingAnchor.constraint(equalTo: recommandedLabel.leadingAnchor),
            averageCaffeineLabel.trailingAnchor.constraint(equalTo: recommandedLabel.trailingAnchor),
            averageCaffeineLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            averageCaffeineCollectionView.topAnchor.constraint(equalTo: averageCaffeineLabel.bottomAnchor),
            averageCaffeineCollectionView.leadingAnchor.constraint(equalTo: recommandedLabel.leadingAnchor),
            averageCaffeineCollectionView.trailingAnchor.constraint(equalTo: recommandedLabel.trailingAnchor),
            averageCaffeineCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
