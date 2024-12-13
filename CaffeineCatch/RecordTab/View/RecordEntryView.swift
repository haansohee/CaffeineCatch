//
//  RecordEntryView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/29/24.
//

import UIKit

final class RecordEntryView: UIScrollView {
    let recordSaveButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("저장", for: .normal)
        button.setTitleColor(UIColor(red: 255/255, green: 107/255, blue: 0/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return button
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let intakeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "카페인을 얼마큼 섭취했나요? 👀"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize:24.0, weight: .bold)
        return label
    }()
    
    let myGoalIntakeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나의 하루 목표 섭취량은 150mg(2shot) 이하예요."
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()
    
    let oneShotButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("1 shot (75mg)", for: .normal)
        button.tag = 0
        return button
    }()
    
    let twoShotButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("2 shot (150mg)", for: .normal)
        button.tag = 0
        return button
    }()
    
    let threeShotButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("3 shot (225mg)", for: .normal)
        button.tag = 0
        return button
    }()
    
    let fourShotButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("4 shot (300mg)", for: .normal)
        button.tag = 0
        return button
    }()
    
    let directInputButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("직접 입력", for: .normal)
        button.tag = 0
        return button
    }()
    
    let directInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.textColor = .label
        textField.placeholder = "섭취량을 입력하세요."
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10.0
        textField.font = .systemFont(ofSize: 14.0)
        textField.keyboardType = .numberPad
        textField.isEnabled = false
        return textField
    }()
    
    let shotButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("shot", for: .normal)
        button.isEnabled = false
        button.tag = 0
        return button
    }()
    
    let mgButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("mg", for: .normal)
        button.isEnabled = false
        button.tag = 0
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let nonCaffeineIntakeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "카페인 대신 섭취한 것이 있나요? 🙌🏻"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    let waterIntakeButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle(IntakeCategory.water.rawValue, for: .normal)
        button.layer.cornerRadius = 10.0
        button.tag = 0
        return button
    }()
    
    let nonCaffeineIntakeButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle(IntakeCategory.nonCaffeine.rawValue, for: .normal)
        button.layer.cornerRadius = 10.0
        button.tag = 0
        return button
    }()
    
    let milkIntakeButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle(IntakeCategory.milk.rawValue, for: .normal)
        button.layer.cornerRadius = 10.0
        button.tag = 0
        return button
    }()
    
    let teaIntakeButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle(IntakeCategory.tea.rawValue, for: .normal)
        button.layer.cornerRadius = 10.0
        button.tag = 0
        return button
    }()
    
    let anotherIntakeButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle(IntakeCategory.another.rawValue, for: .normal)
        button.layer.cornerRadius = 10.0
        button.tag = 0
        return button
    }()
    
    let intakeInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.textColor = .label
        textField.placeholder = "mL"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10.0
        textField.font = .systemFont(ofSize: 14.0)
        textField.keyboardType = .numberPad
        textField.isEnabled = false
        return textField
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

extension RecordEntryView {
    private func addSubviews() {
        [
            intakeTitleLabel,
            myGoalIntakeLabel,
            oneShotButton,
            twoShotButton,
            threeShotButton,
            fourShotButton,
            directInputTextField,
            directInputButton,
            shotButton,
            mgButton,
            separatorView,
            nonCaffeineIntakeTitleLabel,
            milkIntakeButton,
            nonCaffeineIntakeButton,
            waterIntakeButton,
            teaIntakeButton,
            anotherIntakeButton,
            intakeInputTextField,
        ].forEach { contentView.addSubview($0) }
        addSubview(contentView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: self.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - 20.0),
            
            
            intakeTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30.0),
            intakeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            intakeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            intakeTitleLabel.heightAnchor.constraint(equalToConstant: 35.0),
            
            myGoalIntakeLabel.topAnchor.constraint(equalTo: intakeTitleLabel.bottomAnchor, constant: 4.0),
            myGoalIntakeLabel.leadingAnchor.constraint(equalTo: intakeTitleLabel.leadingAnchor),
            myGoalIntakeLabel.trailingAnchor.constraint(equalTo: intakeTitleLabel.trailingAnchor),
            myGoalIntakeLabel.heightAnchor.constraint(equalToConstant: 25.0),
            
