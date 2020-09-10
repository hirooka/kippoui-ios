import SwiftUI
import MapKit

class MyAzimuth: ObservableObject {
    @Published var mapView = MKMapView(frame: .zero)
    @Published var myPin = MyPin(title: "You", coordinate: CLLocationCoordinate2DMake(35.681236, 139.767125))
    @Published var previousMyPin = MyPin(title: "You", coordinate: CLLocationCoordinate2DMake(35.681236, 139.767125))
    @Published var center = CLLocationCoordinate2D() //CLLocationCoordinate2DMake(35.681236, 139.767125)
    @Published var coordinates0: [CLLocationCoordinate2D] = []
    @Published var coordinates1: [CLLocationCoordinate2D] = []
    @Published var coordinates2: [CLLocationCoordinate2D] = []
    @Published var coordinates3: [CLLocationCoordinate2D] = []
    @Published var coordinates4: [CLLocationCoordinate2D] = []
    @Published var coordinates5: [CLLocationCoordinate2D] = []
    @Published var coordinates6: [CLLocationCoordinate2D] = []
    @Published var coordinates7: [CLLocationCoordinate2D] = []
}
