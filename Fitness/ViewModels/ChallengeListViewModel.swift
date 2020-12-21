//
//  ChallengeListViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 11/1/20.
//

import Foundation
import Combine

final class ChallengeListViewModel: ObservableObject {
    private var userService: UserServiceProtocol
    private var challengeService: ChallengeServiceProtocol
    private var cancellable: [AnyCancellable] = []
    
    init(
        userService: UserServiceProtocol = UserService(),
        challengeService: ChallengeServiceProtocol = ChallengeService()
    ) {
        self.userService = userService
        self.challengeService = challengeService
        observerChallenges()
    }
    
    func observerChallenges() {
        userService.currentUser()
            .compactMap {
                return $0?.uid
            }
            .flatMap { userId -> AnyPublisher<[Challenge], IncrementError> in
                return self.challengeService.observeChallenges(userId: userId)
            }.sink { (completion) in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { challenges in
                print(challenges)
            }.store(in: &cancellable)
    }
}
