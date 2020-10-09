import SwiftUI
import MapKit

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var myAzimuth: MyAzimuth
    
    @State var first = true
    @State var distance = "-"
    @State var drawing = false
    @State var circle = CLLocationCoordinate2D()
    @State var azimuth = 0.0
    
    @State var isPreferencesPresenting = false
    @State var search = ""
    @State var isSearchPresenting = false
    @State var searching = false
    @State var isUserPresenting = false
    
    @ObservedObject var con = WatchConnector()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    MapView(
                        first: $first,
                        distance: $distance,
                        drawing: $drawing,
                        circle: $circle,
                        azimuth: $azimuth,
                        searching: $searching
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                    Image(systemName: "octagon")
                        .resizable()
                        .frame(width: 32.0, height: 32.0, alignment: .center)
                        .foregroundColor(colorScheme == .dark ? Color(red: 255/255, green: 230/215, blue: 0/255) : .red)
                    
                    Button(action: {
                        self.isUserPresenting.toggle()
                    }) {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .foregroundColor(.gray)
                    }
                    .sheet(isPresented: $isUserPresenting, onDismiss: {
                        
                    }) {
                        UserView(isUserPresenting: $isUserPresenting)
                    }
                    .offset(x: geometry.size.width / 2 - 28, y: geometry.size.height / 2 - 281) // -16-12, -56-56-56-56-56
                    
                    Button(action: {
                        self.isSearchPresenting.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .foregroundColor(.gray)
                    }
                    .sheet(isPresented: $isSearchPresenting, onDismiss: {
                        
                    }) {
                        SearchView(isSearchPresenting: self.$isSearchPresenting, searching: self.$searching)
                    }
                    .offset(x: geometry.size.width / 2 - 28, y: geometry.size.height / 2 - 225) // -16-12, -56-56-56-56
                    
                    Button(action: {
                        let polylineCalculator = PolylineCalculator(preferences: preferences, myAzimuth: myAzimuth)
                        polylineCalculator.hello()
                    }) {
                        Image(systemName: "arrow.uturn.backward")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .foregroundColor(.gray)
                    }
                    .offset(x: geometry.size.width / 2 - 28, y: geometry.size.height / 2 - 168) // -16-12, -56-56-56
                    
                    Button(action: {
                        self.drawing.toggle()
                        self.first = false
                        self.distance = "0.0"
                        let polylineCalculator = PolylineCalculator(preferences: preferences, myAzimuth: myAzimuth)
                        polylineCalculator.calc()
                    }) {
                        Image(systemName: "dot.circle.and.cursorarrow")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .foregroundColor(.gray)
                    }
                    .offset(x: geometry.size.width / 2 - 28, y: geometry.size.height / 2 - 112) // -16-12, -56-56
                    
                    Button(action: {
                        self.isPreferencesPresenting.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .foregroundColor(.gray)
                    }
                    .sheet(isPresented: $isPreferencesPresenting, onDismiss: {
                        
                    }) {
                        PreferencesView(isPreferencesPresenting: $isPreferencesPresenting)
                    }
                    .offset(x: geometry.size.width / 2 - 28, y: geometry.size.height / 2 - 56) // -16-12, -16-40
                    
                    Text("\(distance)km")
                        .offset(x: 0, y: 28)
                    
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 64.0, height: 64.0, alignment: .center)
                        .foregroundColor(.white)
                        .offset(x: -1 * geometry.size.width / 2 + 44, y: -1 * geometry.size.height / 2 + 44) // +32+12, +32+12
                    
                    Path { path in
                        path.move(to: CGPoint(x: 44, y: 44))
                        let x = 44 + 32 * sin(azimuth)
                        let y = 44 - 32 * cos(azimuth)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    .stroke(style: .init(lineWidth: 1))
                    .fill(Color.red)
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
