//
//  FitnessApp.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 10/26/20.
//

import SwiftUI
import Firebase

@main
struct FitnessApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                TabContainerView()
            } else {
                LandingView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

class AppState: ObservableObject {
    @Published private(set) var isLoggedIn = false
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
//        try? Auth.auth().signOut()
        self.userService = userService
        userService
            .observeAuthChanges()
            .map{ $0 != nil }
            .assign(to: &$isLoggedIn)
    }
}
