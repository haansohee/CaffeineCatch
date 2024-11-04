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

final class MyGoalViewModel {
    var averageCaffeine: [AverageCaffeineData] = []
    let averageCaffeineSectionData = BehaviorSubject(value: [
        SectionOfAverageCaffeineData(
        header: "averageCaffeine",
        items: [AverageCaffeineData(caffeineData: "믹스커피\n(10g, 1봉)", mgData: "81.3mg")]
                )])
    let isSavedCoreData = PublishSubject<Bool>()
    
    func loadSectionData() {
        let averageCaffeineData = [SectionOfAverageCaffeineData(
            header: "averageCaffeine",
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
    
    func saveCoreDataModelTest() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserInfo", in: context)
        let userInfo = User(usualCaffeineTime: Date(), usualCaffeineIntake: 150, goalCaffeineIntake: 100, notificationEnabled: true)
        
        if let entity = entity {
            let newUserInfo = NSManagedObject(entity: entity, insertInto: context)
            newUserInfo.setValue(userInfo.usualCaffeineTime, forKey: "usualCaffeineTime")
            newUserInfo.setValue(userInfo.usualCaffeineIntake, forKey: "usualCaffeineIntake")
            newUserInfo.setValue(userInfo.goalCaffeineIntake, forKey: "goalCaffeineIntake")
            newUserInfo.setValue(userInfo.notificationEnabled, forKey: "notificationEnabled")
            do {
                try context.save()
                isSavedCoreData.onNext(true)
            } catch {
                isSavedCoreData.onNext(false)
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCoreDataModelTest() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let users = try context.fetch(UserInfo.fetchRequest()) as! [UserInfo]
            users.forEach {
                print($0.usualCaffeineTime ?? Date())
                print($0.usualCaffeineIntake)
                print($0.goalCaffeineIntake)
                print($0.notificationEnabled)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
