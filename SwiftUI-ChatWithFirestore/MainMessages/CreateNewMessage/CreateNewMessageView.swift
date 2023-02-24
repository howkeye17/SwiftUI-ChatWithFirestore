//

import SwiftUI
import SDWebImageSwiftUI

struct CreateNewMessageView: View {

    let didSelectNewUser: (ChatUser) -> Void

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = CreateNewMessageViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                Text(viewModel.errorMessage)

                ForEach(viewModel.users) { user in
                    Button {
                        dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack {
                            WebImage(url: URL(string: user.imageProfileURL))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(
                                        Color(.label),
                                        lineWidth: 2
                                    )
                                )

                            Text(user.email)
                                .foregroundColor(Color(.label))
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Message")
            .toolbar {
                ToolbarItemGroup(
                    placement: .navigationBarLeading
                ) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }

                }
            }
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageView(didSelectNewUser: {_ in })
    }
}
