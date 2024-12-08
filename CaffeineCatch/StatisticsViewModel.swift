//
//  StatisticsViewModel.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/26/24.
//

import UIKit
import Foundation
import CoreData
import RxSwift

final class StatisticsViewModel {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private(set) var caffeineInfoDatas: [CaffeineIntakeInfo] = []
    let caffeineInfoSubject = PublishSubject<Bool>()
    let testSubject = BehaviorSubject(value: ())
    
    func fetchCaffeineInfo() {
        print("fetchCaffeineInfo")
        let context = appDelegate.caffeinePersistentContainer.viewContext
        let fetchUesrRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: "CaffeineIntakeInfo")
        fetchUesrRequest.predicate = NSPredicate(format: "caffeineIntakeDate != nil")
        do {
            let caffeineInfoDatas = try context.fetch(fetchUesrRequest)
            let dateFilter = caffeineInfoDatas.filter {
                guard let date = $0.caffeineIntakeDate else { return false }
                return compareDate(date)
            }
            let caffeineDatas = caffeineInfoDatas
                .filter {
                    $0.isCaffeine
                }
            let nonCaffeineDatas = caffeineDatas
                .filter {
                    !$0.isCaffeine && $0.waterIntake == nil
                }
            let waterIntakeDatas = caffeineInfoDatas
                .filter {
                    !$0.isCaffeine && $0.waterIntake != nil
                }
            
        } catch {
            print("fetch error: \(error.localizedDescription)")
            testSubject.onError(error)
        }
    }
    
    private func sumCaffeineIntake(_ intake: [String]) -> String {
        let intakeSplit = intake.map {
            $0.split(separator: " ").map(String.init)
        }
        let shotValues = intake.map { $0.first.map(String.init) }
        let shotValuesToInt = shotValues.compactMap { Int($0 ?? "0") }
        let caffeineIntakesSum = shotValuesToInt.reduce(0, +)
        return "\(caffeineIntakesSum) shot (\(caffeineIntakesSum * 75)mg)"
    }
    
    private func sumWaterIntake(_ intake: [String]) -> String {
        let intakeSplit = intake.map { $0.split(separator: " ").map(String.init)}
        let waterValues = intake.map { $0.first.map(String.init) }
        let waterValuesToInt = waterValues.compactMap { Int($0 ?? "0") }
        let waterIntakesSum = waterValuesToInt.reduce(0, +)
        return "\(waterIntakesSum) glass (\(waterIntakesSum * 8)oz)"
    }
    
    private func compareDate(_ recordedDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let stringToDate = dateFormatter.date(from: recordedDate) else { return false }
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let recordedYear = calendar.component(.year, from: stringToDate)
        let recordedMonth = calendar.component(.month, from: stringToDate)
        return currentYear == recordedYear && currentMonth == recordedMonth
    }
}
