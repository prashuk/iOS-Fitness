//
//  ChallengeItemViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 1/3/21.
//

import Foundation

struct ChallengeItemViewModel: Hashable {
    private let challenge: Challenge
    
    let trashImageName = "trash"
    
    var title: String {
        challenge.excercise.capitalized
    }
    
    var progressCircleViewModel: ProgressCircleViewModel {
        let dayNumber = daysFromStart + 1
        let title = "Day"
        let message = isComplete ? "Done" : "\(dayNumber) of \(challenge.length)"
        return .init(title: title, message: message, percentageComplete: Double(dayNumber) / Double(challenge.length))
    }
    
    private var daysFromStart: Int {
        let startDate = Calendar.current.startOfDay(for: challenge.startDate)
        let toDate = Calendar.current.startOfDay(for: Date())
        guard let daysFromStart = Calendar.current.dateComponents([.day], from: startDate, to: toDate).day else { return 0 }
        return abs(daysFromStart)
    }
    
    private var isComplete: Bool {
        daysFromStart - challenge.length >= 0
    }
    
    var statusText: String {
        guard !isComplete else { return "Done" }
        
        let dayNumber = daysFromStart + 1
        return "Day \(dayNumber) of \(challenge.length)"
    }
    
    var dailyIncreaseText: String {
        "+\(challenge.increase) daily"
    }
    
    init(_ challenge: Challenge) {
        self.challenge = challenge
    }
}
