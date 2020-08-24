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
            longitude: 139.767125
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    
    @State private var locations: [Location] = [
        Location(coordinate: .init(latitude: 35.681236, longitude: 139.767125))
    ]
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: locations
            ) { location in
                MapPin(coordinate: location.coordinate)
            }
            .edgesIgnoringSafeArea(.all)
//            .onTapGesture(count: 1, perform: {
//                withAnimation {
//                    region.center = CLLocationCoordinate2D(
//                        latitude: 35.6,
//                        longitude: 139.7
//                    )
//                }
//            })
            .highPriorityGesture(
                DragGesture().onEnded{ value in
                    
                }.onChanged(){value in
                    
                })
            .onLongPressGesture {
                withAnimation {
                    locations.append(Location(coordinate: .init(latitude: 25.0, longitude: 139.0)))
                    print("onLongPressGesture")
                }
            }
//            .gesture(
//                LongPressGesture().onEnded{ value in
//                    print("LongPressGesture().onEnded")
//                }.onChanged(){ value in
//                }
//            )
            .gesture(
                DragGesture(minimumDistance: 0).onEnded{ value in
                    print(value.startLocation)
                }.onChanged(){value in
                    print(value.startLocation)
                }
            )
            .gesture(
                TapGesture().onEnded{ value in
                    print("TapGesture().onEnded")
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
