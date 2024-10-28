//
//  RecordViewModel.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/22/24.
//

import Foundation
import RxSwift

final class RecordViewModel {
    var nonCaffeineInTakeData: [InTakeNonCaffeineData] = []
    let section = BehaviorSubject(value: [
        SectionOfInTakeNonCaffeineData(
            header: "nonCaffeine",
            items: [InTakeNonCaffeineData(nonCaffeine: "물 (250ml)"),
                    InTakeNonCaffeineData(nonCaffeine: "우유 (150ml"),
                    InTakeNonCaffeineData(nonCaffeine: "보리차 (300ml)")
                   ])
    ])
}
