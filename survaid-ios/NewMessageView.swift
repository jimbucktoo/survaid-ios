import SwiftUI

struct NewMessage: Identifiable {
    let id = UUID()
    let content: String
    let isSentByUser: Bool
    let timestamp: Date
}

struct NewMessageView: View {
    @State private var newMessageText: String = ""
    @State private var recipient: String = ""
    @State private var messages: [NewMessage] = []
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "message.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                Text("New Message")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            HStack {
                Text("To:")
                    .foregroundColor(.blue)
                TextField("", text: $recipient)
                    .textFieldStyle(.plain)
                    .background(Color.black)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        MessageBubble(content: message.content,
                                      isSentByUser: message.isSentByUser,
                                      timestamp: message.timestamp)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            
            HStack {
                TextField("Message", text: $newMessageText)
                    .textFieldStyle(.roundedBorder)
                    .background(Color.red)
                
                Button(action: sendMessage) {
                    Text("Send")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.bottom, 20)
            .padding(.leading, 20)
            .padding(.trailing, 20)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    func sendMessage() {
        guard !newMessageText.isEmpty else { return }
        
        messages.append(NewMessage(content: newMessageText,
                                   isSentByUser: true,
                                   timestamp: Date()))
        newMessageText = ""
    }
}

struct NewMessageBubble: View {
    let content: String
    let isSentByUser: Bool
    let timestamp: Date
    
    var body: some View {
        HStack {
            if isSentByUser {
                Spacer()
            }
            VStack(alignment: isSentByUser ? .trailing : .leading) {
                Text(content)
                    .padding(10)
                    .background(isSentByUser ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(5)
                
                Text("\(timestamp, formatter: DateFormatter.timeStampFormatter)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
            }
            .padding(.horizontal, 8)
            if !isSentByUser {
                Spacer()
            }
        }
    }
}

extension DateFormatter {
    static let newTimeStampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView()
    }
}
