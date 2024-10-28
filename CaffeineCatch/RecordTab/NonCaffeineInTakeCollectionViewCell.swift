//
//  NonCaffeineInTakeCollectionViewCell.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/22/24.
//

import UIKit

final class NonCaffeineInTakeCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureNonCaffeineInTakeCollectionViewCell()
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NonCaffeineInTakeCollectionViewCell {
    private func configureNonCaffeineInTakeCollectionViewCell() {
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 12.0
    }
    
    private func addSubviews() {
        contentView.addSubview(label)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 6.0),
            label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 6.0),
            label.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -6.0),
            label.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -6.0)
        ])
    }
}
