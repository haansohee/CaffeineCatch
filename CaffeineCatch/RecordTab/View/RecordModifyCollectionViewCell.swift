//
//  RecordModifyCollectionViewCell.swift
//  CaffeineCatch
//
//  Created by 한소희 on 12/9/24.
//

import UIKit
import RxSwift

final class RecordModifyCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    var disposeBag = DisposeBag()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2024-12-09"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        return label
    }()
    
    private let intakeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "물 200 mL"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()
    
    let deleteButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .semibold)
        button.layer.cornerRadius = 10.0
        return  button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubivews()
        setLayoutConstraints()
        contentView.layer.cornerRadius = 12.0
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecordModifyCollectionViewCell {
    private func addSubivews() {
        [
            dateLabel,
            intakeLabel,
            deleteButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            intakeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5.0),
            intakeLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            intakeLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
            
            deleteButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            deleteButton.widthAnchor.constraint(equalToConstant: 80.0),
            deleteButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
    
    func configureCell(_ intake: String, _ date: String, _ isExisted: Bool) {
        if isExisted {
            deleteButton.isHidden = false
            intakeLabel.text = intake
            dateLabel.text = date
        } else {
            deleteButton.isHidden = true
            intakeLabel.text = "기록이 없어요."
            dateLabel.text = ""
        }
    }
}
