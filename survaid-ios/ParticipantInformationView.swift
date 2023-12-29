import SwiftUI

struct ParticipantInformationView: View {
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.survaidBlue)
                Text("Participant Information")
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
    ParticipantInformationView()
}
