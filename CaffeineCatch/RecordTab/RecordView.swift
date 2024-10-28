//
//  RecordView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/21/24.
//

import UIKit

final class RecordView: UIView {
    private let caffeineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5.0
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        return stackView
    }()
    
    private let caffeineInTakeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "☕️ 카페인 섭취량이에요"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        return label
    }()
    
    private let caffeineInTakeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2shot (150mg)"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()
    
    private let nonCaffeineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5.0
        return stackView
    }()
    
    private let nonCaffeineInTakeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "🥛 카페인 대신 섭취했어요"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        return label
    }()

    let nonCaffenineInTakeCollecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NonCaffeineInTakeCollectionViewCell.self, forCellWithReuseIdentifier: NonCaffeineInTakeCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureRecordView()
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecordView {
    private func configureRecordView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 24.0
    }
    
    private func addSubviews() {
        [ caffeineInTakeTitleLabel, caffeineInTakeLabel ].forEach { caffeineStackView.addArrangedSubview($0) }
        [ nonCaffeineInTakeTitleLabel, nonCaffenineInTakeCollecionView ].forEach { nonCaffeineStackView.addArrangedSubview($0) }
        [ caffeineStackView, nonCaffeineStackView ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            caffeineStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            caffeineStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            caffeineStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            caffeineStackView.heightAnchor.constraint(equalToConstant: 80.0),
            
            
            nonCaffeineStackView.topAnchor.constraint(equalTo: caffeineStackView.bottomAnchor, constant: 52.0),
            nonCaffeineStackView.leadingAnchor.constraint(equalTo: caffeineStackView.leadingAnchor),
            nonCaffeineStackView.trailingAnchor.constraint(equalTo: caffeineStackView.trailingAnchor),
            nonCaffeineStackView.heightAnchor.constraint(equalToConstant: 120.0),
            
            nonCaffenineInTakeCollecionView.heightAnchor.constraint(equalToConstant: 80.0),
            nonCaffenineInTakeCollecionView.leadingAnchor.constraint(equalTo: nonCaffeineStackView.leadingAnchor),
            nonCaffenineInTakeCollecionView.trailingAnchor.constraint(equalTo: nonCaffeineStackView.trailingAnchor)
        ])
    }
}
