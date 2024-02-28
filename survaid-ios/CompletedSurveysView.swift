import SwiftUI

struct CompletedSurveysView: View {
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "doc.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.survaidBlue)
                Text("Completed Surveys")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.survaidBlue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }.background(Color.black)
    }
}

#Preview {
    CompletedSurveysView()
}
