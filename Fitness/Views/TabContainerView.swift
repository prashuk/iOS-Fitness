//
//  T.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 10/31/20.
//

import SwiftUI

struct TabContainerView: View {
    @StateObject private var tabContainerViewModel = TabContainerViewModel()
    
    var body: some View {
        TabView(selection: $tabContainerViewModel.selectedTab) {
            ForEach(tabContainerViewModel.tabItemViewModels, id: \.self) { viewModel in
                tabView(for: viewModel.type)
                    .tabItem {
                        Image(systemName: viewModel.image)
                        Text(viewModel.title)
                        
                    }.tag(viewModel.type)
            }
        }.accentColor(.primary)
    }
    
    @ViewBuilder
    func tabView(for tabItemType: TabItemViewModel.TabItemType) -> some View {
        switch tabItemType {
        case .log:
            Text("Log")
        case .challenegeList:
            NavigationView {
                ChallengeListView()
            }
        case .settings:
            Text("Settings")
        }
    }
}

final class TabContainerViewModel: ObservableObject {
    
    @Published var selectedTab: TabItemViewModel.TabItemType = .challenegeList
    
    let tabItemViewModels = [
        TabItemViewModel(image: "book", title: "Activity Log", type: .log),
        .init(image: "list.bullet", title: "Challenges", type: .challenegeList),
        .init(image: "gear", title: "Settings", type: .settings)
    ]
}

struct TabItemViewModel: Hashable {
    let image: String
    let title: String
    let type: TabItemType
    
    enum TabItemType {
        case log
        case challenegeList
        case settings
    }
}
