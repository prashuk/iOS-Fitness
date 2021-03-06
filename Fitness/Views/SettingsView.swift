//
//  SettingsView.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 1/3/21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        List(viewModel.itemViewModels.indices, id: \.self) { index in
            Button {
                viewModel.tapped(at: index)
            } label: {
                HStack {
                    Image(systemName: viewModel.item(at: index).iconName)
                    Text(viewModel.item(at: index).title)
                }
            }
        }
        .background(
            NavigationLink(
                destination: LoginSignupView(viewModel: .init(mode: .signup, isPushed: $viewModel.loginSignupPush)),
                isActive: $viewModel.loginSignupPush
            ) {
                
            }
        )
        .navigationTitle(viewModel.title)
        .onAppear {
            viewModel.onAppear()
        }
    }
}
