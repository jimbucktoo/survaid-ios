//
//  ProfileView.swift
//  survaid-ios
//
//  Created by James Liang on 10/16/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var index = 0
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.survaidBlue)
                Text("Jimmy Liang")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.survaidBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 160)
                    Image("jamesliang")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        .offset(y: 0)
                        .offset(x: -80)
                    Text("Jimmy Liang")
                        .foregroundColor(.survaidBlue)
                        .fontWeight(.bold)
                        .offset(y: -30)
                        .offset(x: 50)
                    Text("@JimmyLiang")
                        .foregroundColor(.survaidBlue)
                        .offset(y: 0)
                        .offset(x: 50)
                    Text("★★★★✩ (31)")
                        .foregroundColor(.survaidBlue)
                        .offset(y: 30)
                        .offset(x: 54)
                }
                ZStack {
                    Rectangle().fill(Color.survaidBlue).frame(height: 140)
                    VStack{
                        TabView(selection: $index) {
                            ForEach((0..<4), id: \.self) { index in
                                CardView()
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    }
                    .frame(height: 140)
                }
                ZStack {
                    Rectangle().fill(Color.black).frame(height: 320)
                    VStack {
                        Button(action: {
                        }) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .renderingMode(.original)
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 10)
                                
                                Spacer()
                                
                                Text("About Jimmy")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(width: 340, height: 60)
                            .background(Color.survaidBlue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        Button(action: {
                        }) {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .renderingMode(.original)
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 10)
                                
                                Spacer()
                                
                                Text("Wallet")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(width: 340, height: 60)
                            .background(Color.survaidBlue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        Button(action: {
                        }) {
                            HStack {
                                Image(systemName: "doc.fill")
                                    .renderingMode(.original)
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 10)
                                
                                Spacer()
                                
                                Text("Completed Surveys")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(width: 340, height: 60)
                            .background(Color.survaidBlue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        Button(action: {
                        }) {
                            HStack {
                                Image(systemName: "person.text.rectangle.fill")
                                    .renderingMode(.original)
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 10)
                                
                                Spacer()
                                
                                Text("Reviews")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(width: 340, height: 60)
                            .background(Color.survaidBlue)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                    }
                }
            }
        }.background(Color.black)
    }
}

#Preview {
    ProfileView()
}
