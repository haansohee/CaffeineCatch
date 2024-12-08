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
    let caffeineInfoSubject = BehaviorSubject(value: (caffeine: 0, water: 0, nonCaffeine: 0))
    let nonCaffeineSectionData = BehaviorSubject<[SectionOfInTakeNonCaffeineData]>(
        value: [SectionOfInTakeNonCaffeineData(
            header: SectionHeaderName.nonCaffeine.rawValue,
            items: [InTakeNonCaffeineData(category: "기록이 없어요.", unit: "🥺", intake: 0)])])
    
    func fetchCaffeineInfo() {
        let context = appDelegate.caffeinePersistentContainer.viewContext
        let fetchUesrRequest = NSFetchRequest<CaffeineIntakeInfo>(entityName: "CaffeineIntakeInfo")
        do {
            let caffeineInfoDatas = try context.fetch(fetchUesrRequest)
            let dateFilterCaffeineInfo = caffeineInfoDatas.filter {
                guard let date = $0.caffeineIntakeDate else { return false }
                return compareDate(date)
            }
            
            let caffeineDatas = dateFilterCaffeineInfo
                .filter {
                    $0.isCaffeine
                }
                .map {
                    Int($0.intake)
                }
                .reduce(0, +)
            
            let waterIntakeDatas = dateFilterCaffeineInfo
                .filter {
                    !$0.isCaffeine && $0.intakeCategory == IntakeCategory.water.rawValue
                }
                .map {
                    Int($0.intake)
                }
                .reduce(0, +)
            
            let nonCaffeineDatas = dateFilterCaffeineInfo
                .filter {
                    !$0.isCaffeine && $0.intakeCategory != IntakeCategory.water.rawValue
                }
            
            let nonCaffeineSumValue = nonCaffeineDatas
                .map { Int($0.intake) }
                .reduce(0, +)
            
            let nonCaffeineData = nonCaffeineDatas
                .map {
                    convertToSectionOfInTakeNonCaffeineData(Int($0.intake), $0.intakeCategory ?? "기록이 없어요.", $0.intakeUnit ?? "🥺")
                }
            let nonCaffeine = nonCaffeineSumValue == 0 ? 0 : nonCaffeineSumValue
            let caffeine = caffeineDatas == 0 ?  0 : caffeineDatas
            let water = waterIntakeDatas == 0 ?  0 : waterIntakeDatas
            caffeineInfoSubject.onNext((caffeine: caffeine, water: water, nonCaffeine: nonCaffeine))
            
            nonCaffeineSectionData.onNext(nonCaffeineDatas.isEmpty ? [SectionOfInTakeNonCaffeineData(
                header: SectionHeaderName.nonCaffeine.rawValue,
                items: [InTakeNonCaffeineData(category: "기록이 없어요.", unit: "🥺", intake: 0)])] : nonCaffeineData)
            
        } catch {
            print("fetch error: \(error.localizedDescription)")
            caffeineInfoSubject.onError(error)
        }
    }
    
    private func convertToSectionOfInTakeNonCaffeineData(_ intake: Int, _ category: String, _ unit: String) -> SectionOfInTakeNonCaffeineData {
        return .init(header: SectionHeaderName.nonCaffeine.rawValue, items: [InTakeNonCaffeineData(category: category, unit: unit, intake: intake)])
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
