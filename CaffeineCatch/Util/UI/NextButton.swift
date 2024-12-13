//
//  NextButton.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import UIKit

final class NextButton: AnimationButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle("다음 >", for: .normal)
        self.setTitleColor(.systemBlue, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        self.isHidden = true
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
