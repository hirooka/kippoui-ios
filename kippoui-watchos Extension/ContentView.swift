import SwiftUI

struct ContentView: View {
    
    @ObservedObject var con = DeviceConnector()
    
    var body: some View {
        Text("\(con.distance)").padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
