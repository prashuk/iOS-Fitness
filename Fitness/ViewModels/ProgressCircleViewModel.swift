//
//  ProgressCircleViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 1/3/21.
//

import Foundation

struct ProgressCircleViewModel {
    let title: String
    let message: String
    let percentageComplete: Double
    var shouldShowTitle: Bool {
        percentageComplete <= 1
    }
}
