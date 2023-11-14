//
//  SurveysView.swift
//  survaid-ios
//
//  Created by James Liang on 10/16/23.
//

import SwiftUI

struct SurveysView: View {
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "doc.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.survaidBlue)
                Text("Surveys")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.survaidBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            LazyVStack {
                ForEach(1...10, id: \.self) { row in
                    HStack {
                        VStack {
                            HStack {
                                Image(systemName: "doc.fill").foregroundColor(.survaidBlue).padding(.leading, 10).padding(.bottom, 10)
                                Text("Sleep Apnea Survey").foregroundColor(.survaidBlue).fontWeight(.bold).onAppear{
                                    print("Survey No. \(row)")
                                }.padding(.bottom, 10)
                                Spacer()
                                Text("\(row) min").foregroundColor(.survaidOrange).fontWeight(.bold).padding(.trailing, 10).padding(.bottom, 10)
                            }
                            HStack {
                                Image(systemName: "person.fill").foregroundColor(.black).padding(.leading, 10).padding(.bottom, 10)
                                Text("jimbucktoo").onAppear{
                                    print("Survey No. \(row)")
                                }.padding(.bottom, 10)
                                Spacer()
                                Text("Price: $\(row).99").padding(.trailing, 10).padding(.bottom, 10)
                            }
                            Image("Sleep").resizable().aspectRatio(contentMode: .fit)
                            HStack {
                                Image(systemName: "person.2.fill").foregroundColor(.black).padding(.leading, 10).padding(.top, 10)
                                Text("\(row) Comments").padding(.top, 10)
                                Spacer()
                                Text("\(row) Participants").padding(.trailing, 10).padding(.top, 10)
                            }
                        }
                        .frame(height: 300).overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)).background(Color.white)
                    }.background(Color.black).cornerRadius(10)
                }.padding(10)
            }.background(Color.black)
        }.background(Color.black)
    }
}

#Preview {
    SurveysView()
}
