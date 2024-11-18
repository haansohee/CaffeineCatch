//
//  String+.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import Foundation

extension String {
    func convertMgToShot() -> String? {
        let inputData = self.split(separator: " ").map(String.init)
        guard let unit = inputData.last else { return nil }
        guard let value = inputData.first,
              let valueInt = Int(value) else { return nil }
        switch IntakeUnitName(rawValue: unit) {
        case .mg:
            let shot = valueInt / 75
            return "\(shot) shot (\(valueInt)mg)"
        case .shot:
            let mg = valueInt * 75
            return "\(valueInt) shot (\(mg)mg)"
            default:
            return nil
        }
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return nil }
        return date
    }
}
