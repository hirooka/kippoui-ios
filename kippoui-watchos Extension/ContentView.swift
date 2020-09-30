import SwiftUI

struct ContentView: View {
    
    @ObservedObject var con = DeviceConnector()
    
    var body: some View {
        VStack {
            Text("方位: \(con.azimuth)[度]")
            Text("距離: \(con.distance)[km]")
            Text("緯度: \(con.latitude)[度]")
            Text("経度: \(con.longitude)[度]")
            Text("最終更新日時:")
            Text("\(con.now)")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
