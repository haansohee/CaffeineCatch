//
//  TutorialGoalCaffeineIntakeView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import UIKit

final class TutorialGoalCaffeineIntakeView: UIView {
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
        textField.placeholder = " 목표 섭취량"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10.0
        textField.isEnabled = false
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0
        return stackView
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
    
    let waterButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("물(mL)", for: .normal)
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

extension TutorialGoalCaffeineIntakeView {
    private func addSubviews() {
        [
            shotButton,
            mgButton,
            waterButton
        ].forEach { buttonStackView.addArrangedSubview($0) }
        [
            recommandLabel,
            recommandButton,
            directInputButton,
            directInputTextField,
            buttonStackView
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            recommandLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40.0),
            recommandLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            recommandLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            
            recommandButton.topAnchor.constraint(equalTo: recommandLabel.bottomAnchor, constant: 24.0),
            recommandButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 48.0),
            recommandButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -48.0),
            recommandButton.heightAnchor.constraint(equalToConstant: 50.0),
            
            directInputButton.topAnchor.constraint(equalTo: recommandButton.bottomAnchor, constant: 12.0),
            directInputButton.leadingAnchor.constraint(equalTo: recommandButton.leadingAnchor),
            directInputButton.widthAnchor.constraint(equalToConstant: 120.0),
            directInputButton.heightAnchor.constraint(equalTo: recommandButton.heightAnchor),
            
            directInputTextField.topAnchor.constraint(equalTo: directInputButton.topAnchor),
            directInputTextField.leadingAnchor.constraint(equalTo: directInputButton.trailingAnchor, constant: 8.0),
            directInputTextField.trailingAnchor.constraint(equalTo: recommandButton.trailingAnchor),
            directInputTextField.heightAnchor.constraint(equalTo: directInputButton.heightAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: directInputTextField.bottomAnchor, constant: 5.0),
            buttonStackView.leadingAnchor.constraint(equalTo: directInputTextField.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: directInputTextField.trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalTo: recommandButton.heightAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -60.0)
        ])
    }
}
