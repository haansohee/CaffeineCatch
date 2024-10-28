//
//  RecordViewModel.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/22/24.
//

import Foundation
import RxSwift

final class RecordViewModel {
    let isLoadedSectionData = PublishSubject<Void>()
    var nonCaffeineInTakeData: [InTakeNonCaffeineData] = []
    let nonCaffeineSectionData = BehaviorSubject(value: [
        SectionOfInTakeNonCaffeineData(
            header: "nonCaffeine",
            items: [InTakeNonCaffeineData(nonCaffeine: "물 (250ml)"),
                    InTakeNonCaffeineData(nonCaffeine: "우유 (150ml"),
                    InTakeNonCaffeineData(nonCaffeine: "보리차 (300ml)")
                   ])
    ])
    
    func loadSectionData() {
        let testValue = [SectionOfInTakeNonCaffeineData(
            header: "nonCaffeine",
            items: [
                InTakeNonCaffeineData(nonCaffeine: "물 (180ml)"),
                InTakeNonCaffeineData(nonCaffeine: "우유 (180ml)"),
                InTakeNonCaffeineData(nonCaffeine: "보리차 (300ml)")
            ])]
        nonCaffeineSectionData.onNext(testValue)
    }
}
