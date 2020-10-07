import SwiftUI
import UIKit

struct UserView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserEntity.timestamp, ascending: true)],
        animation: .default
    ) var users: FetchedResults<UserEntity>
    
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var isUserPresenting: Bool
    @State var isUserCreationPresenting = false
    @State var name = ""
    @State var birthdayDate = Date()
    var from: Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.date(from: "1868-01-01")!
    }
    let dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(users, id: \.self) { user in
                        Text("\(user.name ?? "名無し") - \(user.birthdayString ?? "")")
                    }.onDelete { indices in
                        self.users.delete(at: indices, from: self.viewContext)
                    }
                }
            }
            .navigationTitle("ユーザー情報")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isUserCreationPresenting.toggle()
                }) {
                    Text("追加")
                }
                .sheet(isPresented: $isUserCreationPresenting, onDismiss: {
                
                }) {
                    UserCreationView(isUserCreationPresenting: $isUserCreationPresenting)
                }
            )
        }
    }
}
