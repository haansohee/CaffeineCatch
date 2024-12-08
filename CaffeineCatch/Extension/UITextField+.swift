//
//  UITextField+.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/20/24.
//

import UIKit

extension UITextField {
    func validatedText() -> String? {
        guard let text = self.text,
              !text.isEmpty,
              text != "" else { return nil }
        return text
    }
}
