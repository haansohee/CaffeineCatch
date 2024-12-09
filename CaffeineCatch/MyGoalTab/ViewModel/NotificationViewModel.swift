//
//  NotificationViewModel.swift
//  CaffeineCatch
//
//  Created by 한소희 on 12/9/24.
//

import Foundation
import RxSwift
import CoreData
import UIKit
import UserNotifications

final class NotificationViewModel {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let notificationSetSubject = BehaviorSubject(value: (enabled: false, notificationTime: Date(), authorizationStatus: false ))
    let changedNotificationStatusSubject = BehaviorSubject(value: false)
    
    func fetchUserInformation() {
        let context = appDelegate.userPersistentContainer.viewContext
        let fetchUserReqeust = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        do {
            let userInfos = try context.fetch(fetchUserReqeust)
            guard let userInfo = userInfos.first else {
                notificationSetSubject.onError(MyError.noDataError)
                return }
            let notificationEnabled = userInfo.notificationEnabled
            guard let notificationTimeString = userInfo.notificationTime,
                  let notificationTime = notificationTimeString.toTime() else {
                notificationSetSubject.onError(MyError.noDataError)
                return }
            let notificationAuthorizationStatus = UserDefaults.standard.bool(forKey: UserDefaultsForKeyName.notificationAuthorizationStatus.rawValue)
            notificationSetSubject.onNext((enabled: notificationEnabled, notificationTime: notificationTime, authorizationStatus: notificationAuthorizationStatus))
        } catch {
            print("!! Fetch User Information Error: \(error.localizedDescription)")
            notificationSetSubject.onError(error)
        }
    }
    
    func changeNotificationTime(_ notificationEnabled: Bool, _ time: Date) {
        let notificationTime = time.toTimeString()
        let context = appDelegate.userPersistentContainer.viewContext
        let fetchUserReqeust = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        
        do {
            let userInfos = try context.fetch(fetchUserReqeust)
            userInfos[0].notificationTime = notificationTime
            NotificationManaged.shared.removeExistingNotification()
            NotificationManaged.shared.scheduleDailyNotification(time: notificationTime, notificationEnabled: notificationEnabled)
            try context.save()
        } catch {
            print("ERROR Change Notification Status: \(error.localizedDescription)")
            changedNotificationStatusSubject.onError(error)
        }
        changedNotificationStatusSubject.onNext(true)
    }
    
    func changeNotificationStatus(_ notificationEnabled: Bool, _ time: Date) {
        let notificationTime = time.toTimeString()
        let context = appDelegate.userPersistentContainer.viewContext
        let fetchUserReqeust = NSFetchRequest<UserInfo>(entityName: EntityName.UserInfo.rawValue)
        
        do {
            let userInfos = try context.fetch(fetchUserReqeust)
            userInfos[0].notificationEnabled = notificationEnabled
            if notificationEnabled {
                NotificationManaged.shared.scheduleDailyNotification(time: notificationTime, notificationEnabled: notificationEnabled)
            } else {
                NotificationManaged.shared.removeExistingNotification()
            }
            try context.save()
        } catch {
            print("ERROR Change Notification Status: \(error.localizedDescription)")
            changedNotificationStatusSubject.onError(error)
        }
        changedNotificationStatusSubject.onNext(true)
    }
    
    func postNotificationCenter() {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterName.notification.rawValue), object: nil)
    }
    
    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            UserDefaults.standard.set(settings.authorizationStatus == .authorized, forKey: UserDefaultsForKeyName.notificationAuthorizationStatus.rawValue)
            NotificationCenter.default.post(name: NSNotification.Name(NotificationCenterName.updateNotificationStatus.rawValue), object: nil)
        }
    }
}
