import SwiftUI

struct ModalView: View {
    
    @ObservedObject var argument = Argument()
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
                    TextField("Argument", value: $argument.value, formatter: formatter).keyboardType(.decimalPad)
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
        }
    }
}
