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
    let isUpdatedGoalCaffeineIntake = PublishSubject<Bool>()
    let myGoalCaffeineIntakeSubject = BehaviorSubject(value: "0")
    
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
            guard let userInfo = userInfos.first,
                  let goalCaffeineIntake = userInfo.goalCaffeineIntake else {
                myGoalCaffeineIntakeSubject.onError(MyError.noData)
                return }
            myGoalCaffeineIntakeSubject.onNext(goalCaffeineIntake)
        } catch {
            print("!! Fetch MyGoal Caffeine Intake Error: \(error.localizedDescription)")
            myGoalCaffeineIntakeSubject.onError(error)
        }
    }
    
    func updateGoalCaffeineIntake(_ updateData: String) {
        let context = appDelegate.userPersistentContainer.viewContext
        let fetchUserReqeust = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
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
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterName.UpdateGoalCaffeineIntake.rawValue), object: nil)
            isUpdatedGoalCaffeineIntake.onNext(true)
        } catch {
            print("!! Update Goal Caffeine Intake ERROR: \(error.localizedDescription)")
            isUpdatedGoalCaffeineIntake.onError(error)
        }
    }
    
//    func deleteAllData() { 나중에 쓸 녀석이라 안 지웠어요..
//        let context = appDelegate.userPersistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EntityName.UserInfo.rawValue)
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
}
