//
//  TutorialViewModel.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/12/24.
//

import Foundation
import UIKit
import RxSwift
import CoreData

final class TutorialViewModel {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let isSavedSuccess = PublishSubject<Bool>()
    let caffeineIntakeSubject = BehaviorSubject(value: "0")
    
    func saveUsualCaffeineIntake(_ caffeineIntake: Int) {
        let context = appDelegate.userPersistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: EntityName.UserInfo.rawValue, in: context)
        guard let entity else {
            isSavedSuccess.onNext(false)
            return }
        let fetchRequest: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        do {
            let userInfos = try context.fetch(fetchRequest)
            guard let userInfo = userInfos.first else {
                let newUserInfo = NSManagedObject(entity: entity, insertInto: context)
                newUserInfo.setValue(Int32(caffeineIntake), forKey: CoreDataAttributes.usualCaffeineIntake.rawValue)
                try context.save()
                isSavedSuccess.onNext(true)
                return }
            let userInfoManagedObject = userInfo as NSManagedObject
            userInfoManagedObject.setValue(Int32(caffeineIntake), forKey: CoreDataAttributes.usualCaffeineIntake.rawValue)
            try context.save()
            isSavedSuccess.onNext(true)
        } catch {
            print("ERROR! save usual caffeine intake: \(error.localizedDescription)")
            isSavedSuccess.onNext(false)
        }
    }
    
    func recommandGoalCaffeineIntake() {
        let context = appDelegate.userPersistentContainer.viewContext
        do {
            let fetchRequest = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
            fetchRequest.predicate = NSPredicate(format: "usualCaffeineIntake != nil")
            let userInfos = try context.fetch(fetchRequest)
            guard let userInfo = userInfos.first
            else {
                caffeineIntakeSubject.onNext("0")
                return }
            let usualCaffeineIntake = userInfo.usualCaffeineIntake
            guard let recommandCaffeineInatke = recommandCaffeineIntake(Int(usualCaffeineIntake)) else { return }
            let recommandIntake = recommandCaffeineInatke.isZeroCaffeineUser ?
            "\(recommandCaffeineInatke.intakeCategory) \(String(recommandCaffeineInatke.goalIntakeValue)) \(recommandCaffeineInatke.intakeUnit) 이상 마시기" : "\(recommandCaffeineInatke.intakeCategory) \(String(recommandCaffeineInatke.goalIntakeValue)) \(recommandCaffeineInatke.intakeUnit) 이하로 마시기"
//            caffeineIntakeSubject.onNext(recommandCaffeineInatke.0)
            caffeineIntakeSubject.onNext(recommandIntake)
        } catch {
            print("ERROR save goal caffeine intake: \(error.localizedDescription)")
            caffeineIntakeSubject.onNext("0")
        }
    }
    
    func saveGoalCaffeineIntake(intakeCategory: String? = nil,
                                intakeUnitValue: String? = nil,
                                intakeValue: Int? = nil,
                                isWater: Bool? = nil) {
        let context = appDelegate.userPersistentContainer.viewContext
        do {
            let fetchRequest = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
            fetchRequest.predicate = NSPredicate(format: "usualCaffeineIntake != nil")
            let userInfos = try context.fetch(fetchRequest)
            guard let userInfo = userInfos.first
            else {
                isSavedSuccess.onNext(false)
                return }
            let usualCaffeineIntake = userInfo.usualCaffeineIntake
            let userInfoManagedObject = userInfo as NSManagedObject
            guard let isWater = isWater else {
                let myGoalCaffeineIntake = recommandCaffeineIntake(Int(usualCaffeineIntake))
                guard let goalIntake = myGoalCaffeineIntake?.goalIntakeValue,
                      let intakeCategory = myGoalCaffeineIntake?.intakeCategory,
                      let intakeUnit = myGoalCaffeineIntake?.intakeUnit,
                      let isZeroCaffeine = myGoalCaffeineIntake?.isZeroCaffeineUser else {
                    isSavedSuccess.onNext(false)
                    return
                }
                userInfoManagedObject.setValue(Int32(goalIntake), forKey: CoreDataAttributes.goalCaffeineIntake.rawValue)
                userInfoManagedObject.setValue(intakeCategory, forKey: CoreDataAttributes.goalIntakeCategory.rawValue)
                userInfoManagedObject.setValue(intakeUnit, forKey: CoreDataAttributes.goalIntakeUnit.rawValue)
                userInfoManagedObject.setValue(isZeroCaffeine, forKey: CoreDataAttributes.isZeroCaffeine.rawValue)
                try context.save()
                isSavedSuccess.onNext(true)
                return
            }
            guard let intakeValue = intakeValue else {
                isSavedSuccess.onNext(false)
                return }
            userInfoManagedObject.setValue(Int32(intakeValue), forKey: CoreDataAttributes.goalCaffeineIntake.rawValue)
            userInfoManagedObject.setValue(intakeCategory, forKey: CoreDataAttributes.goalIntakeCategory.rawValue)
            userInfoManagedObject.setValue(intakeUnitValue, forKey: CoreDataAttributes.goalIntakeUnit.rawValue)
            userInfoManagedObject.setValue(isWater, forKey: CoreDataAttributes.isZeroCaffeine.rawValue)
            try context.save()
            isSavedSuccess.onNext(true)
            } catch {
                print("ERROR save goal caffeine intake: \(error.localizedDescription)")
                isSavedSuccess.onNext(false)
            }
            
        }
        
        func saveNotificationState(isEnabled: Bool, time: String? = nil) {
            let context = appDelegate.userPersistentContainer.viewContext
            do {
                let fetchRequest = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
                fetchRequest.predicate = NSPredicate(format: "usualCaffeineIntake != nil")
                let userInfos = try context.fetch(fetchRequest)
                guard let userInfo = userInfos.first else {
                    isSavedSuccess.onNext(false)
                    return }
                let userInfoManagedObject = userInfo as NSManagedObject
                userInfoManagedObject.setValue(isEnabled, forKey: CoreDataAttributes.notificationEnabled.rawValue)
                userInfoManagedObject.setValue(time ?? nil, forKey: CoreDataAttributes.notificationTime.rawValue)
                try context.save()
                UserDefaults.standard.set(true, forKey: UserDefaultsForKeyName.tutorial.rawValue)
                isSavedSuccess.onNext(true)
            } catch {
                print("ERROR save notification state: \(error.localizedDescription)")
                isSavedSuccess.onNext(false)
            }
        }

        private func recommandCaffeineIntake(_ caffeineIntake: Int) -> (goalIntakeValue: Int,
                                                                           intakeCategory: String,
                                                                           intakeUnit: String,
                                                                           isZeroCaffeineUser: Bool)? {
            let goalIntakeValue = caffeineIntake == 1 ? 250 : caffeineIntake
            let intakeCategory = caffeineIntake == 1 ? IntakeCategory.water.rawValue : IntakeCategory.caffeine.rawValue
            let intakeUnit = caffeineIntake == 1 ? IntakeUnitName.mL.rawValue : IntakeUnitName.shot.rawValue
            let isZeroCaffeineUser = caffeineIntake == 1
            return (goalIntakeValue: goalIntakeValue,
                    intakeCategory: intakeCategory,
                    intakeUnit: intakeUnit,
                    isZeroCaffeineUser: isZeroCaffeineUser)
        }
    }
