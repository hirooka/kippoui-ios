import SwiftUI
import MapKit

struct ContentView: View {
    
    @State var count =  0
    @State var coordinate = CLLocationCoordinate2D()
    @State var checkPoints: [CheckPoint] = []
    @State var previousCheckPoints: [CheckPoint] = []
    @State var coordinates0: [CLLocationCoordinate2D] = []
    @State var coordinates1: [CLLocationCoordinate2D] = []
    @State var coordinates2: [CLLocationCoordinate2D] = []
    @State var coordinates3: [CLLocationCoordinate2D] = []
    @State var coordinates4: [CLLocationCoordinate2D] = []
    @State var coordinates5: [CLLocationCoordinate2D] = []
    @State var coordinates6: [CLLocationCoordinate2D] = []
    @State var coordinates7: [CLLocationCoordinate2D] = []
    @Stete var zoom = 0.01
    
    var body: some View {
        VStack {
            MapView(
                count: $count,
                coordinate: $coordinate,
                checkPoints: $checkPoints,
                previousCheckPoints: $previousCheckPoints,
                coordinates0: $coordinates0,
                coordinates1: $coordinates1,
                coordinates2: $coordinates2,
                coordinates3: $coordinates3,
                coordinates4: $coordinates4,
                coordinates5: $coordinates5,
                coordinates6: $coordinates6,
                coordinates7: $coordinates7
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
