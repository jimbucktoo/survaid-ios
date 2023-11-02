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
            LazyVStack {
                ForEach(1...100, id: \.self) { row in
                    HStack {
                        Image(systemName: "doc").foregroundColor(.black)
                        Text("\(row): Survey").onAppear{
                            print("\(row) Survey")
                        }
                    }
                }.padding(30)
            }
        }
    }
}

#Preview {
    SurveysView()
}
