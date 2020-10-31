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
    
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
