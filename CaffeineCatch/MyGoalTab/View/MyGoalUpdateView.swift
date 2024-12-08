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
        textField.placeholder = " 수정할 값을 입력해 주세요."
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
    
    let goalCaffeineUpdateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이하로 수정할게요 ✅", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.5, weight: .semibold)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 12.0
        button.isEnabled = false
        return button
    }()
    
    private let waterTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "제로 카페인 도전! 카페인 대신 물을 섭취해 보세요. 👍"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13.0, weight: .light)
        return label
    }()
    
    let waterInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.placeholder = " 하루에 마실 물의 양"
        textField.backgroundColor = .systemGray5
        textField.textColor = .label
        textField.font = .systemFont(ofSize: 13.0, weight: .semibold)
        textField.layer.cornerRadius = 10.0
        return textField
    }()
    
    let goalWaterUpdateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("mL로 수정할게요 ✅", for: .normal)
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
            goalCaffeineUpdateButton,
            waterTitleLabel,
            waterInputTextField,
            goalWaterUpdateButton,
            descriptionLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            mgButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 120.0),
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
            
            goalCaffeineUpdateButton.topAnchor.constraint(equalTo: valueInputTextField.bottomAnchor, constant: 24.0),
            goalCaffeineUpdateButton.leadingAnchor.constraint(equalTo: valueInputTextField.leadingAnchor),
            goalCaffeineUpdateButton.trailingAnchor.constraint(equalTo: mgButton.trailingAnchor),
            goalCaffeineUpdateButton.heightAnchor.constraint(equalTo: mgButton.heightAnchor),
            
            waterTitleLabel.topAnchor.constraint(equalTo: goalCaffeineUpdateButton.bottomAnchor, constant: 18.0),
            waterTitleLabel.leadingAnchor.constraint(equalTo: valueInputTextField.leadingAnchor),
            waterTitleLabel.trailingAnchor.constraint(equalTo: mgButton.trailingAnchor),
            waterTitleLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            waterInputTextField.topAnchor.constraint(equalTo: waterTitleLabel.bottomAnchor, constant: 8.0),
            waterInputTextField.leadingAnchor.constraint(equalTo: valueInputTextField.leadingAnchor),
            waterInputTextField.trailingAnchor.constraint(equalTo: valueInputTextField.trailingAnchor),
            waterInputTextField.heightAnchor.constraint(equalTo: valueInputTextField.heightAnchor),
            
            goalWaterUpdateButton.topAnchor.constraint(equalTo: waterInputTextField.topAnchor),
            goalWaterUpdateButton.leadingAnchor.constraint(equalTo: shotButton.leadingAnchor),
            goalWaterUpdateButton.trailingAnchor.constraint(equalTo: mgButton.trailingAnchor),
            goalWaterUpdateButton.heightAnchor.constraint(equalTo: mgButton.heightAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: goalWaterUpdateButton.bottomAnchor, constant: 24.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: goalCaffeineUpdateButton.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: goalCaffeineUpdateButton.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50.0)
//            descriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -48.0)
        ])
    }
}
