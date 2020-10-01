import SwiftUI

struct ContentView: View {
    
    @ObservedObject var con = DeviceConnector()
    
    var body: some View {
        VStack {
            //Text("今、\(con.direction)にいます。")
            Text("\(con.direction)").font(.title)
            Text("にいます。")
            Text("方位角: \(con.azimuth)[度]")
            Text("距離: \(con.distance)[km]")
            Spacer()
            //Text("緯度: \(con.latitude)[度]")
            //Text("経度: \(con.longitude)[度]")
            Text("最終更新日時:").font(.footnote)
            Text("\(con.now)").font(.footnote)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
