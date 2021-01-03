//
//  LandingViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 1/3/21.
//

import SwiftUI

final class LandingViewModel: ObservableObject {
    @Published var loginSignupPush = false
    @Published var createPush = false
    
    let title = "Fitness"
    let createButtonTitle = "Create a Challenge"
    let createButtonImageName = "plus.circle"
    let alreadyButtonTitle = "I already have an account"
    let backgroundImage = "landing"
}
