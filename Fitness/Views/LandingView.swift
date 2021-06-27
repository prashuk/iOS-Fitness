//
//  ContentView.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 10/26/20.
//

import SwiftUI

struct LandingView: View {
    @StateObject private var viewModel = LandingViewModel()
    
    var title: some View {
        Text(viewModel.title)
            .font(.system(size: 64, weight: .medium))
            .foregroundColor(.white)
    }
    
    var createButton: some View {
        Button(action: {
            viewModel.createPush = true
        }) {
            HStack(spacing: 15) {
                Spacer()
                Image(systemName: viewModel.createButtonImageName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                Text(viewModel.createButtonTitle)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .padding(15)
        .buttonStyle(PrimaryButtonStyle())
    }
    
    var alreadyButton: some View {
        Button(viewModel.alreadyButtonTitle) {
            viewModel.loginSignupPush = true
        }.foregroundColor(.white)
    }
    
    var backGroundImage: some View {
        Image(viewModel.backgroundImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay(Color.black.opacity(0.5))
    }
    
    var body: some View {
        NavigationView {
            GeometryReader{ proxy in
                VStack {
                    Spacer()
                        .frame(height: proxy.size.height * 0.08)
                    title
                    Spacer()
                    NavigationLink(destination: CreateView(), isActive: $viewModel.createPush) {}
                    createButton
                    NavigationLink(destination: LoginSignupView(viewModel: .init(mode: .login, isPushed: $viewModel.loginSignupPush)), isActive: $viewModel.loginSignupPush) {
                    }
                    alreadyButton
                }
                .padding(.bottom, 15)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    backGroundImage
                        .frame(width: proxy.size.width)
                        .edgesIgnoringSafeArea(.all)
                )
                
            }
        }
        .accentColor(.primary)
    }
}

struct LandingViewPreview: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
