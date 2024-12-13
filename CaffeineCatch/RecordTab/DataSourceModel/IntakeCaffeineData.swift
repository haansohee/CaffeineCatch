//
//  InTakeNonCaffeineData.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/22/24.
//

import Foundation
import RxDataSources


struct InTakeNonCaffeineData {
    var category: String
    var unit: String
    var intake: Int
}

struct SectionOfInTakeNonCaffeineData {
    let header: String
    var items: [Item]
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}

extension SectionOfInTakeNonCaffeineData: SectionModelType {
    typealias Item = InTakeNonCaffeineData
    
    init(original: SectionOfInTakeNonCaffeineData, items: [InTakeNonCaffeineData]) {
        self = original
        self.items = items
    }
}
