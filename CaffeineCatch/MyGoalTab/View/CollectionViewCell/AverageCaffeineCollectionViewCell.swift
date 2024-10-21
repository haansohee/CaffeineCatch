//
//  AverageCaffeineCollectionViewCell.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import UIKit

final class AverageCaffeineCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    private let caffeineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstratins()
        configureAverageCaffeineCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AverageCaffeineCollectionViewCell {
    private func addSubviews() {
        [
            nameLabel,
            caffeineLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstratins() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            nameLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            caffeineLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4.0),
            caffeineLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            caffeineLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            caffeineLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureAverageCaffeineCollectionViewCell() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 24.0
        contentView.backgroundColor = .systemBackground
    }
    
    func configureAverageCaffeineLabel(_ name: String, _ caffeine: String) {
        nameLabel.text = name
        caffeineLabel.text = caffeine
    }
}
