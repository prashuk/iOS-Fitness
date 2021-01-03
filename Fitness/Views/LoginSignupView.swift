//
//  LoginSignupView.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 1/3/21.
//

import SwiftUI

struct LoginSignupView: View {
    @ObservedObject var viewModel: LoginSignupViewModel
    
    var emailTextField: some View {
        TextField(viewModel.emailPlaceholder, text: $viewModel.emailText)
            .modifier(TextFieldCustomRoundedStyle())
    }
    
    var passwordTextField: some View {
        SecureField(viewModel.passwordPlaceholder, text: $viewModel.passwordText)
            .modifier(TextFieldCustomRoundedStyle())
    }
    
    var actionButton: some View {
        Button(viewModel.buttonTitle) {
            // action
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color(.systemPink))
        .cornerRadius(16)
        .padding()
    }
    
    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewModel.subTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(.systemGray2))
            Spacer().frame(height: 50)
            emailTextField
            passwordTextField
            actionButton
        }
        .padding()
    }
}
