//
//  MyGoalUpdateView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/30/24.
//

import UIKit

final class MyGoalUpdateView: UIView {
    let valueInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.placeholder = "수정할 값을 입력해 주세요."
        textField.backgroundColor = .systemGray5
        textField.textColor = .label
        textField.font = .systemFont(ofSize: 13.0, weight: .semibold)
        textField.layer.cornerRadius = 10.0
        return textField
    }()
    
    let shotButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("shot", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .semibold)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 12.0
        button.isEnabled = false
        return button
    }()
    
    let mgButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("mg", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .semibold)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 12.0
        button.isEnabled = false
        button.tag = 0
        return button
    }()
    
    let updateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이하로 수정할게요 ✅", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .semibold)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 12.0
        button.isEnabled = false
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "입력한 목표치는 하루 섭취 가능한 최대 카페인 양으로, 이를 넘지 않도록 주의해야 해요!\n적정 섭취를 통해 건강한 습관을 만들어 보세요. 🍀"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13.0, weight: .light)
        return label
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

extension MyGoalUpdateView {
    private func addSubviews() {
        [
            mgButton,
            shotButton,
            valueInputTextField,
            updateButton,
            descriptionLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            mgButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 48.0),
            mgButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            mgButton.heightAnchor.constraint(equalToConstant: 40.0),
            mgButton.widthAnchor.constraint(equalToConstant: 80.0),
            
            shotButton.topAnchor.constraint(equalTo: mgButton.topAnchor),
            shotButton.trailingAnchor.constraint(equalTo: mgButton.leadingAnchor, constant: -4.0),
            shotButton.heightAnchor.constraint(equalTo: mgButton.heightAnchor),
            shotButton.widthAnchor.constraint(equalTo: mgButton.widthAnchor),
            
            valueInputTextField.topAnchor.constraint(equalTo: shotButton.topAnchor),
            valueInputTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            valueInputTextField.trailingAnchor.constraint(equalTo: shotButton.leadingAnchor, constant: -8.0),
            valueInputTextField.heightAnchor.constraint(equalTo: mgButton.heightAnchor),
            
            updateButton.topAnchor.constraint(equalTo: valueInputTextField.bottomAnchor, constant: 24.0),
            updateButton.leadingAnchor.constraint(equalTo: valueInputTextField.leadingAnchor),
            updateButton.trailingAnchor.constraint(equalTo: mgButton.trailingAnchor),
            updateButton.heightAnchor.constraint(equalTo: mgButton.heightAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 24.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: updateButton.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: updateButton.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -48.0)
        ])
    }
}
