import SwiftUI

struct ModalView: View {
    
    @EnvironmentObject var preferences: Preferences
    @State var updatedArgument = ""
    var angle = ["30", "45"]
    @State var selected = 0
    
    let formatter: NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        return numFormatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("section")) {
                    TextField("Argument", text: $preferences.argument).onChange(of: preferences.argument) {text in
                        print(text)
                        updatedArgument = text
                    }
                    .keyboardType(.decimalPad)
//                    TextField("Argument", value: $argumentValue, formatter: formatter)
//                        .keyboardType(.decimalPad)
                    .onAppear(perform: {
                        
                    })
                    .onDisappear(perform: {
                        
                    })
                    
                    Picker(selection: $selected, label: Text("Angle Type")) {
                        ForEach(0..<angle.count) {
                            Text(self.angle[$0])
                        }
                    }
                }
                Section(header: Text("section")) {
                    
                }
            }
            .navigationTitle("Preferences")
        }.onAppear(perform: {
            print("\(#file) - \(#function)")
        })
        .onDisappear(perform: {
            if updatedArgument != "" {
                self.preferences.argument = updatedArgument
            }
        })
    }
}