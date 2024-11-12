//
//  FirstRunGoalCaffeineIntakeView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import UIKit

final class FirstRunGoalCaffeineIntakeView: UIView {
    let recommandLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "회원님의 카페인 섭취량을 기반으로 \n 회원님의 목표 섭취량을\n1 shot (75mg) 이하로 추천해요."
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center

        return label
    }()
    
    let recommandButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("추천받은 섭취량으로 목표 설정할게요.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    let directInputButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("직접 설정할래요.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    let directInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "목표 섭취량"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10.0
        textField.isEnabled = false
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let shotButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("shot", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        return button
    }()
    
    let mgButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("mg", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.backgroundColor = .lightGray
        return button
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

extension FirstRunGoalCaffeineIntakeView {
    private func addSubviews() {
        [
            recommandLabel,
            recommandButton,
            directInputButton,
            directInputTextField,
            shotButton,
            mgButton
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            recommandLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60.0),
            recommandLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            recommandLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            
            recommandButton.topAnchor.constraint(equalTo: recommandLabel.bottomAnchor, constant: 24.0),
            recommandButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 48.0),
            recommandButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -48.0),
            recommandButton.heightAnchor.constraint(equalToConstant: 50.0),
            
            directInputButton.topAnchor.constraint(equalTo: recommandButton.bottomAnchor, constant: 12.0),
            directInputButton.leadingAnchor.constraint(equalTo: recommandButton.leadingAnchor),
            directInputButton.trailingAnchor.constraint(equalTo: recommandButton.centerXAnchor),
            directInputButton.heightAnchor.constraint(equalTo: recommandButton.heightAnchor),
            
            directInputTextField.topAnchor.constraint(equalTo: directInputButton.topAnchor),
            directInputTextField.leadingAnchor.constraint(equalTo: directInputButton.trailingAnchor, constant: 8.0),
            directInputTextField.trailingAnchor.constraint(equalTo: recommandButton.trailingAnchor),
            directInputTextField.heightAnchor.constraint(equalTo: directInputButton.heightAnchor),
            
            shotButton.topAnchor.constraint(equalTo: directInputTextField.bottomAnchor, constant: 5.0),
            shotButton.leadingAnchor.constraint(equalTo: directInputTextField.leadingAnchor),
            shotButton.trailingAnchor.constraint(equalTo: directInputTextField.centerXAnchor, constant: -5.0),
            shotButton.heightAnchor.constraint(equalTo: recommandButton.heightAnchor),
            
            mgButton.topAnchor.constraint(equalTo: shotButton.topAnchor),
            mgButton.leadingAnchor.constraint(equalTo: directInputTextField.centerXAnchor, constant: 5.0),
            mgButton.trailingAnchor.constraint(equalTo: directInputTextField.trailingAnchor),
            mgButton.heightAnchor.constraint(equalTo: recommandButton.heightAnchor),
            mgButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -120.0)
        ])
    }
}
