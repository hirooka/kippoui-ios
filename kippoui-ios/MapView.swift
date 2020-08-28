import SwiftUI
import MapKit

final class CheckPoint: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

struct MapView: UIViewRepresentable {
    
    @Binding var count: Int
    @Binding var coordinate: CLLocationCoordinate2D
    @Binding var checkPoints: [CheckPoint]
    @Binding var previousCheckPoints: [CheckPoint]
    @Binding var coordinates0: [CLLocationCoordinate2D]
    @Binding var coordinates1: [CLLocationCoordinate2D]
    @Binding var coordinates2: [CLLocationCoordinate2D]
    @Binding var coordinates3: [CLLocationCoordinate2D]
    @Binding var coordinates4: [CLLocationCoordinate2D]
    @Binding var coordinates5: [CLLocationCoordinate2D]
    @Binding var coordinates6: [CLLocationCoordinate2D]
    @Binding var coordinates7: [CLLocationCoordinate2D]
    
    var mapView = MKMapView(frame: .zero)
    
    var locationManager = CLLocationManager()
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        setupManager()
        //let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //uiView.setCenter(coordinate, animated: true)
        uiView.removeAnnotations(previousCheckPoints)
        uiView.addAnnotations(checkPoints)
        
        if coordinates0.count > 1 && coordinates1.count > 1 {
            uiView.removeOverlays(mapView.overlays)
            //let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            let polyline0 = MKGeodesicPolyline(coordinates: coordinates0, count: coordinates0.count)
            let polyline1 = MKGeodesicPolyline(coordinates: coordinates1, count: coordinates1.count)
            let polyline2 = MKGeodesicPolyline(coordinates: coordinates2, count: coordinates2.count)
            let polyline3 = MKGeodesicPolyline(coordinates: coordinates3, count: coordinates3.count)
            let polyline4 = MKGeodesicPolyline(coordinates: coordinates4, count: coordinates4.count)
            let polyline5 = MKGeodesicPolyline(coordinates: coordinates5, count: coordinates5.count)
            let polyline6 = MKGeodesicPolyline(coordinates: coordinates6, count: coordinates6.count)
            let polyline7 = MKGeodesicPolyline(coordinates: coordinates7, count: coordinates7.count)
            uiView.addOverlay(polyline0)
            uiView.addOverlay(polyline1)
            uiView.addOverlay(polyline2)
            uiView.addOverlay(polyline3)
            uiView.addOverlay(polyline4)
            uiView.addOverlay(polyline5)
            uiView.addOverlay(polyline6)
            uiView.addOverlay(polyline7)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView
        var tapGestureRecognizer = UITapGestureRecognizer()
        var longPressGestureRecognizer = UILongPressGestureRecognizer()
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            self.tapGestureRecognizer.delegate = self
            self.parent.mapView.addGestureRecognizer(tapGestureRecognizer)
            self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
            self.longPressGestureRecognizer.delegate = self
            self.longPressGestureRecognizer.minimumPressDuration = 0.3
            self.parent.mapView.addGestureRecognizer(longPressGestureRecognizer)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let polylineRenderer = MKPolylineRenderer(polyline: polyline)
                polylineRenderer.strokeColor = .red
                polylineRenderer.lineWidth = 3.0
                return polylineRenderer
            }
            return MKOverlayRenderer()
        }
        
        @objc func longPressHandler(_ gesture: UILongPressGestureRecognizer) {
            let location = longPressGestureRecognizer.location(in: self.parent.mapView)
            let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)
            self.parent.coordinate = coordinate
            
            if gesture.state == UILongPressGestureRecognizer.State.ended {

            } else if gesture.state == UILongPressGestureRecognizer.State.began {
                print("\(coordinate.latitude), \(coordinate.longitude)")
                self.parent.previousCheckPoints = self.parent.checkPoints
                let checkPoint = CheckPoint(
                    title: "Hi",
                    coordinate: .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                )
                self.parent.checkPoints = [checkPoint]
                
                let distance = 100000000.0
                
                self.parent.coordinates0 = []
                self.parent.coordinates0.append(coordinate)
                let l0 = self.parent.getLocation(origin: coordinate, angle: 15.0, distance: distance)
                print("0: \(l0.latitude), \(l0.longitude)")
                self.parent.coordinates0.append(l0)
                
                self.parent.coordinates1 = []
                self.parent.coordinates1.append(coordinate)
                let l1 = self.parent.getLocation(origin: coordinate, angle: 75.0, distance: distance)
                print("1: \(l1.latitude), \(l1.longitude)")
                self.parent.coordinates1.append(l1)
                
                self.parent.coordinates2 = []
                self.parent.coordinates2.append(coordinate)
                let l2 = self.parent.getLocation(origin: coordinate, angle: 105.0, distance: distance)
                print("2: \(l2.latitude), \(l2.longitude)")
                self.parent.coordinates2.append(l2)
                
                self.parent.coordinates3 = []
                self.parent.coordinates3.append(coordinate)
                let l3 = self.parent.getLocation(origin: coordinate, angle: 165.0, distance: distance)
                print("3: \(l3.latitude), \(l3.longitude)")
                self.parent.coordinates3.append(l3)
                
                self.parent.coordinates4 = []
                self.parent.coordinates4.append(coordinate)
                let l4 = self.parent.getLocation(origin: coordinate, angle: 195.0, distance: distance)
                print("4: \(l4.latitude), \(l4.longitude)")
                self.parent.coordinates4.append(l4)
                
                self.parent.coordinates5 = []
                self.parent.coordinates5.append(coordinate)
                let l5 = self.parent.getLocation(origin: coordinate, angle: 255.0, distance: distance)
                print("5: \(l5.latitude), \(l5.longitude)")
                self.parent.coordinates5.append(l5)
                
                self.parent.coordinates6 = []
                self.parent.coordinates6.append(coordinate)
                let l6 = self.parent.getLocation(origin: coordinate, angle: 285.0, distance: distance)
                print("6: \(l6.latitude), \(l6.longitude)")
                self.parent.coordinates6.append(l6)
                
                self.parent.coordinates7 = []
                self.parent.coordinates7.append(coordinate)
                let l7 = self.parent.getLocation(origin: coordinate, angle: 345.0, distance: distance)
                print("7: \(l7.latitude), \(l7.longitude)")
                self.parent.coordinates7.append(l7)
            }
        }
        
        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
        }
    }
    
    func getLocation(origin: CLLocationCoordinate2D, angle: Double, distance: Double) -> CLLocationCoordinate2D {
        let distanceFraction = distance / 6371000.0
        let angleRadian = angle * Double.pi / 180.0
        
        print("input: \(origin.latitude), \(origin.longitude)")

        let latitudeSourceRadian = origin.latitude * Double.pi / 180.0
        let longitudeSourceRadian = origin.longitude * Double.pi / 180.0

        let latitudeDestinationRadian = asin(sin(latitudeSourceRadian) * cos(distanceFraction) + cos(latitudeSourceRadian) * sin(distanceFraction) * cos(angleRadian))
        let longitudeDestinationRadianTemp =  atan2(sin(angleRadian) * sin(distanceFraction) * cos(latitudeSourceRadian), cos(distanceFraction) - sin(latitudeSourceRadian) * sin(latitudeDestinationRadian))
        let longitudeDestinationRadianTemp2 = (longitudeSourceRadian + longitudeDestinationRadianTemp + 3 * Double.pi)
        let longitudeDestinationRadianTemp3 = longitudeDestinationRadianTemp2.truncatingRemainder(dividingBy: (2 * Double.pi))
        let longitudeDestinationRadian = longitudeDestinationRadianTemp3 - Double.pi
        
        let latitudeDestinationDegree = latitudeDestinationRadian * 180.0 / Double.pi
        let longitudeDestinationDegree = longitudeDestinationRadian * 180.0 / Double.pi
        
        print("output: \(latitudeDestinationDegree), \(longitudeDestinationDegree)")
        return CLLocationCoordinate2DMake(latitudeDestinationDegree, longitudeDestinationDegree)
    }

}


