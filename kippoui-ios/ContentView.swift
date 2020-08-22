import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var myLocation = MyLocation()
    
    var body: some View {
        VStack {            
            MapView(location: CLLocationCoordinate2DMake(myLocation.latitude, myLocation.longitude)).edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
