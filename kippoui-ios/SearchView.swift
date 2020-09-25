import SwiftUI
import MapKit

struct SearchView: View {
    
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var myAzimuth: MyAzimuth
    
    @Binding var isSearchPresenting: Bool
    
    @State var search = ""
    @Binding var searching: Bool
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    TextField("検索したい地名", text: $search, onCommit: {
                        self.myAzimuth.destination = []
                        let polylineCalculator = PolylineCalculator(preferences: preferences, myAzimuth: myAzimuth)
                        polylineCalculator.serach(name: search)
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding([.top, .leading, .trailing])
            List {
                ForEach(self.myAzimuth.searchedPlaces) { searchedPlace in
                    Text(searchedPlace.name)
                        .onTapGesture {
                            
                            self.myAzimuth.destination = []
                            if myAzimuth.destinationPin.count > 1 {
                                myAzimuth.destinationPin.remove(at: 0)
                            }
                            
                            self.searching.toggle()
                            self.myAzimuth.destination.append(searchedPlace.coordinate)
                            self.isSearchPresenting.toggle()
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = searchedPlace.coordinate
                            annotation.title = searchedPlace.name
                            annotation.subtitle = "Your destination"
                            self.myAzimuth.destinationPin.append(annotation)
                            
                            let polylineCalculator = PolylineCalculator(preferences: preferences, myAzimuth: myAzimuth)
                            polylineCalculator.goto()
                        }
                }
            }
        }
    }
}
