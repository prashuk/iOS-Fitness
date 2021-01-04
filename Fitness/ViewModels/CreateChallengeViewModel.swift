//
//  CreateChallengeViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 10/26/20.
//

import SwiftUI
import Combine
import Firebase

typealias UserId = String

final class CreateChallengeViewModel: ObservableObject {
    @Published var excerciseDropdown = ChallengePartViewModel(type: .excercise)
    @Published var increaseDropdown = ChallengePartViewModel(type: .increase)
    @Published var startAmountDropdown = ChallengePartViewModel(type: .startAmount)
    @Published var lengthDropdown = ChallengePartViewModel(type: .length)
    
    @Published var error: IncrementError?
    @Published var isLoading = false
    
    private let userService: UserServiceProtocol
    private let challengeService: ChallengeServiceProtocol
    private var cancellables: [AnyCancellable] = []
    
    let createTitle = "Create"
    let errorTitle = "Error!"
    let ok = "Ok"
    
    enum Action {
        case createChallenge
    }
    
    init(userService: UserServiceProtocol = UserService(), challengeService: ChallengeServiceProtocol = ChallengeService()) {
        self.userService = userService
        self.challengeService = challengeService
    }
    
    func send(action: Action) {
        switch action {
        case .createChallenge:
            isLoading = true
            currentUserId().flatMap { userId -> AnyPublisher<Void, IncrementError> in
                return self.createChallenge(userId: userId)
            }.sink { completion in
                self.isLoading = false
                switch completion {
                case let .failure(error):
                    self.error = error
                case .finished:
                    print("finished")
                }
            } receiveValue: { _ in
                print("success")
            }.store(in: &cancellables)
        }
    }
    
    private func createChallenge(userId: UserId) -> AnyPublisher<Void, IncrementError> {
        guard let excercise = excerciseDropdown.text,
              let startAmount = startAmountDropdown.number,
              let increase = increaseDropdown.number,
              let length = lengthDropdown.number else {
            return Fail(error: .default(description: "Parsing error")).eraseToAnyPublisher()
        }
        
        let challenge = Challenge(
            excercise: excercise,
            startAmount: startAmount,
            increase: increase,
            length: length,
            usrId: userId,
            startDate: Date()
        )
        
        return challengeService.create(challenge).eraseToAnyPublisher()
    }
    
    private func currentUserId() -> AnyPublisher<UserId, IncrementError> {
        return self.userService.currentUserPublisher().flatMap { user -> AnyPublisher<UserId, IncrementError> in
            if let userId = user?.uid {
                return Just(userId)
                    .setFailureType(to: IncrementError.self)
                    .eraseToAnyPublisher()
            } else {
                return self.userService
                    .signInAnonymously()
                    .map{ $0.uid }
                    .eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
}

extension CreateChallengeViewModel {
    struct ChallengePartViewModel: DropdownItemProtocol {
        var selectedOption: DropdownOption
        
        var options: [DropdownOption]
        
        var headerTitle: String {
            type.rawValue
        }
        
        var drodownTitle: String {
            selectedOption.formatted
        }
        
        var isSelected: Bool = false
        
        private let type: ChallengePartType
        
        init(type: ChallengePartType) {
            
            switch type {
            case .excercise:
                self.options = ExcerciseOption.allCases.map { $0.toDropDown }
            case .startAmount:
                self.options = StartOption.allCases.map { $0.toDropDown }
            case .increase:
                self.options = IncreaseeOption.allCases.map { $0.toDropDown }
            case .length:
                self.options = LengthOption.allCases.map { $0.toDropDown }
            }
            self.type = type
            self.selectedOption = options.first!
        }
        
        enum ChallengePartType: String, CaseIterable {
            case excercise = "Excercise"
            case startAmount = "Starting Amount"
            case increase = "Daily Increase"
            case length = "Challenge Length"
        }
        
        enum ExcerciseOption: String, CaseIterable, DropdownOptionProtocol {
            case pullups
            case pushups
            case situps
            
            var toDropDown: DropdownOption {
                .init(type: .text(rawValue), formatted: rawValue.capitalized)
            }
        }
        
        enum StartOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropDown: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue)")
            }
        }
        
        enum IncreaseeOption: Int, CaseIterable, DropdownOptionProtocol {
            case one = 1, two, three, four, five
            
            var toDropDown: DropdownOption {
                .init(type: .number(rawValue), formatted: "+\(rawValue)")
            }
        }
        
        enum LengthOption: Int, CaseIterable, DropdownOptionProtocol {
            case seven = 7, fourteen = 14, twentyOne = 21, twentyEight = 28
            
            var toDropDown: DropdownOption {
                .init(type: .number(rawValue), formatted: "\(rawValue) Days")
            }
        }
    }
}

extension CreateChallengeViewModel.ChallengePartViewModel {
    var text: String? {
        if case let .text(text) = selectedOption.type {
            return text
        }
        return nil
    }
    
    var number: Int? {
        if case let .number(number) = selectedOption.type {
            return number
        }
        return nil
    }
}
