//
//  CreateViewModel.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 10/26/20.
//

import SwiftUI

final class CreateViewModel: ObservableObject {
    @Published private(set) var dropdowns: [ChallengeViewModel] = []
}

extension CreateViewModel {
    struct ChallengeViewModel: DropdownItemProtocol {
        
    }
}
