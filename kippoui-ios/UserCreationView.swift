import SwiftUI

struct UserCreationView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @Binding var isUserCreationPresenting: Bool

    @State var name = ""
    @State var birthdayDate = Date()
//    var from: Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ja_JP")
//        //dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM(EEEEE)", options: 0, locale: Locale(identifier: "ja_JP"))
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return dateFormatter.date(from: "1868-01-01")!
//    }
    
    var f = Date()
    
    var body: some View {
        VStack {
            TextField("名前", text: $name, onCommit: {
                
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            DatePicker(
                selection: $birthdayDate,
                //in: from...Date(),
                displayedComponents: [.date],
                label: {Text("誕生日")}
            )
            .environment(\.locale, Locale(identifier: "ja_JP"))
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
