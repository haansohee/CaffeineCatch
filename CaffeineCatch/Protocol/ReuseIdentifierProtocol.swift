//
//  ReuseIdentifierProtocol.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import Foundation

protocol ReuseIdentifierProtocol {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifierProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
