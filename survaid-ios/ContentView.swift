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
                Circle().scale(1.7).foregroundColor(.orange)
                Circle().scale(1.35).foregroundColor(.black)
                VStack {
                    Text("Survaid").font(.largeTitle).bold().padding().foregroundColor(.blue)
                    TextField("",
                              text: $username,
                              prompt: Text("Username")
                                        .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center)
                    SecureField("",
                                text: $password,
                                prompt: Text("Password")
                                          .foregroundColor(.black)
                    ).frame(width: 300, height: 50, alignment: .center).background(Color.white).cornerRadius(10).multilineTextAlignment(.center)
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