            oneShotButton.topAnchor.constraint(equalTo: myGoalIntakeLabel.bottomAnchor, constant: 40.0),
            oneShotButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 36.0),
            oneShotButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36.0),
            oneShotButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            twoShotButton.topAnchor.constraint(equalTo: oneShotButton.bottomAnchor, constant: 8.0),
            twoShotButton.leadingAnchor.constraint(equalTo: oneShotButton.leadingAnchor),
            twoShotButton.trailingAnchor.constraint(equalTo: oneShotButton.trailingAnchor),
            twoShotButton.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
            
            threeShotButton.topAnchor.constraint(equalTo: twoShotButton.bottomAnchor, constant: 8.0),
            threeShotButton.leadingAnchor.constraint(equalTo: oneShotButton.leadingAnchor),
            threeShotButton.trailingAnchor.constraint(equalTo: oneShotButton.trailingAnchor),
            threeShotButton.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
            
            fourShotButton.topAnchor.constraint(equalTo: threeShotButton.bottomAnchor, constant: 8.0),
            fourShotButton.leadingAnchor.constraint(equalTo: oneShotButton.leadingAnchor),
            fourShotButton.trailingAnchor.constraint(equalTo: oneShotButton.trailingAnchor),
            fourShotButton.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
            
            directInputTextField.topAnchor.constraint(equalTo: fourShotButton.bottomAnchor, constant: 8.0),
            directInputTextField.trailingAnchor.constraint(equalTo: oneShotButton.trailingAnchor),
            directInputTextField.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
            directInputTextField.widthAnchor.constraint(equalToConstant: 200.0),
            
            directInputButton.topAnchor.constraint(equalTo: directInputTextField.topAnchor),
            directInputButton.leadingAnchor.constraint(equalTo: oneShotButton.leadingAnchor),
            directInputButton.trailingAnchor.constraint(equalTo: directInputTextField.leadingAnchor, constant: -8.0),
            directInputButton.heightAnchor.constraint(equalTo: directInputTextField.heightAnchor),
            
            shotButton.topAnchor.constraint(equalTo: directInputTextField.bottomAnchor, constant: 8.0),
            shotButton.leadingAnchor.constraint(equalTo: directInputTextField.leadingAnchor),
            shotButton.heightAnchor.constraint(equalToConstant: 30.0),
            shotButton.widthAnchor.constraint(equalToConstant: 96.0),
            
            mgButton.topAnchor.constraint(equalTo: shotButton.topAnchor),
            mgButton.leadingAnchor.constraint(equalTo: shotButton.trailingAnchor, constant: 8.0),
            mgButton.trailingAnchor.constraint(equalTo: directInputTextField.trailingAnchor),
            mgButton.heightAnchor.constraint(equalTo: shotButton.heightAnchor),
            
            separatorView.topAnchor.constraint(equalTo: mgButton.bottomAnchor, constant: 36.0),
            separatorView.leadingAnchor.constraint(equalTo: intakeTitleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: intakeTitleLabel.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            
            nonCaffeineIntakeTitleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 36.0),
            nonCaffeineIntakeTitleLabel.leadingAnchor.constraint(equalTo: intakeTitleLabel.leadingAnchor),
            nonCaffeineIntakeTitleLabel.trailingAnchor.constraint(equalTo: intakeTitleLabel.trailingAnchor),
            nonCaffeineIntakeTitleLabel.heightAnchor.constraint(equalTo: intakeTitleLabel.heightAnchor),
            
            
            nonCaffeineIntakeButton.topAnchor.constraint(equalTo: nonCaffeineIntakeTitleLabel.bottomAnchor, constant: 12.0),
            nonCaffeineIntakeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nonCaffeineIntakeButton.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
            nonCaffeineIntakeButton.widthAnchor.constraint(equalToConstant: 90.0),
            
            waterIntakeButton.topAnchor.constraint(equalTo: nonCaffeineIntakeButton.topAnchor),
            waterIntakeButton.trailingAnchor.constraint(equalTo: nonCaffeineIntakeButton.leadingAnchor, constant: -5.0),
            waterIntakeButton.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
            waterIntakeButton.widthAnchor.constraint(equalTo: nonCaffeineIntakeButton.widthAnchor),
            
            milkIntakeButton.topAnchor.constraint(equalTo: nonCaffeineIntakeButton.topAnchor),
            milkIntakeButton.leadingAnchor.constraint(equalTo: nonCaffeineIntakeButton.trailingAnchor, constant: 5.0),
            milkIntakeButton.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
            milkIntakeButton.widthAnchor.constraint(equalTo: nonCaffeineIntakeButton.widthAnchor),
            
            teaIntakeButton.topAnchor.constraint(equalTo: nonCaffeineIntakeButton.bottomAnchor, constant: 8.0),
            teaIntakeButton.trailingAnchor.constraint(equalTo: nonCaffeineIntakeButton.centerXAnchor, constant: -8.0),
            teaIntakeButton.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
            teaIntakeButton.widthAnchor.constraint(equalTo: nonCaffeineIntakeButton.widthAnchor),
            
            anotherIntakeButton.topAnchor.constraint(equalTo: teaIntakeButton.topAnchor),
            anotherIntakeButton.leadingAnchor.constraint(equalTo: nonCaffeineIntakeButton.centerXAnchor, constant: 8.0),
            anotherIntakeButton.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
            anotherIntakeButton.widthAnchor.constraint(equalTo: nonCaffeineIntakeButton.widthAnchor),
            
            intakeInputTextField.topAnchor.constraint(equalTo: anotherIntakeButton.bottomAnchor, constant: 8.0),
            intakeInputTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            intakeInputTextField.widthAnchor.constraint(equalToConstant: 120.0),
            intakeInputTextField.heightAnchor.constraint(equalTo: oneShotButton.heightAnchor),
        ])
    }
}
