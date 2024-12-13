//
//  SectionOfRecordData.swift
//  CaffeineCatch
//
//  Created by 한소희 on 12/9/24.
//

import Foundation
import RxDataSources

struct SectionOfRecordData {
    let header: String
    var items: [Item]
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}
extension SectionOfRecordData: SectionModelType {
    typealias Item = RecordData
    
    init(original: SectionOfRecordData, items: [RecordData]) {
        self = original
        self.items = items
    }
}

struct RecordData {
    var category: String
    var intake: Int
    var unit: String
    var date: String
    var id: UUID
}
