import SwiftUI

struct UserCreationView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var isUserCreationPresenting: Bool

    @State var name = ""
    @State var birthdayDate = Date()
    var from: Date {
        let  format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.date(from: "1868-01-01")!
    }
    
    var body: some View {
        VStack {
            TextField("名前", text: $name, onCommit: {
                
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            DatePicker(
                selection: $birthdayDate,
                in: from...Date(),
                displayedComponents: [.date],
                label: {Text("誕生日")}
            )
            //Text("\(birthdayDate)")
            Button(action: {
                UserEntity.create(name: name, birthday: birthdayDate, in: self.viewContext)
                self.isUserCreationPresenting.toggle()
            }) {
                Text("保存")
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
