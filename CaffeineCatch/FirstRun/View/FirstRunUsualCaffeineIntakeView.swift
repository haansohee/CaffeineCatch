//
//  FirstRunUsualCaffeineIntakeView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/11/24.
//

import UIKit

final class FirstRunUsualCaffeineIntakeView: UIView {
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "환영해요. 🤗\n카페인 섭취량을 기록하며 목표에\n한 걸음 더 다가가 보세요!\n건강한 습관을 함께 만들어 봐요."
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "평소 하루에 마시는 카페인\n섭취량이 어떻게 되나요?"
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    let twoShotOrLessButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("2 shot (150mg) 미만", for: .normal)
        return button
    }()
    
    
    let twoShotButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("2 shot (150mg)", for: .normal)
        return button
    }()
    
    let threeShotButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("3 shot (225mg)", for: .normal)
        return button
    }()
    
    let fourShotOrMoreButton: IntakeButton = {
        let button = IntakeButton()
        button.setTitle("4 shot (300mg) 이상", for: .normal)
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

extension FirstRunUsualCaffeineIntakeView {
    private func addSubviews() {
        [
            fourShotOrMoreButton,
            threeShotButton,
            twoShotButton,
            twoShotOrLessButton,
            questionLabel,
            welcomeLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            fourShotOrMoreButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -60.0),
            fourShotOrMoreButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            fourShotOrMoreButton.heightAnchor.constraint(equalToConstant: 50.0),
            fourShotOrMoreButton.widthAnchor.constraint(equalToConstant: 250.0),
            
            threeShotButton.bottomAnchor.constraint(equalTo: fourShotOrMoreButton.topAnchor, constant: -8.0),
            threeShotButton.centerXAnchor.constraint(equalTo: fourShotOrMoreButton.centerXAnchor),
            threeShotButton.heightAnchor.constraint(equalTo: fourShotOrMoreButton.heightAnchor),
            threeShotButton.widthAnchor.constraint(equalTo: fourShotOrMoreButton.widthAnchor),
            
            twoShotButton.bottomAnchor.constraint(equalTo: threeShotButton.topAnchor, constant: -8.0),
            twoShotButton.centerXAnchor.constraint(equalTo: fourShotOrMoreButton.centerXAnchor),
            twoShotButton.heightAnchor.constraint(equalTo: fourShotOrMoreButton.heightAnchor),
            twoShotButton.widthAnchor.constraint(equalTo: fourShotOrMoreButton.widthAnchor),
            
            twoShotOrLessButton.bottomAnchor.constraint(equalTo: twoShotButton.topAnchor, constant: -8.0),
            twoShotOrLessButton.centerXAnchor.constraint(equalTo: fourShotOrMoreButton.centerXAnchor),
            twoShotOrLessButton.heightAnchor.constraint(equalTo: fourShotOrMoreButton.heightAnchor),
            twoShotOrLessButton.widthAnchor.constraint(equalTo: fourShotOrMoreButton.widthAnchor),
            
            questionLabel.bottomAnchor.constraint(equalTo: twoShotOrLessButton.topAnchor, constant: -20.0),
            questionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            questionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            
            welcomeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60.0),
            welcomeLabel.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: questionLabel.topAnchor, constant: -12.0)
        ])
    }
}
