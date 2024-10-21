//
//  AverageCaffeineData.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import Foundation
import RxDataSources

struct SectionOfCustomData {
    let header: String
    var items: [Item]
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}

extension SectionOfCustomData: SectionModelType {
    typealias Item = AverageCaffeineData
    
    init(original: SectionOfCustomData, items: [AverageCaffeineData]) {
        self = original
        self.items = items
    }
}

struct AverageCaffeineData {
    var caffeineData: String
    var mgData: String
}
