import SwiftUI

struct ModalView: View {
    
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var myAzimuth: MyAzimuth
    
    @State var updatedArgument = ""
    var angle = ["30", "45"]
    
    let formatter: NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        return numFormatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("")) {
                    TextField("Argument", text: $preferences.argument, onEditingChanged: { (editingChanged) in
                        if editingChanged {
                            
                        } else {

                        }
                    }).onChange(of: preferences.argument) {text in
                        updatedArgument = text
                    }
                    .keyboardType(.decimalPad)
//                    TextField("Argument", value: $argumentValue, formatter: formatter)
//                        .keyboardType(.decimalPad)
                    .onAppear(perform: {
                        
                    })
                    .onDisappear(perform: {
                        
                    })
                    
                    Picker(selection: $preferences.selected, label: Text("Angle Type")) {
                        ForEach(0..<angle.count) {
                            Text(self.angle[$0])
                        }
                    }
                    .onAppear(perform: {
                    })
                    .onDisappear(perform: {
                    })
                    .onTapGesture {
                        //UIApplication.shared.endEditing()
                    }
                }
            }
            .navigationTitle("Preferences")
        }.onAppear(perform: {
            //print("\(#file) - \(#function)")
        })
        .onDisappear(perform: {
            if updatedArgument != "" {
                self.preferences.argument = updatedArgument
            }
            //print("selected = \(preferences.selected)")
            switch preferences.selected {
            case 0:
                self.preferences.angle = "0"
            case 1:
                self.preferences.angle = "1"
            default:
                self.preferences.angle = "0"
            }
        })
//        .onTapGesture {
//            UIApplication.shared.endEditing()
//        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
