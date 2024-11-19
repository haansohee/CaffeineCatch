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
    case noData
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
    let userInfoSubject = BehaviorSubject(value: ("0", false))
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
                userInfoSubject.onError(MyError.noData)
                return }
            let goalIntake = userInfo.goalCaffeineIntake ?? userInfo.goalWaterIntake
            let isZeroCaffeine = userInfo.isZeroCaffeine
            guard let goalIntake = goalIntake else {
                userInfoSubject.onError(MyError.noData)
                return }
            userInfoSubject.onNext((goalIntake, isZeroCaffeine))
        } catch {
            print("!! Fetch MyGoal Caffeine Intake Error: \(error.localizedDescription)")
            userInfoSubject.onError(error)
        }
    }
    
    func updateGoalCaffeineIntake(_ updateData: String) {
        let context = appDelegate.userPersistentContainer.viewContext
        let caffeineContext = appDelegate.caffeinePersistentContainer.viewContext
        let fetchUserReqeust = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        let fetchCaffeineRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: EntityName.CaffeineIntakeInfo.rawValue)
        guard let insertIntakeValue = updateData.convertMgToShot() else {
            isUpdatedGoalCaffeineIntake.onNext(false)
            return }
        do {
            let userInfos = try context.fetch(fetchUserReqeust)
            guard let userInfo = userInfos.first else {
                isUpdatedGoalCaffeineIntake.onNext(false)
                return }
            let userInfoManagedObject = userInfo as NSManagedObject
            userInfoManagedObject.setValue("\(insertIntakeValue) 이하", forKey: CoreDataAttributes.goalCaffeineIntake.rawValue)
            userInfoManagedObject.setValue(nil, forKey: CoreDataAttributes.goalWaterIntake.rawValue)
            userInfoManagedObject.setValue(false, forKey: CoreDataAttributes.isZeroCaffeine.rawValue)
            try context.save()
            let caffeineRecords = try caffeineContext.fetch(fetchCaffeineRequest)
            caffeineRecords
                .filter { $0.isCaffeine }
                .forEach {
                    guard let intake = $0.intake else { return }
                    $0.isGoalIntakeExceeded = convertCaffeineIsGoalIntakeExceeded(intake, goalData: insertIntakeValue)
                }
            caffeineRecords
                .filter { !$0.isCaffeine }
                .forEach {
                    $0.isGoalIntakeExceeded = false
                }
            try caffeineContext.save()
            NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterName.UpdateGoalCaffeineIntake.rawValue), object: nil)
            isUpdatedGoalCaffeineIntake.onNext(true)
        } catch {
            print("Update Goal Caffeine Intake ERROR: \(error.localizedDescription)")
            isUpdatedGoalCaffeineIntake.onError(error)
        }
    }
    
    func updateWaterCaffeineIntake(_ updateData: String) {
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
            userInfoManagedObject.setValue(updateData, forKey: CoreDataAttributes.goalWaterIntake.rawValue)
            userInfoManagedObject.setValue(true, forKey: CoreDataAttributes.isZeroCaffeine.rawValue)
            try userContext.save()
            let caffeineRecords = try caffeineContext.fetch(fetchCaffeineRequest)
            caffeineRecords.forEach {
                guard !$0.isCaffeine else {
                    $0.isGoalIntakeExceeded = true
                    return }
                guard let waterIntake = $0.waterIntake else { return }
                $0.isGoalIntakeExceeded = convertWaterIsGoalIntakeExceeded(waterIntake, goalData: updateData)
            }
            try caffeineContext.save()
            NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterName.UpdateGoalCaffeineIntake.rawValue), object: nil)
            isUpdatedGoalCaffeineIntake.onNext(true)
        } catch {
            print("Update Goal Water Intake ERROR: \(error.localizedDescription)")
            isUpdatedGoalCaffeineIntake.onError(error)
        }
    }
    private func convertStringToInt(_ value: String) -> Int {
        let inputData = value.split(separator: " ").map(String.init)
        guard let value = inputData.first,
              let valueInt = Int(value) else { return 0 }
        return valueInt
    }
    
    private func convertCaffeineIsGoalIntakeExceeded(_ savedData: String, goalData: String) -> Bool {
        let savedDataToInt = convertStringToInt(savedData)
        let goalDataToInt = convertStringToInt(goalData)
        return savedDataToInt > goalDataToInt
    }
    
    private func convertWaterIsGoalIntakeExceeded(_ savedData: String, goalData: String) -> Bool {
        let goalData = goalData.split(separator: " ").map(String.init)
        guard let goalDataString = goalData.first,
              let savedDataToInt = Int(savedData),
              let goalDataToInt = Int(goalDataString) else { return false }
        return savedDataToInt < goalDataToInt
    }
}
