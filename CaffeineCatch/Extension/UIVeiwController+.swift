//
//  UIVeiwController+.swift
//  CaffeineCatch
//
//  Created by 한소희 on 12/9/24.
//

import Foundation
import UIKit

extension UIViewController {
    func doneAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "확인", style: .default)
        alert.addAction(done)
        self.present(alert, animated: true)
    }
}
