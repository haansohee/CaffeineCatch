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

enum Category: String {
    case 물
}

final class RecordViewModel {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var nonCaffeineInTakeData: [SectionOfInTakeNonCaffeineData] = []
    let isSavedIntakeRecord = PublishSubject<Bool>()
    let isFetchedDateStatus = PublishSubject<Bool>()
    let caffeineIntakeData = BehaviorSubject(value: "기록이 없어요.")
    let nonCaffeineSectionData = BehaviorSubject<[SectionOfInTakeNonCaffeineData]>(
        value: [SectionOfInTakeNonCaffeineData(
            header: SectionHeaderName.nonCaffeine.rawValue,
            items: [InTakeNonCaffeineData(nonCaffeine: "기록이 없어요.")])])
    var selectedDate: Date?
    private(set) var dateStatus: [Date: Bool] = [:]
    
    func fetchRecordCaffeineIntake(date: Date) {
        print("fetchRecordCaffeineIntake")
        let today = date.toString()
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
    
    private func convertStringToInt(_ value: String) -> Int {
        let inputData = value.split(separator: " ").map(String.init)
        guard let value = inputData.first,
              let valueInt = Int(value) else { return 0 }
        return valueInt
    }
    
    private func notificationPost() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "test"), object: nil)
    }
    
    func saveRecordCaffeineIntake(_ caffeineIntake: CaffeineIntake, isDirectInput: Bool) {
        let caffeineContext = appDelegate.caffeinePersistentContainer.viewContext
        let userContext = appDelegate.userPersistentContainer.viewContext
        let userRequest = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        let entity = NSEntityDescription.entity(forEntityName: EntityName.CaffeineIntakeInfo.rawValue, in: caffeineContext)
        guard let entity else { return }
        let newCaffieneIntakeInfo = NSManagedObject(entity: entity, insertInto: caffeineContext)
        
        let inputCaffeineIntakeData = isDirectInput ? (caffeineIntake.intake).convertMgToShot() : caffeineIntake.intake
        guard let inputCaffeineIntake = inputCaffeineIntakeData else {
            isSavedIntakeRecord.onNext(false)
            return }
        
        do {
            let userInfos = try userContext.fetch(userRequest).first
            guard let isZeroCaffeine = userInfos?.isZeroCaffeine else { return }
            
            if caffeineIntake.isCaffeine {  // 카페인 섭취
                let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
                fetchCaffeineRequest.predicate = NSPredicate(format: "caffeineIntakeDate == %@ AND isCaffeine == true", caffeineIntake.caffeineIntakeDate)
                let caffeineIntakes = try caffeineContext.fetch(fetchCaffeineRequest)
                guard let caffeineIntakeDatas = caffeineIntakes.first else {  // 기존 데이터 없을 때
                    let isGoalIntakeExceeded = compareIsGoalCaffeineIntakeExceeded(inputCaffeineIntake)
                    newCaffieneIntakeInfo.setValue(caffeineIntake.caffeineIntakeDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
                    newCaffieneIntakeInfo.setValue(caffeineIntake.isCaffeine, forKey: CoreDataAttributes.isCaffeine.rawValue)
                    newCaffieneIntakeInfo.setValue(inputCaffeineIntake, forKey: CoreDataAttributes.intake.rawValue)
                    newCaffieneIntakeInfo.setValue(isZeroCaffeine ? false : isGoalIntakeExceeded, forKey: CoreDataAttributes.isGoalIntakeExceeded.rawValue)
                    try caffeineContext.save()
                    notificationPost()
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
                let isGoalIntakeExceeded = compareIsGoalCaffeineIntakeExceeded(saveCaffeineIntake)
                caffeineIntakeInfoUpdateInfo.setValue(caffeineIntake.caffeineIntakeDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
                caffeineIntakeInfoUpdateInfo.setValue(caffeineIntake.isCaffeine, forKey: CoreDataAttributes.isCaffeine.rawValue)
                caffeineIntakeInfoUpdateInfo.setValue(saveCaffeineIntake, forKey: CoreDataAttributes.intake.rawValue)
                caffeineIntakeInfoUpdateInfo.setValue(isZeroCaffeine ? false : isGoalIntakeExceeded, forKey: CoreDataAttributes.isGoalIntakeExceeded.rawValue)
                try caffeineContext.save()
                notificationPost()
                isSavedIntakeRecord.onNext(true)
            } else {  // non카페인 섭취
                let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
                fetchCaffeineRequest.predicate = NSPredicate(format: "caffeineIntakeDate == %@ AND isCaffeine == false", caffeineIntake.caffeineIntakeDate)
                let caffeineIntakes = try caffeineContext.fetch(fetchCaffeineRequest)
                guard let caffeineIntakeDatas = caffeineIntakes.first else {  // non카페인을 처음 섭취했을 때
                    newCaffieneIntakeInfo.setValue(caffeineIntake.intake, forKey: CoreDataAttributes.intake.rawValue)
                    newCaffieneIntakeInfo.setValue(caffeineIntake.caffeineIntakeDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
                    newCaffieneIntakeInfo.setValue(caffeineIntake.isCaffeine, forKey: CoreDataAttributes.isCaffeine.rawValue)
                    newCaffieneIntakeInfo.setValue(caffeineIntake.intake, forKey: CoreDataAttributes.intake.rawValue)
                    guard let waterIntake = caffeineIntake.waterIntake else {  // non카페인 처음 섭취하면서 non카페인 != 물 일 때
                        try caffeineContext.save()
                        notificationPost()
                        isSavedIntakeRecord.onNext(true)
                        return
                    }
                    // non카페인 처음 섭취하면서 non 카페인 == 물 일 때
                    newCaffieneIntakeInfo.setValue(waterIntake, forKey: CoreDataAttributes.waterIntake.rawValue)
                    newCaffieneIntakeInfo.setValue(isZeroCaffeine ? compareIsGoalWaterIntakeExceeded(waterIntake) : nil, forKey: CoreDataAttributes.isGoalIntakeExceeded.rawValue)
                    try caffeineContext.save()
                    notificationPost()
                    isSavedIntakeRecord.onNext(true)
                    return }
                
                let caffeineIntakeInfoUpdateInfo = caffeineIntakeDatas as NSManagedObject
                caffeineIntakeInfoUpdateInfo.setValue(caffeineIntake.caffeineIntakeDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
                caffeineIntakeInfoUpdateInfo.setValue(caffeineIntake.isCaffeine, forKey: CoreDataAttributes.isCaffeine.rawValue)
                guard let waterIntake = caffeineIntake.waterIntake else {
                    // 저장하려는 non카페인이 물이 아닐 때
                    caffeineIntakeInfoUpdateInfo.setValue(caffeineIntake.intake, forKey: CoreDataAttributes.intake.rawValue)
                    try caffeineContext.save()
                    notificationPost()
                    isSavedIntakeRecord.onNext(true)
                    return }
                // 저장하려는 non카페인이 물일 때
                guard let savedWaterIntake = caffeineIntakeDatas.waterIntake else {
                    // 물 처음 마실 때
                    caffeineIntakeInfoUpdateInfo.setValue(caffeineIntake.intake, forKey: CoreDataAttributes.intake.rawValue)
                    caffeineIntakeInfoUpdateInfo.setValue(waterIntake, forKey: CoreDataAttributes.waterIntake.rawValue)
                    caffeineIntakeInfoUpdateInfo.setValue(isZeroCaffeine ? compareIsGoalWaterIntakeExceeded(waterIntake) : nil, forKey: CoreDataAttributes.isGoalIntakeExceeded.rawValue)
                    try caffeineContext.save()
                    notificationPost()
                    isSavedIntakeRecord.onNext(true)
                    return
                }
                // 이미 물 섭취 기록이 있을 때 (저장된 물 섭취량 + 저장하려는 물 섭취량)으로 저장해 주기
                guard let intWaterIntake = Int(waterIntake),
                      let intSavedWaterIntake = Int(savedWaterIntake) else {
                    isSavedIntakeRecord.onNext(false)
                    return }
                let inputWaterIntake = intWaterIntake + intSavedWaterIntake
                guard let water = caffeineIntakeDatas.intake else { return }
                let waterSplit = water.split(separator: " ")
                guard let category = waterSplit.first else { return }
                if category == Category.물.rawValue {
                    let updatedData = "물 \(inputWaterIntake) mL"
                    caffeineIntakeInfoUpdateInfo.setValue(updatedData, forKey: CoreDataAttributes.intake.rawValue)  // 물 섭취량 업데이트하고 카테고리 이름과 같이 intake 항목에 저장
                }
                caffeineIntakeInfoUpdateInfo.setValue("\(inputWaterIntake)", forKey: CoreDataAttributes.waterIntake.rawValue)  // 업데이트한 물 섭취량 값만 wataerIntake 항목에 저장
                caffeineIntakeInfoUpdateInfo.setValue(isZeroCaffeine ? compareIsGoalWaterIntakeExceeded("\(inputWaterIntake) mL") : nil, forKey: CoreDataAttributes.isGoalIntakeExceeded.rawValue)
                try caffeineContext.save()
                notificationPost()
                isSavedIntakeRecord.onNext(true)
            }
        } catch {
            print(error.localizedDescription)
            isSavedIntakeRecord.onNext(false)
        }
    }
    
    func fetchDateStatus() {
        let context = appDelegate.caffeinePersistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        fetchRequest.predicate = NSPredicate(format: "caffeineIntakeDate != nil")
        do {
            let goalIntakeExceededInfos = try context.fetch(fetchRequest)
            goalIntakeExceededInfos.forEach {
                guard let dateString = $0.caffeineIntakeDate,
                      let date = dateString.toDate() else { return }
                dateStatus[date] = $0.isGoalIntakeExceeded
            }
            isFetchedDateStatus.onNext(true)
        } catch {
            print("error fetchDateStatus: \(error.localizedDescription)")
            isFetchedDateStatus.onNext(false)
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
    
    private func compareIsGoalCaffeineIntakeExceeded(_ caffeineIntake: String) -> Bool? {
        let inputCaffeineIntake = convertStringToInt(caffeineIntake)
        
        let context = appDelegate.userPersistentContainer.viewContext
        let fetchCaffeineRequest = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        do {
            let goalCaffeineIntakes = try context.fetch(fetchCaffeineRequest)
            let caffeine = goalCaffeineIntakes
                .map { $0.goalCaffeineIntake }
            guard let goalData = caffeine.first as? String else { return nil }
            let goalCaffeineIntake = convertStringToInt(goalData)
            return inputCaffeineIntake > goalCaffeineIntake
        } catch {
            print("error fetch caffeineIntakes: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func compareIsGoalWaterIntakeExceeded(_ waterIntake: String) -> Bool? {
        let inpurtWaterIntake = waterIntake.split(separator: " ").map(String.init)
        guard let waterIntakeValue = inpurtWaterIntake.first,
              let waterIntakeIntValue = Int(waterIntakeValue) else { return nil }
        let context = appDelegate.userPersistentContainer.viewContext
        let fetchUserRequest = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        do {
            let goalWaterIntakes = try context.fetch(fetchUserRequest)
            let water = goalWaterIntakes
                .map { $0.goalWaterIntake }
            guard let goalData = water.first as? String else { return nil }
            let goalWaterIntake = convertStringToInt(goalData)
            return waterIntakeIntValue < goalWaterIntake
        } catch {
            print("error fetch caffeineIntakes: \(error.localizedDescription)")
            return nil
        }
    }
}
