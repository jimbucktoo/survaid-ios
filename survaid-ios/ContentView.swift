//
//  ContentView.swift
//  survaid-ios
//
//  Created by James Liang on 10/16/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white)
                VStack {
                    Text("Survaid").font(.largeTitle).bold().padding().foregroundColor(.blue)
                    
                    TextField("Username", text: $username).padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).multilineTextAlignment(.center)
                    
                    SecureField("Password", text: $password).padding().frame(width: 300, height: 50).background(Color.black.opacity(0.05)).cornerRadius(10).multilineTextAlignment(.center)
                    
                    NavigationLink(destination: MenuView(), label: {
                        Button("Login") {
                            
                        }
                        .foregroundColor(.white).frame(width: 300, height: 50).background(Color.blue).cornerRadius(10)
                    })
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
