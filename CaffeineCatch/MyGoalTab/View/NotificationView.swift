//
//  NotificationView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 12/9/24.
//

import UIKit

enum NotificationStatus: String {
    case on = "알림 끌래요. 🥲"
    case off = "알림 켤래요. 🤩"
}

final class NotificationView: UIView {
    private let myNotificationStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "🔔 알림이 켜져 있는 상태예요."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 18.0, weight: .light)
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    let notificationTimeUpdateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("으로 알림 시간 변경할게요.", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 13.0)
        button.layer.cornerRadius = 20.0
        return button
    }()
    
    let notificationStatusUpdateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("알림 끌래요. 🥲", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.titleLabel?.font = .systemFont(ofSize: 13.0)
        button.layer.cornerRadius = 20.0
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationView {
    private func addSubviews() {
        [
            myNotificationStatusLabel,
            datePicker,
            notificationTimeUpdateButton,
            notificationStatusUpdateButton
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            myNotificationStatusLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 36.0),
            myNotificationStatusLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            myNotificationStatusLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            myNotificationStatusLabel.heightAnchor.constraint(equalToConstant: 60.0),
            
            notificationTimeUpdateButton.topAnchor.constraint(equalTo: myNotificationStatusLabel.bottomAnchor, constant: 36.0),
            notificationTimeUpdateButton.trailingAnchor.constraint(equalTo: myNotificationStatusLabel.trailingAnchor),
            notificationTimeUpdateButton.widthAnchor.constraint(equalToConstant: 180.0),
            notificationTimeUpdateButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            datePicker.topAnchor.constraint(equalTo: notificationTimeUpdateButton.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: myNotificationStatusLabel.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: notificationTimeUpdateButton.leadingAnchor, constant: -5.0),
            datePicker.bottomAnchor.constraint(equalTo: notificationTimeUpdateButton.bottomAnchor),
            
            notificationStatusUpdateButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 48.0),
            notificationStatusUpdateButton.leadingAnchor.constraint(equalTo: myNotificationStatusLabel.leadingAnchor),
            notificationStatusUpdateButton.trailingAnchor.constraint(equalTo: myNotificationStatusLabel.trailingAnchor),
            notificationStatusUpdateButton.heightAnchor.constraint(equalTo: notificationTimeUpdateButton.heightAnchor)
        ])
    }
    
    func configureAttributes(_ isNotification: Bool, _ date: Date, _ notificationStatus: Bool) {
        if notificationStatus {
            myNotificationStatusLabel.text = isNotification ? "🔔 알림이 켜져 있는 상태예요." : "🔕 알림이 꺼져 있는 상태예요."
            notificationStatusUpdateButton.tag = 0
            notificationTimeUpdateButton.isEnabled = true
            notificationTimeUpdateButton.backgroundColor = isNotification ? .systemBlue : .systemGray
            notificationStatusUpdateButton.setTitle(isNotification ? "알림 끌래요. 🥲" : "알림 켤래요. 🤩", for: .normal)
            notificationStatusUpdateButton.backgroundColor = !isNotification ? .systemBlue : .systemGray
            notificationStatusUpdateButton.isSelected = isNotification
            datePicker.date = date
        } else {
            myNotificationStatusLabel.text = "알림 권한이 꺼져 있는 상태예요.\n설정에 가서 알림 권한을 켜주세요."
            notificationStatusUpdateButton.tag = 1
            notificationTimeUpdateButton.isEnabled = false
            notificationTimeUpdateButton.backgroundColor = .systemGray
            notificationStatusUpdateButton.setTitle("설정 가서 알림 켜기", for: .normal)
            datePicker.date = date
        }
    }
}
