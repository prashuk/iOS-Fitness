//
//  CreateViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 10/26/20.
//

import SwiftUI
import Combine
import Firebase

typealias UserId = String

final class CreateViewModel: ObservableObject {
    
    @Published var excerciseDropdown = ChallengeViewModel(type: .excercise)
    @Published var increaseDropdown = ChallengeViewModel(type: .increase)
    @Published var startAmountDropdown = ChallengeViewModel(type: .startAmount)
    @Published var lengthDropdown = ChallengeViewModel(type: .length)
    
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []
    
    enum Action {
        case createChallenge
    }
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func send(action: Action) {
        switch action {
        case .createChallenge:
            currentUserId().sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("Completed")
                }
            } receiveValue: { (userId) in
                print("Retrieve User Id = \(userId)")
            }.store(in: &cancellables)
        }
    }
    
    private func currentUserId() -> AnyPublisher<UserId, Error> {
        return self.userService.currentUser().flatMap { user -> AnyPublisher<UserId, Error> in
            if let userId = user?.uid {
                return Just(userId)
                    .setFailureType(to: Error.self)
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

extension CreateViewModel {
    struct ChallengeViewModel: DropdownItemProtocol {
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
