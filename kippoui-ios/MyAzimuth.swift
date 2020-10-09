import SwiftUI
import MapKit

class MyAzimuth: ObservableObject {
    @Published var mapView = MKMapView(frame: .zero)
    @Published var myPin = MyPin(title: "", coordinate: CLLocationCoordinate2DMake(35.681236, 139.767125))
    @Published var center = CLLocationCoordinate2D() //CLLocationCoordinate2DMake(35.681236, 139.767125)
    
    @Published var coordinates: [[CLLocationCoordinate2D]] = []
    
    @Published var searchedPlaces:[SearchedPlace] = []
    @Published var destination: [CLLocationCoordinate2D] = []
    @Published var destinationPin: [MKPointAnnotation] = []
}
