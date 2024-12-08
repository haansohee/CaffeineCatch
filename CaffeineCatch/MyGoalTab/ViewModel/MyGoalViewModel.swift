//
//  MyPageViewModel.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import Foundation
import RxSwift
import UIKit
import CoreData

enum MyError: Error {
    case noDataError
    case calculationError
}

final class MyGoalViewModel {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var averageCaffeine: [AverageCaffeineData] = []
    let averageCaffeineSectionData = BehaviorSubject(value: [
        SectionOfAverageCaffeineData(
            header: SectionHeaderName.averageCaffeine.rawValue,
        items: [AverageCaffeineData(caffeineData: "믹스커피\n(10g, 1봉)", mgData: "81.3mg")]
                )])
    let isSavedCoreData = PublishSubject<Bool>()
    let userInfoSubject = BehaviorSubject(value: (intakeValue: "0", isZeroCaffeineUser: false))
    let isUpdatedGoalCaffeineIntake = PublishSubject<Bool>()
    
    func loadSectionData() {
        let averageCaffeineData = [SectionOfAverageCaffeineData(
            header: SectionHeaderName.averageCaffeine.rawValue,
            items: [
                AverageCaffeineData(caffeineData: "믹스커피\n(10g, 1봉)", mgData: "81.3mg"),
                AverageCaffeineData(caffeineData: "캔커피\n(200ml, 1캔)", mgData: "118mg"),
                AverageCaffeineData(caffeineData: "아메리카노\n(톨사이즈 1잔)", mgData: "125mg"),
                AverageCaffeineData(caffeineData: "카푸치노\n(톨사이즈 1잔)", mgData: "137.3mg"),
                AverageCaffeineData(caffeineData: "액상차\n(500ml, 1병)", mgData: "58.8mg"),
                AverageCaffeineData(caffeineData: "아이스크림\n(100g, 1개)", mgData: "1.8mg"),
                AverageCaffeineData(caffeineData: "초콜릿\n(100g, 1개)", mgData: "3mg"),
                AverageCaffeineData(caffeineData: "탄산음료\n(500ml, 1병)", mgData: "83mg")
            ])]
        averageCaffeineSectionData.onNext(averageCaffeineData)
    }
    
    func fetchMyGoalCaffeineIntake() {
        let context = appDelegate.userPersistentContainer.viewContext
        let fetchUserReqeust = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        do {
            let userInfos = try context.fetch(fetchUserReqeust)
            guard let userInfo = userInfos.first else {
                userInfoSubject.onError(MyError.noDataError)
                return }
            let goalIntakeValue = userInfo.goalCaffeineIntake == 0 ? userInfo.goalWaterIntake : userInfo.goalCaffeineIntake
            guard let goalIntakeUnit = userInfo.goalIntakeUnit,
                  let goalIntakeCategory = userInfo.goalIntakeCategory else {
                userInfoSubject.onError(MyError.noDataError)
                return }
            let goalIntake = "\(goalIntakeCategory) \(goalIntakeValue) \(goalIntakeUnit)"
            let isZeroCaffeine = userInfo.isZeroCaffeine
            userInfoSubject.onNext((goalIntake, isZeroCaffeine))
        } catch {
            print("!! Fetch MyGoal Caffeine Intake Error: \(error.localizedDescription)")
            userInfoSubject.onError(error)
        }
    }
    
