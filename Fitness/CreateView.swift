//
//  CreateView.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 10/26/20.
//

import SwiftUI

struct CreateView: View {
    
    @StateObject private var viewModel = CreateViewModel()
    
    var dropDownList: some View {
        ForEach(viewModel.dropdowns.indices, id: \.self) { index in
            DropdownView(viewModel: $viewModel.dropdowns[index])
        }
    }
    
    var actionSheet: ActionSheet {
        ActionSheet(
            title: Text("Select"),
            buttons: viewModel.displayedOptions.indices.map { index in
                let option = viewModel.displayedOptions[index]
                return ActionSheet.Button.default(Text(option.formatted)) {
                    viewModel.send(action: .selectOption(index: index))
                }
            }
        )
    }
    
    var body: some View {
        ScrollView {
            VStack {
                dropDownList
                
                Spacer()
                
                Button(action: {
                    viewModel.send(action: .createChallenge)
                }) {
                    Text("Create")
                        .font(.system(size: 24, weight: .medium))
                }
            }
            .actionSheet(isPresented: Binding<Bool>(get: {
                viewModel.hasSelectedDropdown
            }, set: { _ in })) {
                actionSheet
            }
            .navigationBarTitle("Create")
            .navigationBarBackButtonHidden(true)
            .padding(.bottom, 15)
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
