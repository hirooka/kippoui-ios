import SwiftUI
import UIKit

struct UserView: View {
    
    @Binding var isUserPresenting: Bool
    @State var isUserCreationPresenting = false
    @State var name = ""
    @State var birthdayDate = Date()
    var from: Date {
        let  format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.date(from: "1868-01-01")!
    }
    
    var body: some View {
        Button(action: {
            self.isUserCreationPresenting.toggle()
        }) {
            Text("追加")
        }
        .sheet(isPresented: $isUserCreationPresenting, onDismiss: {
            
        }) {
            UserCreationView(isUserCreationPresenting: $isUserCreationPresenting)
        }
    }
}
