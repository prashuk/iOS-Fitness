//
//  LoginSignupViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 1/3/21.
//

import Foundation

final class LoginSignupViewModel: ObservableObject {
    private let mode: Mode
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isValid = false
    var emailPlaceholder = "Email"
    var passwordPlaceholder = "Password"
    
    
    init(mode: Mode) {
        self.mode = mode
    }
    
    var title: String {
        switch mode {
        case .login:
            return "Welcome Back!"
        case .signup:
            return "Create an Account"
        }
    }
    
    var subTitle: String {
        switch mode {
        case .login:
            return "Login with your email"
        case .signup:
            return "Sign up via email"
        }
    }
    
    var buttonTitle: String {
        switch mode {
        case .login:
            return "Log in"
        case .signup:
            return "Sign up"
        }
    }
}

extension LoginSignupViewModel {
    enum Mode {
        case login
        case signup
    }
}
