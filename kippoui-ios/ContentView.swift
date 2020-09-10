import SwiftUI
import MapKit

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var myAzimuth: MyAzimuth
    
    @State var distance = "-"
    @State var drawing = false
    
    @State var isModalPresenting = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    MapView(
                        distance: $distance,
                        drawing: $drawing
                    )
                    .edgesIgnoringSafeArea(.all)
                    Image(systemName: "octagon")
                        .resizable()
                        .frame(width: 32.0, height: 32.0, alignment: .center)
                        .foregroundColor(/*colorScheme == .dark ? Color(red: 255/255, green: 230/215, blue: 0/255) :*/ .red)
                    Button(action: {
                        print("drawPolyline")
                        self.drawing.toggle()
                        let polylineCalculator = PolylineCalculator(preferences: preferences, myAzimuth: myAzimuth)
                        polylineCalculator.calc()
                    }) {
                        Image(systemName: "dot.circle.and.cursorarrow")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                            .foregroundColor(.gray)
                    }
                    .offset(x: geometry.size.width / 2 - 16 - 8, y: geometry.size.height / 2 - 56 - 56)
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
                    Text("\(distance)km")
                        .offset(x: 0, y: 28)
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
