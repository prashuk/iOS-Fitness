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
    
    @Published private(set) var itemViewModel: [ChallengeItemViewModel] = []
    @Published private(set) var error: IncrementError?
    @Published private(set) var isLoading = false
    @Published var showCreateModal = false
    
    let title = "Challenges"
    let retry = "Retry"
    let createImageName = "plus.circle"
    
    enum Action {
        case retry
        case create
    }
    
    init(
        userService: UserServiceProtocol = UserService(),
        challengeService: ChallengeServiceProtocol = ChallengeService()
    ) {
        self.userService = userService
        self.challengeService = challengeService
        observerChallenges()
    }
    
    func send(action: Action) {
        switch action {
        case .retry:
            observerChallenges()
        case .create:
            showCreateModal = true
        }
    }
    
    func observerChallenges() {
        isLoading = true
        userService.currentUser()
            .compactMap {
                return $0?.uid
            }
            .flatMap { [weak self] userId -> AnyPublisher<[Challenge], IncrementError> in
                guard let self = self else { return Fail(error: .default()).eraseToAnyPublisher() }
                
                return self.challengeService.observeChallenges(userId: userId)
            }.sink { [weak self] (completion) in
                guard let self = self else { return }
                
                self.isLoading = false
                switch completion {
                case let .failure(error):
                    self.error = error
                case .finished:
                    print("finished")
                }
            } receiveValue: { [weak self] challenges in
                guard let self = self else { return }
                
                self.isLoading = false
                self.error = nil
                self.showCreateModal = false
                self.itemViewModel = challenges.map { .init($0) }
            }.store(in: &cancellable)
    }
}
