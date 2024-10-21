//
//  MyPageView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import UIKit

final class MyGoalView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.numberOfLines = 0
        label.text = "🎯 목표로 하는 카페인 섭취량을 설정해 봐요!"
        label.textColor = .label
        return label
    }()
    
    private let goalSettingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        label.text = "목표 카페인 섭취량: "
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let goalSettingTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "mg"
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 6.0
        textField.font = .systemFont(ofSize: 12.0)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let goalSettingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("설정하기", for: .normal)
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
        label.textAlignment = .left
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
        [
            titleLabel,
            goalSettingLabel,
            goalSettingTextField,
            goalSettingButton,
            recommandedLabel,
            averageCaffeineLabel,
            averageCaffeineCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            recommandedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            recommandedLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            recommandedLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            recommandedLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            goalSettingLabel.topAnchor.constraint(equalTo: recommandedLabel.bottomAnchor, constant: 24.0),
            goalSettingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            goalSettingLabel.widthAnchor.constraint(equalToConstant: 110.0),
            goalSettingLabel.heightAnchor.constraint(equalToConstant: 34.0),
            
            goalSettingTextField.topAnchor.constraint(equalTo: goalSettingLabel.topAnchor),
            goalSettingTextField.leadingAnchor.constraint(equalTo: goalSettingLabel.trailingAnchor, constant: 8.0),
            goalSettingTextField.widthAnchor.constraint(equalToConstant: 120.0),
            goalSettingTextField.heightAnchor.constraint(equalTo: goalSettingLabel.heightAnchor),
            
            goalSettingButton.topAnchor.constraint(equalTo: goalSettingLabel.topAnchor),
            goalSettingButton.leadingAnchor.constraint(equalTo: goalSettingTextField.trailingAnchor, constant: 12.0),
            goalSettingButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            goalSettingButton.heightAnchor.constraint(equalTo: goalSettingLabel.heightAnchor),
            
            averageCaffeineLabel.topAnchor.constraint(equalTo: goalSettingLabel.bottomAnchor, constant: 24.0),
            averageCaffeineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            averageCaffeineLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            averageCaffeineLabel.heightAnchor.constraint(equalTo: goalSettingLabel.heightAnchor),
            
            averageCaffeineCollectionView.topAnchor.constraint(equalTo: averageCaffeineLabel.bottomAnchor),
            averageCaffeineCollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            averageCaffeineCollectionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            averageCaffeineCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
