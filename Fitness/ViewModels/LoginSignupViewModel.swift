//
//  LoginSignupViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 1/3/21.
//

import SwiftUI
import Combine

final class LoginSignupViewModel: ObservableObject {
    private let mode: Mode
    private let userService: UserServiceProtocol
    private var cancellables: [AnyCancellable] = []
    
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isValid = false
    @Binding var isPushed: Bool
    
    private(set) var emailPlaceholder = "Email"
    private(set) var passwordPlaceholder = "Password"
    
    init(
        mode: Mode,
        userService: UserServiceProtocol = UserService(),
        isPushed: Binding<Bool>
    ) {
        self.mode = mode
        self.userService = userService
        self._isPushed = isPushed
        
        Publishers.CombineLatest($emailText, $passwordText)
            .map { [weak self] email, password in
                guard let self = self else { return false }
                return self.isValidEmail(email) && self.isValidPassword(password)
            }.assign(to: &$isValid)
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
    
    func tappedActionButton() {
        switch mode {
        case .login:
            userService.login(email: emailText, password: passwordText).sink { (completion) in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
            
        case .signup:
            userService.linkAccount(email: emailText, password: passwordText).sink { [weak self] (completion) in
                guard let self = self else { return }
                
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                    self.isPushed = false
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        }
    }
}

extension LoginSignupViewModel {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) && email.count > 5
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count > 5
    }
}

extension LoginSignupViewModel {
    enum Mode {
        case login
        case signup
    }
}
