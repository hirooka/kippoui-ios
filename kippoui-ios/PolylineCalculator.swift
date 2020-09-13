import MapKit

class PolylineCalculator: NSObject {
        
    private var preferences: Preferences
    private var myAzimuth: MyAzimuth
    
    init(preferences: Preferences, myAzimuth: MyAzimuth) {
        self.preferences = preferences
        self.myAzimuth = myAzimuth
    }
    
    func serach(name: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name, completionHandler: {(places, error) in
            if error == nil {
                if places?.count == 0 {
                    print("no place")
                    return
                }
                for place in places! {
                    let location = place.location
                    let lat: CLLocationDegrees = (location?.coordinate.latitude)!
                    let lon: CLLocationDegrees = (location?.coordinate.longitude)!
                    let coordinate = CLLocationCoordinate2DMake(lat, lon)
                    self.myAzimuth.mapView.setCenter(coordinate, animated: false)
                    break
                }
            } else {
                print("serach error")
            }
        })
    }
    
    func hello() {
        //print("\(#file) - \(#function)")
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
    
    func getAngle(index: Int, argument: Double, angle: String) -> Double {
        
        if angle == "0" {
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
        }else if angle == "1" {
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
        
        let argument = Double(preferences.argument)!
        let angle = preferences.angle
        //print("angle = \(angle)")
        
        let antipodes = getAntipodes(origin: coordinate)
        
        myAzimuth.coordinates0 = []
        myAzimuth.coordinates0.append(coordinate)
        let l0 = getLocation(origin: coordinate, angle: getAngle(index: 0, argument: argument, angle: angle), distance: distance)
        //print("0: \(l0.latitude), \(l0.longitude)")
        myAzimuth.coordinates0.append(l0)
        myAzimuth.coordinates0.append(antipodes)
        
        myAzimuth.coordinates1 = []
        myAzimuth.coordinates1.append(coordinate)
        let l1 = getLocation(origin: coordinate, angle: getAngle(index: 1, argument: argument, angle: angle), distance: distance)
        //print("1: \(l1.latitude), \(l1.longitude)")
        myAzimuth.coordinates1.append(l1)
        myAzimuth.coordinates1.append(antipodes)
        
        myAzimuth.coordinates2 = []
        myAzimuth.coordinates2.append(coordinate)
        let l2 = getLocation(origin: coordinate, angle: getAngle(index: 2, argument: argument, angle: angle), distance: distance)
        //print("2: \(l2.latitude), \(l2.longitude)")
        myAzimuth.coordinates2.append(l2)
        myAzimuth.coordinates2.append(antipodes)
        
        myAzimuth.coordinates3 = []
        myAzimuth.coordinates3.append(coordinate)
        let l3 = getLocation(origin: coordinate, angle: getAngle(index: 3, argument: argument, angle: angle), distance: distance)
        //print("3: \(l3.latitude), \(l3.longitude)")
        myAzimuth.coordinates3.append(l3)
        myAzimuth.coordinates3.append(antipodes)
        
        myAzimuth.coordinates4 = []
        myAzimuth.coordinates4.append(coordinate)
        let l4 = getLocation(origin: coordinate, angle: getAngle(index: 4, argument: argument, angle: angle), distance: distance)
        //print("4: \(l4.latitude), \(l4.longitude)")
        myAzimuth.coordinates4.append(l4)
        myAzimuth.coordinates4.append(antipodes)
        
        myAzimuth.coordinates5 = []
        myAzimuth.coordinates5.append(coordinate)
        let l5 = getLocation(origin: coordinate, angle: getAngle(index: 5, argument: argument, angle: angle), distance: distance)
        //print("5: \(l5.latitude), \(l5.longitude)")
        myAzimuth.coordinates5.append(l5)
        myAzimuth.coordinates5.append(antipodes)
        
        myAzimuth.coordinates6 = []
        myAzimuth.coordinates6.append(coordinate)
        let l6 = getLocation(origin: coordinate, angle: getAngle(index: 6, argument: argument, angle: angle), distance: distance)
        //print("6: \(l6.latitude), \(l6.longitude)")
        myAzimuth.coordinates6.append(l6)
        myAzimuth.coordinates6.append(antipodes)
        
        myAzimuth.coordinates7 = []
        myAzimuth.coordinates7.append(coordinate)
        let l7 = getLocation(origin: coordinate, angle: getAngle(index: 7, argument: argument, angle: angle), distance: distance)
        //print("7: \(l7.latitude), \(l7.longitude)")
        myAzimuth.coordinates7.append(l7)
        myAzimuth.coordinates7.append(antipodes)
    }
}
