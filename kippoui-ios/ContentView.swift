import SwiftUI
import MapKit

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
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
    @State var center = CLLocationCoordinate2D()
    @State var locationManager = CLLocationManager()
    
    @State var isModalPresenting = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
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
                        coordinates7: $coordinates7,
                        center: $center,
                        locationManager: $locationManager
                    )
                    .edgesIgnoringSafeArea(.all)
                    Image(systemName: "octagon")
                        .resizable()
                        .frame(width: 32.0, height: 32.0, alignment: .center)
                        .foregroundColor(colorScheme == .dark ? Color(red: 255/255, green: 230/215, blue: 0/255) : .red)
                    Button(action: {
                        self.isModalPresenting.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .foregroundColor(.gray)
                    }
                    .sheet(isPresented: $isModalPresenting, onDismiss: {
                        
                    }) {
                        ModalView()
                    }
                    .offset(x: geometry.size.width / 2 - 16 - 8, y: geometry.size.height / 2 - 56)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
