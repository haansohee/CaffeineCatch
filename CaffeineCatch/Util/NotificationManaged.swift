//
//  NotificationManaged.swift
//  CaffeineCatch
//
//  Created by 한소희 on 12/9/24.
//

import Foundation
import NotificationCenter

final class NotificationManaged {
    static let shared = NotificationManaged()
    
    func setAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("Notification Authorization Error: \(error.localizedDescription)")
            } else if granted {
                guard let time = UserDefaults.standard.string(forKey: UserDefaultsForKeyName.notificationTime.rawValue) else {
                    self.scheduleDailyNotification(time: Date().toTimeString(), notificationEnabled: true)
                    return }
                self.scheduleDailyNotification(time: time, notificationEnabled: true)
                UserDefaults.standard.set(granted, forKey: UserDefaultsForKeyName.notificationAuthorizationStatus.rawValue)
            } else {
                UserDefaults.standard.set(granted, forKey: UserDefaultsForKeyName.notificationAuthorizationStatus.rawValue)
            }
        }
    }
    
    func scheduleDailyNotification(time: String, notificationEnabled: Bool) {
        guard notificationEnabled else { return }
        guard let notificationTime = time.toTime() else { return }
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "카페인 캐치!"
        content.body = "오늘의 카페인 혹은 물 섭취량을 기록했나요? 👀"
        content.sound = .default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func removeExistingNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
    }
}