    func updateGoalCaffeineIntake(_ updateGoalIntakeValue: Int, _ updateGoalIntakeUnit: String) {
        let context = appDelegate.userPersistentContainer.viewContext
        let caffeineContext = appDelegate.caffeinePersistentContainer.viewContext
        let fetchUserReqeust = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        let insertIntakeValue = updateGoalIntakeValue.convertMgToShot(updateGoalIntakeUnit)
        
        do {
            let userInfos = try context.fetch(fetchUserReqeust)
            guard let userInfo = userInfos.first else {
                isUpdatedGoalCaffeineIntake.onNext(false)
                return }
            let userInfoManagedObject = userInfo as NSManagedObject
            userInfoManagedObject.setValue(Int32(insertIntakeValue), forKey: CoreDataAttributes.goalCaffeineIntake.rawValue)
            userInfoManagedObject.setValue(updateGoalIntakeUnit, forKey: CoreDataAttributes.goalIntakeUnit.rawValue)
            userInfoManagedObject.setValue(IntakeCategory.caffeine.rawValue, forKey: CoreDataAttributes.goalIntakeCategory.rawValue)
            userInfoManagedObject.setValue(nil, forKey: CoreDataAttributes.goalWaterIntake.rawValue)
            userInfoManagedObject.setValue(false, forKey: CoreDataAttributes.isZeroCaffeine.rawValue)
            try context.save()
        } catch {
            print("Update Goal Caffeine Intake ERROR: \(error.localizedDescription)")
            isUpdatedGoalCaffeineIntake.onError(error)
        }
        
        do {
            let caffeineRecords = try caffeineContext.fetch(fetchCaffeineRequest)
            caffeineRecords
                .filter { $0.isCaffeine }
                .forEach {
                    $0.isGoalIntakeExceeded = $0.intake > updateGoalIntakeValue
                }
            caffeineRecords
                .filter { !$0.isCaffeine }
                .forEach {
                    $0.isGoalIntakeExceeded = false
                }
            try caffeineContext.save()
        } catch {
            print("Update Caffeine isGoalIntakeExceeded ERROR: \(error.localizedDescription)")
            isUpdatedGoalCaffeineIntake.onError(error)
        }
        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterName.UpdateGoalCaffeineIntake.rawValue), object: nil)
        isUpdatedGoalCaffeineIntake.onNext(true)
    }
    
    func updateWaterCaffeineIntake(_ updateGoalIntakeValue: Int, _ updateGoalIntakeUnit: String) {
        let userContext = appDelegate.userPersistentContainer.viewContext
        let caffeineContext = appDelegate.caffeinePersistentContainer.viewContext
        let fetchUserRequest = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        
        do {
            let userInfos = try userContext.fetch(fetchUserRequest)
            guard let userInfo = userInfos.first else {
                isUpdatedGoalCaffeineIntake.onNext(false)
                return }
            let userInfoManagedObject = userInfo as NSManagedObject
            userInfoManagedObject.setValue(nil, forKey: CoreDataAttributes.goalCaffeineIntake.rawValue)
            userInfoManagedObject.setValue(Int32(updateGoalIntakeValue), forKey: CoreDataAttributes.goalWaterIntake.rawValue)
            userInfoManagedObject.setValue(updateGoalIntakeUnit, forKey: CoreDataAttributes.goalIntakeUnit.rawValue)
            userInfoManagedObject.setValue(IntakeCategory.water.rawValue, forKey: CoreDataAttributes.goalIntakeCategory.rawValue)
            userInfoManagedObject.setValue(true, forKey: CoreDataAttributes.isZeroCaffeine.rawValue)
            try userContext.save()
        } catch {
            print("Update Goal Water Intake ERROR: \(error.localizedDescription)")
            isUpdatedGoalCaffeineIntake.onError(error)
        }
        
        do {
            let caffeineRecords = try caffeineContext.fetch(fetchCaffeineRequest)
            caffeineRecords.forEach {
                guard !$0.isCaffeine else {
                    $0.isGoalIntakeExceeded = true
                    return }
                $0.isGoalIntakeExceeded = $0.waterIntake < updateGoalIntakeValue
            }
            try caffeineContext.save()
        } catch {
            print("Update Water isGoalIntakeExceeded ERROR: \(error.localizedDescription)")
            isUpdatedGoalCaffeineIntake.onError(error)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterName.UpdateGoalCaffeineIntake.rawValue), object: nil)
        isUpdatedGoalCaffeineIntake.onNext(true)
    }
    
    func isEmptyIntakeValue(_ intakeValue: String) -> Bool {
        return !intakeValue.isEmpty && !(intakeValue == "")
    }
}
