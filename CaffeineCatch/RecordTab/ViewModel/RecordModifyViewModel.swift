//
//  RecordModifyViewModel.swift
//  CaffeineCatch
//
//  Created by 한소희 on 12/9/24.
//

import Foundation
import RxSwift
import UIKit
import NotificationCenter
import CoreData

final class RecordModifyViewModel {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let recordSectionData = BehaviorSubject(value: [SectionOfRecordData(header: SectionHeaderName.recordData.rawValue, items: [RecordData(category: "기록이 없어요", intake: 0, unit: "", date: "", id: UUID())])])
    let isDeletedData = PublishSubject<Bool>()
    
    func fetchRecordData() {
        let context = appDelegate.caffeinePersistentContainer.viewContext
        let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        do {
            let recordDatas = try context.fetch(fetchCaffeineRequest)
            let recordData = recordDatas
                .map {
                    convertToSectionOfRecordData($0.caffeineIntakeDate ?? Date().toString(), $0.intakeCategory ?? "물", $0.intakeUnit ?? "mL", Int($0.intake), $0.intakeID ?? UUID())
                }
            let sortedRecordData = recordData.sorted { (record1, record2) -> Bool in
                guard let date1 = Date.fromString(record1.items.first?.date ?? ""),
                      let date2 = Date.fromString(record2.items.first?.date ?? "") else {
                    return false
                }
                return date1 < date2
            }
            recordSectionData.onNext(sortedRecordData)
        } catch {
            
        }
    }
    
    private func convertToSectionOfRecordData(_ date: String, _ category: String, _ unit: String, _ intake: Int, _ id: UUID) -> SectionOfRecordData {
        return .init(header: SectionHeaderName.recordData.rawValue, items: [RecordData(category: category, intake: intake, unit: unit, date: date, id: id)])
    }
    
    func deleteData(intakeID: UUID) {
        let context = appDelegate.caffeinePersistentContainer.viewContext
        let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        do {
            let recordDatas = try context.fetch(fetchCaffeineRequest)
            let deletedDataFilter = recordDatas.filter { $0.intakeID == intakeID }
            context.delete(deletedDataFilter[0])
            try context.save()
            isDeletedData.onNext(true)
        } catch {
            print("ERROR Delete Data: \(error.localizedDescription)")
            isDeletedData.onNext(false)
        }
    }
    
    func postNotificationCenter() {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterName.deleteData.rawValue), object: nil)
    }
}
