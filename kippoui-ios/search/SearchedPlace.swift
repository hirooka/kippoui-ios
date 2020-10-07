import SwiftUI
import MapKit

struct SearchedPlace: Identifiable {
    var id = UUID()
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
}
