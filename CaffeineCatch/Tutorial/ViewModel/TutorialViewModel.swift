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
    
    func saveUsualCaffeineIntake(_ caffeineIntake: String) {
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
                newUserInfo.setValue(caffeineIntake, forKey: CoreDataAttributes.usualCaffeineIntake.rawValue)
                try context.save()
                isSavedSuccess.onNext(true)
                return }
            let userInfoManagedObject = userInfo as NSManagedObject
            userInfoManagedObject.setValue(caffeineIntake, forKey: CoreDataAttributes.usualCaffeineIntake.rawValue)
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
            guard let userInfo = userInfos.first,
                  let usualCaffeineIntake = userInfo.usualCaffeineIntake
            else {
                caffeineIntakeSubject.onNext("0")
                return }
            guard let recommandCaffeineInatke = recommandCaffeineIntake(usualCaffeineIntake) else { return }
            caffeineIntakeSubject.onNext(recommandCaffeineInatke.0)
        } catch {
            print("ERROR save goal caffeine intake: \(error.localizedDescription)")
            caffeineIntakeSubject.onNext("0")
        }
    }
    
    func saveGoalCaffeineIntake(_ goalCaffeineIntake: String? = nil, isWater: Bool? = nil) {
        let context = appDelegate.userPersistentContainer.viewContext
        do {
            let fetchRequest = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
            fetchRequest.predicate = NSPredicate(format: "usualCaffeineIntake != nil")
            let userInfos = try context.fetch(fetchRequest)
            guard let userInfo = userInfos.first,
                  let usualCaffeineIntake = userInfo.usualCaffeineIntake
            else {
                isSavedSuccess.onNext(false)
                return }
            let userInfoManagedObject = userInfo as NSManagedObject
            guard let isWater = isWater else {
                let myGoalCaffeineIntake = recommandCaffeineIntake(usualCaffeineIntake)
                guard let goalIntake = myGoalCaffeineIntake?.0,
                      let isZeroCaffeine = myGoalCaffeineIntake?.1 else {
                    isSavedSuccess.onNext(false)
                    return
                }
                userInfoManagedObject.setValue(goalIntake, forKey: CoreDataAttributes.goalCaffeineIntake.rawValue)
                userInfoManagedObject.setValue(isZeroCaffeine, forKey: CoreDataAttributes.isZeroCaffeine.rawValue)
                try context.save()
                isSavedSuccess.onNext(true)
                return }
            userInfoManagedObject.setValue(isWater, forKey: CoreDataAttributes.isZeroCaffeine.rawValue)
            if isWater {
                guard let myGoalWaterIntake = goalCaffeineIntake else {
                    isSavedSuccess.onNext(false)
                    return }
                let myGoalWaterIntakeSplit = myGoalWaterIntake.split(separator: " ").map(String.init)
                guard let myGoalWaterIntakeData = myGoalWaterIntakeSplit.first else {
                    isSavedSuccess.onNext(false)
                    return }
                userInfoManagedObject.setValue("\(myGoalWaterIntakeData) mL", forKey: CoreDataAttributes.goalWaterIntake.rawValue)
                try context.save()
                isSavedSuccess.onNext(true)
            } else {
                guard let myGoalCaffeineIntake = goalCaffeineIntake?.convertMgToShot() else {
                    isSavedSuccess.onNext(false)
                    return }
                userInfoManagedObject.setValue("\(myGoalCaffeineIntake) 이하", forKey: CoreDataAttributes.goalCaffeineIntake.rawValue)
                try context.save()
                isSavedSuccess.onNext(true)
            }
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
    
    private func recommandCaffeineIntake(_ caffeineIntake: String) -> (String, Bool)? {
        switch caffeineIntake {
        case Caffeine.oneShot.rawValue: return ("물 250ml 마시기", true)
        case Caffeine.twoShot.rawValue: return ("\(Caffeine.oneShot.rawValue) 이하", false)
        case Caffeine.threeShot.rawValue: return ("\(Caffeine.oneShot.rawValue) 이하", false)
        case Caffeine.fourShot.rawValue: return ("\(Caffeine.twoShot.rawValue) 이하", false)
        default: return nil
        }
    }
}