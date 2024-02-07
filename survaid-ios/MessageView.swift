import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isSentByUser: Bool
    let timestamp: Date
}

struct MessageView: View {
    @State private var newMessageText: String = ""
    @State private var messages: [Message] = [
        Message(content: "Hello!", isSentByUser: true, timestamp: Date()),
        Message(content: "Hi there!", isSentByUser: false, timestamp: Date()),
        Message(content: "How are you?", isSentByUser: true, timestamp: Date()),
        Message(content: "I'm good, thanks!", isSentByUser: false, timestamp: Date())
    ]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "message.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                Text("Alex Gallion")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
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
        
        messages.append(Message(content: newMessageText,
                                isSentByUser: true,
                                timestamp: Date()))
        newMessageText = ""
    }
}

struct MessageBubble: View {
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
    static let timeStampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}

#Preview {
    MessageView()
}
