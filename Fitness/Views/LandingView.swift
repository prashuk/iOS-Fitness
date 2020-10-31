//
//  ContentView.swift
//  Fitness
//
//  Created by Prashuk Ajmera on 10/26/20.
//

import SwiftUI

struct LandingView: View {
    
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
            GeometryReader{ proxy in
                VStack {
                    Spacer()
                        .frame(height: proxy.size.height * 0.08)
                    
                    Text("Fitness")
                        .font(.system(size: 64, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: CreateView(),
                        isActive: $isActive
                    ) {
                        Button(action: {
                            isActive = true
                        }) {
                            HStack(spacing: 15) {
                                Spacer()
                                
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Create a challeneg")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                        }
                        .padding(15)
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Image("landing")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(Color.black.opacity(0.5))
                        .frame(width: proxy.size.width)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                )
                
            }
        }
        .accentColor(.primary)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView().previewDevice("iPhone 8")
        LandingView().previewDevice("iPhone 12 Pro")
        LandingView().previewDevice("iPhone 12 Pro Max")
    }
}
