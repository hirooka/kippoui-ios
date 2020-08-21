import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        VStack {
            MapView(location: CLLocationCoordinate2DMake(35.681236, 139.767125))
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
