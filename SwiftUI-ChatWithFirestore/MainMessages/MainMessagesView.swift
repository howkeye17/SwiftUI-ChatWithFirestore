//

import SwiftUI
import SDWebImageSwiftUI

struct MainMessagesView: View {

    @ObservedObject private var viewModel = MainMessagesViewModel()
    @State var shouldShowLogOutoptions = false
    @State var shouldShowNewMessageScreen = false
    @State var shouldNavigateToChatLogView = false
    @State var chatUser: ChatUser?

    var body: some View {
        NavigationView {
            VStack {
                customNavigationBar
                messagesView

                NavigationLink(
                    isActive: $shouldNavigateToChatLogView,
                    destination: {
                        ChatLogView(chatUser: self.chatUser)
                    }, label: {
                        Text("")
                    }
                )
            }
            .overlay (
                newMessageButton,
                alignment: .bottom
            )
            .toolbar(.hidden)
        }
    }

    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    NavigationLink {
                        Text("Destination")
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1))
                            VStack(alignment: .leading) {
                                Text("User name")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }
                            Spacer()
                            Text("22d")
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }

    private var customNavigationBar: some View {
        HStack(spacing: 16) {

            WebImage(
                url: URL(
                    string: viewModel.chatUser?.imageProfileURL ?? ""))
            .resizable()
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipped()
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color(.label), lineWidth: 1))
            .shadow(radius: 5)
            .padding(.leading)
            let userName = viewModel.chatUser?.email
                .replacingOccurrences(of: "@gmail.com", with: "") ?? ""
            VStack(alignment: .leading, spacing: 4) {
                Text(userName)
                    .font(.system(size: 24, weight: .bold))
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            Button {
                shouldShowLogOutoptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
            .padding()
            .actionSheet(isPresented: $shouldShowLogOutoptions) {
                .init(
                    title: Text("Settings"),
                    message: Text("What do you want to do?"),
                    buttons: [
                        .destructive(
                            Text("Log Out"),
                            action: {
                                viewModel.handleSignOut()
                            }),
                        .cancel()
                    ])
            }
            .fullScreenCover(
                isPresented:  $viewModel.isUserCurrentlyLoggedOut,
                content: {
                    LoginView(
                        didCompleteLoginProcess: {
                            self.viewModel.isUserCurrentlyLoggedOut = false
                            self.viewModel.handleSignIn()
                        }
                    )
                }
            )
        }
    }

    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
        }
        .fullScreenCover(
            isPresented: $shouldShowNewMessageScreen) {
                CreateNewMessageView(
                    didSelectNewUser: { chatUser in
                        self.shouldNavigateToChatLogView.toggle()
                        self.chatUser = chatUser
                    }
                )
            }
    }
}

struct ChatLogView: View {

    let chatUser: ChatUser?

    var body: some View {
        ScrollView {
            ForEach(0..<10) { num in
                Text("Fake Data")
            }
        }
        .navigationTitle(chatUser?.email ?? "")
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
