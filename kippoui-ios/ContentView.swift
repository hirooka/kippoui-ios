import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 35.681236,
            longitude: 139.767125),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    
    @State private var locations: [Location] = [
        Location(coordinate: .init(latitude: 35.0, longitude: 139.0)),
        Location(coordinate: .init(latitude: 36.0, longitude: 140.0)),
        Location(coordinate: .init(latitude: 37.0, longitude: 141.0))
    ]
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode
            )
            .edgesIgnoringSafeArea(.all)
            .onTapGesture(count: 1, perform: {
                withAnimation {
                    region.center = CLLocationCoordinate2D(
                        latitude: 35.6,
                        longitude: 139.7
                    )
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
