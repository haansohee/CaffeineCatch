//
//  SplashViewModel.swift
//  CaffeineCatch
//
//  Created by 한소희 on 11/18/24.
//

import Foundation
import RxSwift

final class SplashViewModel {
    private var isTutorialComplete: Bool
    let isTutorialCompleteSubject = BehaviorSubject<Bool>(value: false)
    
    init(isTutorialComplete: Bool) {
        self.isTutorialComplete = isTutorialComplete
    }
    
    func checkTutorial() {
        isTutorialCompleteSubject.onNext(isTutorialComplete)
    }
}
