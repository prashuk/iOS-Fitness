//
//  SettingsViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 1/3/21.
//

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Published private(set) var itemViewModels: [SettingsItemViewModel] = []
    @Published var loginSignupPush = false
    
    private var cancellables: [AnyCancellable] = []
    private let userService: UserServiceProtocol
    
    let title = "Settings"
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func item(at index: Int) -> SettingsItemViewModel {
        itemViewModels[index]
    }
    
    func tapped(at index: Int) {
        switch itemViewModels[index].type {
        case .account:
            guard userService.currentUser?.email == nil else { return }
            
            loginSignupPush = true
        case .mode:
            isDarkMode = !isDarkMode
            buildItems()
        case .logout:
            userService.logout().sink { (completion) in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)

        default:
            break
        }
    }
    
    private func buildItems() {
        itemViewModels = [
            .init(title: userService.currentUser?.email ?? "Create Account", iconName: "person.circle", type: .account),
            .init(title: "Switch to \(isDarkMode ? "Light" : "Dark") Mode", iconName: "lightbulb", type: .mode),
            .init(title: "Privacy Policy", iconName: "shield", type: .privacy)
        ]
        
        if userService.currentUser?.email != nil {
            itemViewModels += [.init(title: "Logout", iconName: "arrowshape.turn.up.left", type: .logout)]
        }
    }
    
    func onAppear() {
        buildItems()
    }
}
