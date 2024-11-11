//
//  RecordViewModel.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/22/24.
//

import UIKit
import CoreData
import Foundation
import RxSwift

final class RecordViewModel {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var nonCaffeineInTakeData: [SectionOfInTakeNonCaffeineData] = []
    let isSavedIntakeRecord = PublishSubject<Bool>()
    let caffeineIntakeData = BehaviorSubject(value: "기록이 없어요.")
    let nonCaffeineSectionData = BehaviorSubject<[SectionOfInTakeNonCaffeineData]>(
        value: [SectionOfInTakeNonCaffeineData(
            header: SectionHeaderName.nonCaffeine.rawValue,
            items: [InTakeNonCaffeineData(nonCaffeine: "기록이 없어요.")])])
    var selectedDate: Date?
    
    func fetchRecordCaffeineIntake(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: date)
        
        let context = appDelegate.caffeinePersistentContainer.viewContext
        let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        fetchCaffeineRequest.predicate = NSPredicate(format: "caffeineIntakeDate == %@", today)
        do {
            let caffeineIntakes = try context.fetch(fetchCaffeineRequest)

            let caffeine = caffeineIntakes
                .filter { $0.isCaffeine }
                .map { $0.intake }
            
            let nonCaffeine = caffeineIntakes
                .filter { !$0.isCaffeine }
                .map { convertToSectionOfInTakeNonCaffeineData($0.intake ?? "🥛") }
            
            nonCaffeineSectionData.onNext(nonCaffeine.isEmpty ? [SectionOfInTakeNonCaffeineData(
                header: SectionHeaderName.nonCaffeine.rawValue,
                items: [InTakeNonCaffeineData(nonCaffeine: "기록이 없어요.")])] : nonCaffeine)
            caffeineIntakeData.onNext((caffeine.isEmpty ? "" : caffeine[0]) ?? "")
        } catch {
            nonCaffeineSectionData.onError(error)
            print(error.localizedDescription)
        }
    }
    
    private func convertToSectionOfInTakeNonCaffeineData(_ intakeCaffeineData: String) -> SectionOfInTakeNonCaffeineData {
        return .init(header: SectionHeaderName.nonCaffeine.rawValue, items: [InTakeNonCaffeineData(nonCaffeine: intakeCaffeineData)])
    }

    // 값 넣고 지우고 하느라... 또 필요할 것 같아서 안 지웠어ㅇㅅ
//    func deleteAllData() {
//        let context = appDelegate.caffeinePersistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EntityName.CaffeineIntakeInfo.rawValue)
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        
//        do {
//            try context.execute(deleteRequest)
//            try context.save()
//            print("모든 데이터 삭제 완료~~")
//        } catch {
//            print("데이터 삭제 실패: \(error)")
//        }
//    }
    
    private func convertMgToShot(_ inputValue: String) -> String? {
        let inputData = inputValue.split(separator: " ").map(String.init)
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

    
    func saveRecordCaffeineIntake(_ caffeineIntake: CaffeineIntake, isDirectInput: Bool) {
        let context = appDelegate.caffeinePersistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: EntityName.CaffeineIntakeInfo.rawValue, in: context)
        guard let entity else { return }
        let newCaffieneIntakeInfo = NSManagedObject(entity: entity, insertInto: context)
        
        let inputCaffeineIntakeData = isDirectInput ? convertMgToShot(caffeineIntake.intake) : caffeineIntake.intake
        guard let inputCaffeineIntake = inputCaffeineIntakeData else {
            isSavedIntakeRecord.onNext(false)
            return }
        
        do {
            if caffeineIntake.isCaffeine {  // 카페인 섭취
                let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
                fetchCaffeineRequest.predicate = NSPredicate(format: "caffeineIntakeDate == %@ AND isCaffeine == true", caffeineIntake.caffeineIntakeDate)
                let caffeineIntakes = try context.fetch(fetchCaffeineRequest)
                guard let caffeineIntakeDatas = caffeineIntakes.first else {  // 기존 데이터 없을 때
                    newCaffieneIntakeInfo.setValue(caffeineIntake.caffeineIntakeDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
                    newCaffieneIntakeInfo.setValue(caffeineIntake.isCaffeine, forKey: CoreDataAttributes.isCaffeine.rawValue)
                    newCaffieneIntakeInfo.setValue(inputCaffeineIntake, forKey: CoreDataAttributes.intake.rawValue)
                    try context.save()
                    isSavedIntakeRecord.onNext(true)
                    return
                }
                // 기존 데이터 있을 때
                let caffeineIntakeInfoUpdateInfo = caffeineIntakeDatas as NSManagedObject
                guard let savedCaffeineIntake = caffeineIntakeDatas.intake,
                    let saveCaffeineIntake = calcurateIntakeCaffeine(
                    savedCaffeineIntake: savedCaffeineIntake,
                    inputIntake: inputCaffeineIntake) else {
                    isSavedIntakeRecord.onNext(false)
                    return }
                caffeineIntakeInfoUpdateInfo.setValue(caffeineIntake.caffeineIntakeDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
                caffeineIntakeInfoUpdateInfo.setValue(caffeineIntake.isCaffeine, forKey: CoreDataAttributes.isCaffeine.rawValue)
                caffeineIntakeInfoUpdateInfo.setValue(saveCaffeineIntake, forKey: CoreDataAttributes.intake.rawValue)
                try context.save()
                isSavedIntakeRecord.onNext(true)
            } else {  // non카페인 섭취
                newCaffieneIntakeInfo.setValue(caffeineIntake.caffeineIntakeDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
                newCaffieneIntakeInfo.setValue(caffeineIntake.isCaffeine, forKey: CoreDataAttributes.isCaffeine.rawValue)
                newCaffieneIntakeInfo.setValue(caffeineIntake.intake, forKey: CoreDataAttributes.intake.rawValue)
                try context.save()
                isSavedIntakeRecord.onNext(true)
            }
        } catch {
            print(error.localizedDescription)
            isSavedIntakeRecord.onNext(false)
        }
    }
    
    private func calcurateIntakeCaffeine(savedCaffeineIntake: String, inputIntake: String) -> String? {
        let unitPattern =  #"\d+"#
        let caffeineIntake = savedCaffeineIntake.components(separatedBy: " ")
        let intakeShotText = caffeineIntake[0]
        let intakeMgText = caffeineIntake[2]
        guard let range = intakeMgText.range(of: unitPattern, options: .regularExpression),
              let intakeMg = Int(intakeMgText[range]),
              let intakeShot = Int(intakeShotText) else { return nil }  // 이미 저장되어 있는 값
        
        let inputCaffeineIntake = inputIntake.components(separatedBy: " ")
        let inputIntakeShotText = inputCaffeineIntake[0]
        let inputIntakeMgText = inputCaffeineIntake[2]
        guard let inputRange = inputIntakeMgText.range(of: unitPattern, options: .regularExpression),
              let inputIntakeMg = Int(inputIntakeMgText[inputRange]),
              let inputIntakeShot = Int(inputIntakeShotText) else { return nil }  // 저장할 값
        
        return "\(intakeShot + inputIntakeShot) shot (\(intakeMg + inputIntakeMg)mg)"
    }
}
