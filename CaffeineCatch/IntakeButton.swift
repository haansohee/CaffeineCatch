//
//  IntakeButton.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/29/24.
//

import UIKit

final class IntakeButton: AnimationButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.label, for: .normal)
        backgroundColor = .systemGray6
        titleLabel?.font = .systemFont(ofSize: 14.0)
        layer.cornerRadius = 10.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
