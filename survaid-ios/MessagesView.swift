import SwiftUI

struct MessagesView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "message.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.survaidBlue)
                Text("Messages")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.survaidBlue)
                Spacer()
                NavigationLink(destination: NewMessageView()) {
                    Image(systemName: "square.and.pencil")
                        .font(.title)
                        .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            ScrollView {
                LazyVStack {
                    ForEach(1...1, id: \.self) { row in
                        Divider().background(Color.white)
                        NavigationLink(destination: MessageView()) {
                            HStack {
                                Image("Alex")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                VStack (alignment: .leading) {
                                    HStack {
                                        Text("Alex Gallion")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .padding(.top, 4)
                                            .padding(.leading, 4)
                                        Spacer()
                                        Text("13m")
                                            .foregroundColor(.white)
                                    }
                                    Text("I'm good, thanks!")
                                        .foregroundColor(.white)
                                        .padding(.top, 4)
                                        .padding(.leading, 4)
                                }
                                .padding(.bottom, 10)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                        }
                    }
                }.padding(.leading, 10)
            }.background(Color.black)
        }.background(Color.black)
    }
}

#Preview {
    MessagesView()
}
