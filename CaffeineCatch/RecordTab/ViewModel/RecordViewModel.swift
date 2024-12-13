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
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var nonCaffeineInTakeData: [SectionOfInTakeNonCaffeineData] = []
    let isSavedIntakeRecord = PublishSubject<Bool>()
    let isFetchedDateStatus = PublishSubject<Bool>()
    let caffeineIntakeData = BehaviorSubject(value: "기록이 없어요.")
    let nonCaffeineSectionData = BehaviorSubject<[SectionOfInTakeNonCaffeineData]>(
        value: [SectionOfInTakeNonCaffeineData(
            header: SectionHeaderName.nonCaffeine.rawValue,
            items: [InTakeNonCaffeineData(category: "기록이 없어요.", unit: "🥺", intake: 0)])])
    var selectedDate: Date?
    private(set) var dateStatus: [Date: Bool] = [:]
    
    func fetchRecordCaffeineIntake(date: Date) {
        let today = date.toString()
        let context = appDelegate.caffeinePersistentContainer.viewContext
        let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        fetchCaffeineRequest.predicate = NSPredicate(format: "caffeineIntakeDate == %@", today)
        do {
            let caffeineIntakes = try context.fetch(fetchCaffeineRequest)

            let caffeine = caffeineIntakes
                .filter { $0.isCaffeine }
                .map { "\($0.intakeCategory ?? "카페인") \($0.intake) \($0.intakeUnit ?? "shot")" }
            
            let nonCaffeine = caffeineIntakes
                .filter { !$0.isCaffeine }
                .map {
                    convertToSectionOfInTakeNonCaffeineData(Int($0.intake), $0.intakeCategory ?? "기록이 없어요.", $0.intakeUnit ?? "🥺")
                }
            
            nonCaffeineSectionData.onNext(nonCaffeine.isEmpty ? [SectionOfInTakeNonCaffeineData(
                header: SectionHeaderName.nonCaffeine.rawValue,
                items: [InTakeNonCaffeineData(category: "기록이 없어요.", unit: "🥺", intake: 0)])] : nonCaffeine)
            caffeineIntakeData.onNext((caffeine.isEmpty ? "" : caffeine[0]))
        } catch {
            nonCaffeineSectionData.onError(error)
            print(error.localizedDescription)
        }
    }
    
    func fetchDateStatus() {
        dateStatus = [:]
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
    
    private func convertToSectionOfInTakeNonCaffeineData(_ intake: Int, _ category: String, _ unit: String) -> SectionOfInTakeNonCaffeineData {
        return .init(header: SectionHeaderName.nonCaffeine.rawValue, items: [InTakeNonCaffeineData(category: category, unit: unit, intake: intake)])
    }
    
    private func convertStringToInt(_ value: String) -> Int {
        let inputData = value.split(separator: " ").map(String.init)
        guard let value = inputData.first,
              let valueInt = Int(value) else { return 0 }
        return valueInt
    }
    
    private func notificationPost() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationCenterName.UpdateGoalCaffeineIntake.rawValue), object: nil)
    }
    
    private func loadUserInfo() -> (isZeroCaffeineUser: Bool, goalIntake: Int) {
        let userContext = appDelegate.userPersistentContainer.viewContext
        let userRequest = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        do {
            let userInfos = try userContext.fetch(userRequest).first
            guard let isZeroCaffeineUser = userInfos?.isZeroCaffeine else {
                isSavedIntakeRecord.onError(MyError.noDataError)
                return (isZeroCaffeineUser: false, goalIntake: 0)
            }
            let goalIntakeValue = isZeroCaffeineUser ? userInfos?.goalWaterIntake : userInfos?.goalCaffeineIntake
            guard let goalIntake = goalIntakeValue else { return (isZeroCaffeineUser: false, goalIntake: 0) }
            return (isZeroCaffeineUser: isZeroCaffeineUser, goalIntake: Int(goalIntake))
        } catch {
            return (isZeroCaffeineUser: false, goalIntake: 0)
        }
    }
    
    func saveCaffeineIntakeRecord(_ intake: Int, _ intakeUnit: String) {  // 카페인 섭취 기록
        let caffeineContext = appDelegate.caffeinePersistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: EntityName.CaffeineIntakeInfo.rawValue, in: caffeineContext)
        guard let entity,
              let inputDate = selectedDate?.toString() else { return }
        let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        let inputIntake = intake.convertMgToShot(intakeUnit)  // 새로 기록하는 값
        let userInfo = loadUserInfo()  // 제로 카페인 도전하는 유저인지
        do {
            fetchCaffeineRequest.predicate = NSPredicate(format: "caffeineIntakeDate == %@ AND intakeCategory == %@", inputDate, IntakeCategory.caffeine.rawValue)
            let caffeineIntakes = try caffeineContext.fetch(fetchCaffeineRequest)
            print("🚨 Fetched CaffeineIntakes: \(caffeineIntakes.count)")
            
            if let caffeineIntakeDatas = caffeineIntakes.first {  // 기존에 입력된 데이터가 있을 경우
                let savedCaffeineIntake = caffeineIntakeDatas.intake
                let newCaffeineIntake = Int(savedCaffeineIntake) + Int(inputIntake)
                caffeineIntakeDatas.intake = Int32(newCaffeineIntake)
            } else {  // 기록 데이터가 없고 새로 입력하는 경우
                let isGoalIntakeExceeded = userInfo.isZeroCaffeineUser ? true : intake > userInfo.goalIntake
                let newCaffeineIntakeInfo = NSManagedObject(entity: entity, insertInto: caffeineContext)
                newCaffeineIntakeInfo.setValue(UUID(), forKey: CoreDataAttributes.intakeID.rawValue)
                newCaffeineIntakeInfo.setValue(inputDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
                newCaffeineIntakeInfo.setValue(true, forKey: CoreDataAttributes.isCaffeine.rawValue)
                newCaffeineIntakeInfo.setValue(Int32(intake), forKey: CoreDataAttributes.intake.rawValue)
                newCaffeineIntakeInfo.setValue(isGoalIntakeExceeded, forKey: CoreDataAttributes.isGoalIntakeExceeded.rawValue)
                newCaffeineIntakeInfo.setValue(IntakeCategory.caffeine.rawValue, forKey: CoreDataAttributes.intakeCategory.rawValue)
                newCaffeineIntakeInfo.setValue(IntakeUnitName.shot.rawValue, forKey: CoreDataAttributes.intakeUnit.rawValue)
                try caffeineContext.save()
            }
            notificationPost()
            isSavedIntakeRecord.onNext(true)
        } catch {
            print("ERROR saveCaffeineIntakeRecord:  \(error.localizedDescription)")
            isSavedIntakeRecord.onNext(false)
        }
    }
    
    func saveNonCaffeineIntakeRecord(_ intake: Int, _ category: String) {  // 기타 논카페인 섭취 기록
        let caffeineContext = appDelegate.caffeinePersistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: EntityName.CaffeineIntakeInfo.rawValue, in: caffeineContext)
        guard let entity,
              let inputDate = selectedDate?.toString() else { return }
        let newCaffeineIntakeInfo = NSManagedObject(entity: entity, insertInto: caffeineContext)
        do {
            newCaffeineIntakeInfo.setValue(UUID(), forKey: CoreDataAttributes.intakeID.rawValue)
            newCaffeineIntakeInfo.setValue(inputDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
            newCaffeineIntakeInfo.setValue(false, forKey: CoreDataAttributes.isCaffeine.rawValue)
            newCaffeineIntakeInfo.setValue(Int32(intake), forKey: CoreDataAttributes.intake.rawValue)
            newCaffeineIntakeInfo.setValue(category, forKey: CoreDataAttributes.intakeCategory.rawValue)
            newCaffeineIntakeInfo.setValue(IntakeUnitName.mL.rawValue, forKey: CoreDataAttributes.intakeUnit.rawValue)
            try caffeineContext.save()
            notificationPost()
            isSavedIntakeRecord.onNext(true)
        } catch {
            print("ERROR saveCaffeineIntakeRecord:  \(error.localizedDescription)")
            isSavedIntakeRecord.onNext(false)
        }
    }
    
    func saveWaterIntakeRecord(_ intake: Int) {  // 물 섭취 기록
        let caffeineContext = appDelegate.caffeinePersistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: EntityName.CaffeineIntakeInfo.rawValue, in: caffeineContext)
        guard let entity,
              let inputDate = selectedDate?.toString() else { return }
        let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        let userInfo = loadUserInfo()  // 제로 카페인 도전하는 유저인지
        let isZeroCaffeineUser = userInfo.isZeroCaffeineUser
        do {
            fetchCaffeineRequest.predicate = NSPredicate(format: "caffeineIntakeDate == %@ AND intakeCategory == %@" , inputDate, IntakeCategory.water.rawValue)
            let waterIntakes = try caffeineContext.fetch(fetchCaffeineRequest)
            if let waterIntakeDatas = waterIntakes.first { // 물 섭취 기록이 있을 경우
                let newWaterIntake = Int(waterIntakeDatas.intake) + intake
                waterIntakeDatas.intake = Int32(newWaterIntake)
            } else { // 물 섭취 기록이 없을 경우
                let newCaffeineIntakeInfo = NSManagedObject(entity: entity, insertInto: caffeineContext)
                newCaffeineIntakeInfo.setValue(UUID(), forKey: CoreDataAttributes.intakeID.rawValue)
                newCaffeineIntakeInfo.setValue(inputDate, forKey: CoreDataAttributes.caffeineIntakeDate.rawValue)
                newCaffeineIntakeInfo.setValue(false, forKey: CoreDataAttributes.isCaffeine.rawValue)
                newCaffeineIntakeInfo.setValue(Int32(intake), forKey: CoreDataAttributes.intake.rawValue)
                newCaffeineIntakeInfo.setValue(false, forKey: CoreDataAttributes.isCaffeine.rawValue)
                newCaffeineIntakeInfo.setValue(IntakeCategory.water.rawValue, forKey: CoreDataAttributes.intakeCategory.rawValue)
                newCaffeineIntakeInfo.setValue(IntakeUnitName.mL.rawValue, forKey: CoreDataAttributes.intakeUnit.rawValue)
                if isZeroCaffeineUser {
                    newCaffeineIntakeInfo.setValue(intake <= userInfo.goalIntake, forKey: CoreDataAttributes.isGoalIntakeExceeded.rawValue)
                }
                try caffeineContext.save()
            }
            notificationPost()
            isSavedIntakeRecord.onNext(true)
        } catch {
            print("ERROR saveWaterIntakeRecord:  \(error.localizedDescription)")
            isSavedIntakeRecord.onNext(false)
        }
    }
}
