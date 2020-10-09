import MapKit

class PolylineCalculator: NSObject {
        
    private var preferences: Preferences
    private var myAzimuth: MyAzimuth
    
    init(preferences: Preferences, myAzimuth: MyAzimuth) {
        self.preferences = preferences
        self.myAzimuth = myAzimuth
    }
    
    func serach(name: String) {
        
//        let coordinate = CLLocationCoordinate2DMake(myAzimuth.mapView.region.center.latitude, myAzimuth.mapView.region.center.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name
        searchRequest.region = myAzimuth.mapView.region
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            
            self.myAzimuth.searchedPlaces = []
            for item in response.mapItems {
                if let name = item.name,
                    let location = item.placemark.location,
                    let administrativeArea = item.placemark.administrativeArea {
                    //print("\(name): \(administrativeArea) \(location.coordinate.latitude),\(location.coordinate.longitude)")
                    let searchedPlace = SearchedPlace(name: name, address: administrativeArea, coordinate: location.coordinate)
                    self.myAzimuth.searchedPlaces.append(searchedPlace)
                }
            }
            //print("hit places: \(self.myAzimuth.searchedPlaces.count)")
        }
        
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(name, completionHandler: {(places, error) in
//            if error == nil {
//                if places?.count == 0 {
//                    print("no place")
//                    return
//                }
//                for place in places! {
//                    let location = place.location
//                    let lat: CLLocationDegrees = (location?.coordinate.latitude)!
//                    let lon: CLLocationDegrees = (location?.coordinate.longitude)!
//                    let coordinate = CLLocationCoordinate2DMake(lat, lon)
//                    self.myAzimuth.mapView.setCenter(coordinate, animated: false)
//                    break
//                }
//            } else {
//                print("serach error = \(error?.localizedDescription)")
//            }
//        })
    }
    
    func goto() {
        myAzimuth.mapView.setCenter(myAzimuth.destination[0], animated: true)
        if myAzimuth.destinationPin.count > 1 {
            myAzimuth.mapView.removeAnnotation(myAzimuth.destinationPin[0])
            myAzimuth.mapView.addAnnotation(myAzimuth.destinationPin[1])
        } else {
            myAzimuth.mapView.addAnnotation(myAzimuth.destinationPin[0])
        }
        
    }
    
    func hello() {
        myAzimuth.mapView.setCenter(myAzimuth.center, animated: true)
    }
    
    func getAntipodes(origin: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(-1 * origin.latitude, origin.longitude - 180)
    }
    
    func getLocation(origin: CLLocationCoordinate2D, angle: Double, distance: Double) -> CLLocationCoordinate2D {
        let distanceFraction = distance / 6378136.6
        let angleRadian = angle * Double.pi / 180.0
        
        //print("input: \(origin.latitude), \(origin.longitude)")

        let latitudeSourceRadian = origin.latitude * Double.pi / 180.0
        let longitudeSourceRadian = origin.longitude * Double.pi / 180.0

        let latitudeDestinationRadian = asin(sin(latitudeSourceRadian) * cos(distanceFraction) + cos(latitudeSourceRadian) * sin(distanceFraction) * cos(angleRadian))
        let longitudeDestinationRadianTemp =  atan2(sin(angleRadian) * sin(distanceFraction) * cos(latitudeSourceRadian), cos(distanceFraction) - sin(latitudeSourceRadian) * sin(latitudeDestinationRadian))
        let longitudeDestinationRadianTemp2 = (longitudeSourceRadian + longitudeDestinationRadianTemp + 3 * Double.pi)
        let longitudeDestinationRadianTemp3 = longitudeDestinationRadianTemp2.truncatingRemainder(dividingBy: (2 * Double.pi))
        let longitudeDestinationRadian = longitudeDestinationRadianTemp3 - Double.pi
        
        let latitudeDestinationDegree = latitudeDestinationRadian * 180.0 / Double.pi
        let longitudeDestinationDegree = longitudeDestinationRadian * 180.0 / Double.pi
        
        //print("output: \(latitudeDestinationDegree), \(longitudeDestinationDegree)")
        return CLLocationCoordinate2DMake(latitudeDestinationDegree, longitudeDestinationDegree)
    }
    
    func getAngle(index: Int, argument: Double, angle: Int) -> Double {
        
        if angle == 0 { // 8-3060
            if index == 0 {
                return 15.0 + argument
            } else if index == 1 {
                return 75.0 + argument
            } else if index == 2 {
                return 105.0 + argument
            } else if index == 3 {
                return 165.0 + argument
            } else if index == 4 {
                return 195.0 + argument
            } else if index == 5 {
                return 255.0 + argument
            } else if index == 6 {
                return 285.0 + argument
            } else if index == 7 {
                return 345.0 + argument
            }
        } else if angle == 1 { // 8-45
            if index == 0 {
                return 22.5 + argument
            } else if index == 1 {
                return 67.5 + argument
            } else if index == 2 {
                return 112.5 + argument
            } else if index == 3 {
                return 157.5 + argument
            } else if index == 4 {
                return 202.5 + argument
            } else if index == 5 {
                return 247.5 + argument
            } else if index == 6 {
                return 292.5 + argument
            } else if index == 7 {
                return 337.5 + argument
            }
        } else if angle == 2 { // 12
            if index == 0 {
                return 15.0 + argument
            } else if index == 1 {
                return 45.0 + argument
            } else if index == 2 {
                return 75.0 + argument
            } else if index == 3 {
                return 105.0 + argument
            } else if index == 4 {
                return 135.0 + argument
            } else if index == 5 {
                return 165.0 + argument
            } else if index == 6 {
                return 195.0 + argument
            } else if index == 7 {
                return 225.0 + argument
            } else if index == 8 {
                return 255.0 + argument
            } else if index == 9 {
                return 285.0 + argument
            } else if index == 10 {
                return 315.0 + argument
            } else if index == 11 {
                return 345.0 + argument
            }
        } else if angle == 3 { // 24
            if index == 0 {
                return 7.5 + argument
            } else if index == 1 {
                return 22.5 + argument
            } else if index == 2 {
                return 37.5 + argument
            } else if index == 3 {
                return 52.5 + argument
            } else if index == 4 {
                return 67.5 + argument
            } else if index == 5 {
                return 82.5 + argument
            } else if index == 6 {
                return 97.5 + argument
            } else if index == 7 {
                return 112.5 + argument
            } else if index == 8 {
                return 127.5 + argument
            } else if index == 9 {
                return 142.5 + argument
            } else if index == 10 {
                return 157.5 + argument
            } else if index == 11 {
                return 172.5 + argument
            } else if index == 12 {
                return 187.5 + argument
            } else if index == 13 {
                return 202.5 + argument
            } else if index == 14 {
                return 217.5 + argument
            } else if index == 15 {
                return 232.5 + argument
            } else if index == 16 {
                return 247.5 + argument
            } else if index == 17 {
                return 262.5 + argument
            } else if index == 18 {
                return 277.5 + argument
            } else if index == 19 {
                return 292.5 + argument
            } else if index == 20 {
                return 307.5 + argument
            } else if index == 21 {
                return 322.5 + argument
            } else if index == 22 {
                return 337.5 + argument
            } else if index == 23 {
                return 352.5 + argument
            }
        }
        return 0.0
    }
    
    func calc() {
        //print("\(#file) - \(#function)")
        
        myAzimuth.center = CLLocationCoordinate2DMake(myAzimuth.mapView.region.center.latitude, myAzimuth.mapView.region.center.longitude)
        let coordinate = myAzimuth.center
        //print("center = \(coordinate.latitude), \(coordinate.longitude)")
        
        myAzimuth.myPin = MyPin(title: "", coordinate: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
        
        let distance = 6378136.6
        
        let argument = Double(preferences.argument)! * -1
        let angle = preferences.selected//preferences.angle
        //print("angle = \(angle)")
        
        let antipodes = getAntipodes(origin: coordinate)
        
        myAzimuth.coordinates = []
        //vat tempc: [[CLLocationCoordinate2D]] = [[]]
        if angle == 0 || angle == 1 { // 8
            for i in 0..<8 {
                var c: [CLLocationCoordinate2D] = []
                c.append(coordinate)
                let c1 = getLocation(origin: coordinate, angle: getAngle(index: i, argument: argument, angle: angle), distance: distance)
                c.append(c1)
                c.append(antipodes)
                myAzimuth.coordinates.append(c)
                print("\(myAzimuth.coordinates.count)")
            }
        } else if angle == 2 { // 12
            for i in 0..<12 {
                var c: [CLLocationCoordinate2D] = []
                c.append(coordinate)
                let c1 = getLocation(origin: coordinate, angle: getAngle(index: i, argument: argument, angle: angle), distance: distance)
                c.append(c1)
                c.append(antipodes)
                myAzimuth.coordinates.append(c)
            }
        } else if angle == 3 { // 24
            for i in 0..<24 {
                var c: [CLLocationCoordinate2D] = []
                c.append(coordinate)
                let c1 = getLocation(origin: coordinate, angle: getAngle(index: i, argument: argument, angle: angle), distance: distance)
                c.append(c1)
                c.append(antipodes)
                myAzimuth.coordinates.append(c)
            }
        }
        print("myAzimuth.coordinates.count = \(myAzimuth.coordinates.count), myAzimuth.coordinates[0].count = \(myAzimuth.coordinates[0].count)")
    }
    
    func updatePreferences() {
        //print("\(#file) - \(#function)")
        
        let coordinate = myAzimuth.center
        
        let distance = 6378136.6
        
        let argument = Double(preferences.argument)! * -1
        let angle = preferences.selected//preferences.angle
        //print("angle = \(angle)")
        
        let antipodes = getAntipodes(origin: coordinate)
        
        myAzimuth.coordinates = []
        if angle == 0 || angle == 1 { // 8
            for i in 0..<8 {
                var c: [CLLocationCoordinate2D] = []
                c.append(coordinate)
                let c1 = getLocation(origin: coordinate, angle: getAngle(index: i, argument: argument, angle: angle), distance: distance)
                c.append(c1)
                c.append(antipodes)
                myAzimuth.coordinates.append(c)
                print("\(myAzimuth.coordinates.count)")
            }
        } else if angle == 2 { // 12
            for i in 0..<12 {
                var c: [CLLocationCoordinate2D] = []
                c.append(coordinate)
                let c1 = getLocation(origin: coordinate, angle: getAngle(index: i, argument: argument, angle: angle), distance: distance)
                c.append(c1)
                c.append(antipodes)
                myAzimuth.coordinates.append(c)
            }
        } else if angle == 3 { // 24
            for i in 0..<24 {
                var c: [CLLocationCoordinate2D] = []
                c.append(coordinate)
                let c1 = getLocation(origin: coordinate, angle: getAngle(index: i, argument: argument, angle: angle), distance: distance)
                c.append(c1)
                c.append(antipodes)
                myAzimuth.coordinates.append(c)
            }
        }
    }
}
