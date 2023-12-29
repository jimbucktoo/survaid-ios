import SwiftUI

struct ReviewsView: View {
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "person.text.rectangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.survaidBlue)
                Text("Reviews")
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
    ReviewsView()
}
