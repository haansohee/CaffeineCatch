//
//  AverageCaffeineData.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import Foundation
import RxDataSources

struct SectionOfAverageCaffeineData {
    let header: String
    var items: [Item]
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}

extension SectionOfAverageCaffeineData: SectionModelType {
    typealias Item = AverageCaffeineData
    
    init(original: SectionOfAverageCaffeineData, items: [AverageCaffeineData]) {
        self = original
        self.items = items
    }
}

struct AverageCaffeineData {
    var caffeineData: String
    var mgData: String
}
