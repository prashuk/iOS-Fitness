//
//  ChallengeListViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 11/1/20.
//

import Foundation

final class ChallengeListViewModel: ObservableObject {
    private var userService: UserServiceProtocol
    private var challengeService: ChallengeServiceProtocol
    
    init(
        userService: UserServiceProtocol = UserService(),
        challengeService: ChallengeServiceProtocol = ChallengeService()
    ) {
        self.userService = userService
        self.challengeService = challengeService
    }
}
