//
//  CalendarView.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/22/24.
//

import UIKit
import FSCalendar

final class CalendarView: FSCalendar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        locale = Locale(identifier: "ko_KR")
        appearance.headerMinimumDissolvedAlpha = 0.0
        appearance.headerDateFormat = "YYYY년 MM월"
        appearance.headerTitleColor = .label
        appearance.headerTitleFont = .systemFont(ofSize: 16.0, weight: .bold)
        appearance.weekdayTextColor = .label
        appearance.headerTitleAlignment = .center
        appearance.titleDefaultColor = .label
        appearance.titleWeekendColor = .systemRed
        appearance.selectionColor = .systemGray4
        placeholderType = .none
        headerHeight = 45.0
        backgroundColor = .systemBackground
        layer.cornerRadius = 24.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
