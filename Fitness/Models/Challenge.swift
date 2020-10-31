//
//  Challenge.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 10/30/20.
//

import Foundation

struct Challenge: Codable {
    let excercise: String
    let startAmount: Int
    let increase: Int
    let length: Int
    let usrId: String
    let startDate: Date
}
