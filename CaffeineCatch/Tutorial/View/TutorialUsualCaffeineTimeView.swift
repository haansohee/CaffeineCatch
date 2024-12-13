//
//  TutorialUsualCaffeineTimeView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import UIKit

final class TutorialUsualCaffeineTimeView: UIView {
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "이제 마지막 설정이에요! 😁\n평소 카페인을 섭취하는 시간대에\n알림을 보내 드려요.\n알림을 언제 보내 드릴까요?"
        label.font = .systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    let notificationEnabledButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("알림 받을래요. 😀", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    let notificationDisenabledButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("알림 안 받을래요. 🥺", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 10.0
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

extension TutorialUsualCaffeineTimeView {
    private func addSubviews() {
        [
            questionLabel,
            datePicker,
            notificationEnabledButton,
            notificationDisenabledButton
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 60.0),
            questionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            questionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            
            datePicker.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24.0),
            datePicker.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 100.0),
            
            notificationEnabledButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 48.0),
            notificationEnabledButton.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
            notificationEnabledButton.trailingAnchor.constraint(equalTo: questionLabel.centerXAnchor, constant: -5.0),
            notificationEnabledButton.heightAnchor.constraint(equalToConstant: 50.0),
            
            notificationDisenabledButton.topAnchor.constraint(equalTo: notificationEnabledButton.topAnchor),
            notificationDisenabledButton.leadingAnchor.constraint(equalTo: questionLabel.centerXAnchor, constant: 5.0),
            notificationDisenabledButton.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            notificationDisenabledButton.heightAnchor.constraint(equalTo: notificationEnabledButton.heightAnchor),
            notificationDisenabledButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -220.0)
        ])
    }
}
