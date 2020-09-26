import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var myAzimuth: MyAzimuth
    
    @Binding var first: Bool
    @Binding var distance: String
    @Binding var drawing: Bool
    @Binding var circle: CLLocationCoordinate2D
    @Binding var azimuth: Double
    @Binding var searching: Bool
    
    @State var locationManager = CLLocationManager()
    @State var measuring = false
    @State var isInit = false
    
    func makeUIView(context: Context) -> MKMapView {
        //print("\(#file) - \(#function)")
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = context.coordinator

        myAzimuth.mapView.delegate = context.coordinator
        myAzimuth.mapView.showsUserLocation = true
        myAzimuth.mapView.userTrackingMode = .follow
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: myAzimuth.center, span: span)
        myAzimuth.mapView.setRegion(region, animated: false)
        return myAzimuth.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //print("\(#file) - \(#function)")
        //uiView.setCenter(coordinate, animated: true)

        if myAzimuth.coordinates0.count > 1 && myAzimuth.coordinates1.count > 1 && (drawing || isInit) {
            //print("\(#file) - \(#function) : DRAWING POLYLINE!")
            
            context.coordinator.parent = self // CoordinatorでcolorSchemeの変更を反映させるために必要
            
            uiView.overlays.forEach({
                if $0 is MKPolyline {
                    uiView.removeOverlay($0)
                }
            })

            uiView.removeOverlays(myAzimuth.mapView.overlays)
            uiView.removeAnnotations(uiView.annotations)
            
            let myPins = [myAzimuth.myPin]
            uiView.addAnnotations(myPins)
            
            if myAzimuth.destinationPin.count == 1 {
                uiView.addAnnotation(myAzimuth.destinationPin[0])
            }
            if myAzimuth.destinationPin.count == 2 {
                uiView.addAnnotation(myAzimuth.destinationPin[1])
            }

            let polyline0 = MKGeodesicPolyline(coordinates: myAzimuth.coordinates0, count: myAzimuth.coordinates0.count)
            let polyline1 = MKGeodesicPolyline(coordinates: myAzimuth.coordinates1, count: myAzimuth.coordinates1.count)
            let polyline2 = MKGeodesicPolyline(coordinates: myAzimuth.coordinates2, count: myAzimuth.coordinates2.count)
            let polyline3 = MKGeodesicPolyline(coordinates: myAzimuth.coordinates3, count: myAzimuth.coordinates3.count)
            let polyline4 = MKGeodesicPolyline(coordinates: myAzimuth.coordinates4, count: myAzimuth.coordinates4.count)
            let polyline5 = MKGeodesicPolyline(coordinates: myAzimuth.coordinates5, count: myAzimuth.coordinates5.count)
            let polyline6 = MKGeodesicPolyline(coordinates: myAzimuth.coordinates6, count: myAzimuth.coordinates6.count)
            let polyline7 = MKGeodesicPolyline(coordinates: myAzimuth.coordinates7, count: myAzimuth.coordinates7.count)

            uiView.addOverlay(polyline0)
            uiView.addOverlay(polyline1)
            uiView.addOverlay(polyline2)
            uiView.addOverlay(polyline3)
            uiView.addOverlay(polyline4)
            uiView.addOverlay(polyline5)
            uiView.addOverlay(polyline6)
            uiView.addOverlay(polyline7)
            
        } else if !drawing {
            //print("\(#file) - \(#function) : NOT DRAWING POLYLINE!")
            
            // slow
//            uiView.overlays.forEach({
//                if $0 is MKPolyline {
//                    let ppp = $0 as! MKGeodesicPolyline
//                    if ppp.title == "arrow" {
//                        uiView.removeOverlay($0)
//                    }
//                }
//            })
//
//            if !first {
//                var coordinatesC: [CLLocationCoordinate2D] = []
//                coordinatesC.append(myAzimuth.center)
//                coordinatesC.append(circle)
//                let polylineC = MKGeodesicPolyline(coordinates: coordinatesC, count: coordinatesC.count)
//                polylineC.title = "arrow"
//                uiView.addOverlay(polylineC)
//            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
        
        var parent: MapView
        var tapGestureRecognizer = UITapGestureRecognizer()
        var longPressGestureRecognizer = UILongPressGestureRecognizer()
        var panGestureRecognizer = UIPanGestureRecognizer()
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            self.tapGestureRecognizer.delegate = self
            self.parent.myAzimuth.mapView.addGestureRecognizer(tapGestureRecognizer)
            self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
            self.longPressGestureRecognizer.delegate = self
            self.longPressGestureRecognizer.minimumPressDuration = 0.5
            self.parent.myAzimuth.mapView.addGestureRecognizer(longPressGestureRecognizer)
            
            // slow
            self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
            self.panGestureRecognizer.delegate = self
            self.parent.myAzimuth.mapView.addGestureRecognizer(panGestureRecognizer)
        }
        
        func initialPolyline(_ manager: CLLocationManager) {
            if !self.parent.isInit, let lat = manager.location?.coordinate.latitude, let lon = manager.location?.coordinate.longitude {
                let center = CLLocationCoordinate2DMake(lat, lon)
                self.parent.myAzimuth.center = center
                self.parent.myAzimuth.mapView.setCenter(center, animated: false)
                
                //self.parent.drawing = true
                self.parent.isInit = true
                let polylineCalculator = PolylineCalculator(preferences: self.parent.preferences, myAzimuth: self.parent.myAzimuth)
                polylineCalculator.calc()
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            //print("\(#file) - \(#function)")
            
            switch manager.authorizationStatus {
            case .notDetermined:
                // アプリ初回起動時に「""に位置情報の使用を許可しますか？」が表示される前に呼ばれる。
                //print("notDetermined")
                return
            case .restricted:
                //print("restricted")
                return
            case .denied:
                // 「""に位置情報の使用を許可しますか？」で「許可しない」を選択すると呼ばれる。座標は(0,0)
                //print("denied")
                let center = CLLocationCoordinate2DMake(35.681236, 139.767125)
                self.parent.myAzimuth.center = center
                self.parent.myAzimuth.mapView.setCenter(center, animated: false)
                
                //self.parent.drawing = true
                self.parent.isInit = true
                let polylineCalculator = PolylineCalculator(preferences: self.parent.preferences, myAzimuth: self.parent.myAzimuth)
                polylineCalculator.calc()
            case .authorizedAlways:
                //print("authorizedAlways")
                initialPolyline(manager)
            case .authorizedWhenInUse:
                // 「""に位置情報の使用を許可しますか？」で「Appの使用中は許可」を選択すると呼ばれる。座標は現在地
                // 「""に位置情報の使用を許可しますか？」で「1度だけ許可」を選択すると呼ばれる。座標は現在地
                // アプリ再起動時にも呼ばれる。
                //print("authorizedWhenInUse")
                initialPolyline(manager)
            default:
                //print("default")
                initialPolyline(manager)
            }
            // 「""を使用をしていないときでも位置情報の使用を許可しますか？」で「"常に許可"に変更」を選択すると...
            // 「""を使用をしていないときでも位置情報の使用を許可しますか？」で「"使用中のみ許可"のままにする」を選択すると...
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            //print("\(#file) - \(#function)")
        }
        
        func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
            //print("\(#file) - \(#function)")
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let polylineRenderer = MKPolylineRenderer(polyline: polyline)
                polylineRenderer.strokeColor = UIColor(self.parent.colorScheme == .dark ? Color(red: 255/255, green: 230/215, blue: 0/255) : .red)
                polylineRenderer.lineWidth = 1.0
                return polylineRenderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            //print("\(#file) - \(#function)")
            if self.parent.myAzimuth.coordinates0.count > 1 {
                let distance = CLLocation(latitude: self.parent.myAzimuth.center.latitude, longitude: self.parent.myAzimuth.center.longitude).distance(from: CLLocation(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude))
                self.parent.distance = String(format: "%.1f", (distance.magnitude / 1000))
                self.parent.drawing = false
                self.parent.searching = false
                
                //print("\(self.parent.myAzimuth.center.latitude), \(self.parent.myAzimuth.center.longitude) -> \(mapView.region.center.latitude), \(mapView.region.center.longitude)")
                
                let lat1 = self.parent.myAzimuth.center.latitude * Double.pi / 180.0
                let lon1 = self.parent.myAzimuth.center.longitude * Double.pi / 180.0
                let lat2 = mapView.region.center.latitude * Double.pi / 180.0
                let lon2 = mapView.region.center.longitude * Double.pi / 180.0
                
                let dLon = lon2 - lon1
                let y = sin(dLon) * cos(lat2)
                let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
                let d = atan2(y, x) * 180.0 / Double.pi
                //print("degree: \(d)")
                if d >= 0.0 {
                    self.parent.azimuth = d * Double.pi / 180
                } else {
                    self.parent.azimuth = (d + 360) * Double.pi / 180
                }
                //print("radian: \(self.parent.azimuth)")
            }
            self.parent.circle = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        }
        
        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            //print("\(#file) - \(#function)")
            //self.parent.center = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            //print("\(#file) - \(#function)")
            initialPolyline(manager)
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
            }  else {
                print("error")
                return 0.0
            }
            return 0.0
        }
        
        @objc func longPressHandler(_ gesture: UILongPressGestureRecognizer) {
            
            // ロングプレスしたポイントにピン
//            let location = longPressGestureRecognizer.location(in: self.parent.mapView)
//            let coordinate = self.parent.mapView.convert(location, toCoordinateFrom: self.parent.mapView)
//            self.parent.coordinate = coordinate
            
            // マップ中心にピン
            let coordinate = CLLocationCoordinate2DMake(self.parent.myAzimuth.mapView.region.center.latitude, self.parent.myAzimuth.mapView.region.center.longitude)
            //self.parent.coordinate = coordinate
            
            if gesture.state == UILongPressGestureRecognizer.State.ended {

            } else if gesture.state == UILongPressGestureRecognizer.State.began {
                print("\(coordinate.latitude), \(coordinate.longitude)")
//                self.parent.previousCheckPoints = self.parent.checkPoints
//                let checkPoint = CheckPoint(
//                    title: "You",
//                    coordinate: .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
//                )
//                self.parent.checkPoints = [checkPoint]
//                self.parent.myAzimuth.center = coordinate
//
//                let distance = 6378136.6
//
//                let argument = Double(self.parent.preferences.argument)!
//                let angle = self.parent.preferences.angle
//
//                let antipodes = self.parent.getAntipodes(origin: coordinate)
//
//                self.parent.myAzimuth.coordinates0 = []
//                self.parent.myAzimuth.coordinates0.append(coordinate)
//                let l0 = self.parent.getLocation(origin: coordinate, angle: getAngle(index: 0, argument: argument, angle: angle), distance: distance)
//                //print("0: \(l0.latitude), \(l0.longitude)")
//                self.parent.myAzimuth.coordinates0.append(l0)
//                self.parent.myAzimuth.coordinates0.append(antipodes)
//                self.parent.myAzimuth.coordinates0 = self.parent.coordinates0
//
//                self.parent.myAzimuth.coordinates1 = []
//                self.parent.myAzimuth.coordinates1.append(coordinate)
//                let l1 = self.parent.getLocation(origin: coordinate, angle: getAngle(index: 1, argument: argument, angle: angle), distance: distance)
//                //print("1: \(l1.latitude), \(l1.longitude)")
//                self.parent.myAzimuth.coordinates1.append(l1)
//                self.parent.myAzimuth.coordinates1.append(antipodes)
//                self.parent.myAzimuth.coordinates1 = self.parent.coordinates1
//
//                self.parent.myAzimuth.coordinates2 = []
//                self.parent.myAzimuth.coordinates2.append(coordinate)
//                let l2 = self.parent.getLocation(origin: coordinate, angle: getAngle(index: 2, argument: argument, angle: angle), distance: distance)
//                //print("2: \(l2.latitude), \(l2.longitude)")
//                self.parent.myAzimuth.coordinates2.append(l2)
//                self.parent.myAzimuth.coordinates2.append(antipodes)
//                self.parent.myAzimuth.coordinates2 = self.parent.coordinates2
//
//                self.parent.myAzimuth.coordinates3 = []
//                self.parent.myAzimuth.coordinates3.append(coordinate)
//                let l3 = self.parent.getLocation(origin: coordinate, angle: getAngle(index: 3, argument: argument, angle: angle), distance: distance)
//                //print("3: \(l3.latitude), \(l3.longitude)")
//                self.parent.myAzimuth.coordinates3.append(l3)
//                self.parent.myAzimuth.coordinates3.append(antipodes)
//                self.parent.myAzimuth.coordinates3 = self.parent.coordinates3
//
//                self.parent.coordinates4 = []
//                self.parent.coordinates4.append(coordinate)
//                let l4 = self.parent.getLocation(origin: coordinate, angle: getAngle(index: 4, argument: argument, angle: angle), distance: distance)
//                //print("4: \(l4.latitude), \(l4.longitude)")
//                self.parent.coordinates4.append(l4)
//                self.parent.coordinates4.append(antipodes)
//                self.parent.myAzimuth.coordinates4 = self.parent.coordinates4
//
//                self.parent.coordinates5 = []
//                self.parent.coordinates5.append(coordinate)
//                let l5 = self.parent.getLocation(origin: coordinate, angle: getAngle(index: 5, argument: argument, angle: angle), distance: distance)
//                //print("5: \(l5.latitude), \(l5.longitude)")
//                self.parent.coordinates5.append(l5)
//                self.parent.coordinates5.append(antipodes)
//                self.parent.myAzimuth.coordinates5 = self.parent.coordinates5
//
//                self.parent.coordinates6 = []
//                self.parent.coordinates6.append(coordinate)
//                let l6 = self.parent.getLocation(origin: coordinate, angle: getAngle(index: 6, argument: argument, angle: angle), distance: distance)
//                //print("6: \(l6.latitude), \(l6.longitude)")
//                self.parent.coordinates6.append(l6)
//                self.parent.coordinates6.append(antipodes)
//                self.parent.myAzimuth.coordinates6 = self.parent.coordinates6
//
//                self.parent.coordinates7 = []
//                self.parent.coordinates7.append(coordinate)
//                let l7 = self.parent.getLocation(origin: coordinate, angle: getAngle(index: 7, argument: argument, angle: angle), distance: distance)
//                //print("7: \(l7.latitude), \(l7.longitude)")
//                self.parent.coordinates7.append(l7)
//                self.parent.coordinates7.append(antipodes)
//                self.parent.myAzimuth.coordinates7 = self.parent.coordinates7
//
//                self.parent.drawing = true
            }
        }
        
        @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
        }
        
        // slow
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }

        // slow
        @objc func panHandler(_ gesture: UIPanGestureRecognizer) {
            //self.parent.circle = CLLocationCoordinate2DMake(self.parent.mapView.region.center.latitude, self.parent.mapView.region.center.longitude)
            //print("paned")
        }
    }
    
//    func getAntipodes(origin: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//        return CLLocationCoordinate2DMake(-1 * origin.latitude, origin.longitude - 180)
//    }
//
//    func getAntipodesLocation(origin: CLLocationCoordinate2D, angle: Double) -> CLLocationCoordinate2D {
//        let antipodes = CLLocationCoordinate2DMake(-1 * origin.latitude, origin.longitude - 180)
//        print("\(origin.latitude), \(origin.longitude) -> \(antipodes.latitude), \(antipodes.longitude)")
//        return getLocation(origin: antipodes, angle: angle, distance: 700000)
//    }
//
//    func getLocation(origin: CLLocationCoordinate2D, angle: Double, distance: Double) -> CLLocationCoordinate2D {
//        let distanceFraction = distance / 6378136.6
//        let angleRadian = angle * Double.pi / 180.0
//
//        //print("input: \(origin.latitude), \(origin.longitude)")
//
//        let latitudeSourceRadian = origin.latitude * Double.pi / 180.0
//        let longitudeSourceRadian = origin.longitude * Double.pi / 180.0
//
//        let latitudeDestinationRadian = asin(sin(latitudeSourceRadian) * cos(distanceFraction) + cos(latitudeSourceRadian) * sin(distanceFraction) * cos(angleRadian))
//        let longitudeDestinationRadianTemp =  atan2(sin(angleRadian) * sin(distanceFraction) * cos(latitudeSourceRadian), cos(distanceFraction) - sin(latitudeSourceRadian) * sin(latitudeDestinationRadian))
//        let longitudeDestinationRadianTemp2 = (longitudeSourceRadian + longitudeDestinationRadianTemp + 3 * Double.pi)
//        let longitudeDestinationRadianTemp3 = longitudeDestinationRadianTemp2.truncatingRemainder(dividingBy: (2 * Double.pi))
//        let longitudeDestinationRadian = longitudeDestinationRadianTemp3 - Double.pi
//
//        let latitudeDestinationDegree = latitudeDestinationRadian * 180.0 / Double.pi
//        let longitudeDestinationDegree = longitudeDestinationRadian * 180.0 / Double.pi
//
//        //print("output: \(latitudeDestinationDegree), \(longitudeDestinationDegree)")
//        return CLLocationCoordinate2DMake(latitudeDestinationDegree, longitudeDestinationDegree)
//    }
//
//    func getAngle(index: Int, argument: Double, angle: String) -> Double {
//
//        print("angle in = \(angle)")
//        if angle == "0" {
//            if index == 0 {
//                return 15.0 + argument
//            } else if index == 1 {
//                return 75.0 + argument
//            } else if index == 2 {
//                return 105.0 + argument
//            } else if index == 3 {
//                return 165.0 + argument
//            } else if index == 4 {
//                return 195.0 + argument
//            } else if index == 5 {
//                return 255.0 + argument
//            } else if index == 6 {
//                return 285.0 + argument
//            } else if index == 7 {
//                return 345.0 + argument
//            }
//        }else if angle == "1" {
//            if index == 0 {
//                return 22.5 + argument
//            } else if index == 1 {
//                return 67.5 + argument
//            } else if index == 2 {
//                return 112.5 + argument
//            } else if index == 3 {
//                return 157.5 + argument
//            } else if index == 4 {
//                return 202.5 + argument
//            } else if index == 5 {
//                return 247.5 + argument
//            } else if index == 6 {
//                return 292.5 + argument
//            } else if index == 7 {
//                return 337.5 + argument
//            }
//        }  else {
//            print("error")
//            return 0.0
//        }
//        return 0.0
//    }
//
//    func drawPolyline() {
//        print("\(coordinate.latitude), \(coordinate.longitude)")
//        previousCheckPoints = checkPoints
//        let checkPoint = CheckPoint(
//            title: "You",
//            coordinate: .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        )
//        checkPoints = [checkPoint]
//
//        let distance = 6378136.6
//
//        let argument = Double(preferences.argument)!
//        let angle = preferences.angle
//        print("angle = \(angle)")
//
//        let antipodes = getAntipodes(origin: coordinate)
//
//        coordinates0 = []
//        coordinates0.append(coordinate)
//        let l0 = getLocation(origin: coordinate, angle: getAngle(index: 0, argument: argument, angle: angle), distance: distance)
//        print("0: \(l0.latitude), \(l0.longitude)")
//        coordinates0.append(l0)
//        coordinates0.append(antipodes)
//
//        coordinates1 = []
//        coordinates1.append(coordinate)
//        let l1 = getLocation(origin: coordinate, angle: getAngle(index: 1, argument: argument, angle: angle), distance: distance)
//        print("1: \(l1.latitude), \(l1.longitude)")
//        coordinates1.append(l1)
//        coordinates1.append(antipodes)
//
//        coordinates2 = []
//        coordinates2.append(coordinate)
//        let l2 = getLocation(origin: coordinate, angle: getAngle(index: 2, argument: argument, angle: angle), distance: distance)
//        print("2: \(l2.latitude), \(l2.longitude)")
//        coordinates2.append(l2)
//        coordinates2.append(antipodes)
//
//        coordinates3 = []
//        coordinates3.append(coordinate)
//        let l3 = getLocation(origin: coordinate, angle: getAngle(index: 3, argument: argument, angle: angle), distance: distance)
//        print("3: \(l3.latitude), \(l3.longitude)")
//        coordinates3.append(l3)
//        coordinates3.append(antipodes)
//
//        coordinates4 = []
//        coordinates4.append(coordinate)
//        let l4 = getLocation(origin: coordinate, angle: getAngle(index: 4, argument: argument, angle: angle), distance: distance)
//        print("4: \(l4.latitude), \(l4.longitude)")
//        coordinates4.append(l4)
//        coordinates4.append(antipodes)
//
//        coordinates5 = []
//        coordinates5.append(coordinate)
//        let l5 = getLocation(origin: coordinate, angle: getAngle(index: 5, argument: argument, angle: angle), distance: distance)
//        print("5: \(l5.latitude), \(l5.longitude)")
//        coordinates5.append(l5)
//        coordinates5.append(antipodes)
//
//        coordinates6 = []
//        coordinates6.append(coordinate)
//        let l6 = getLocation(origin: coordinate, angle: getAngle(index: 6, argument: argument, angle: angle), distance: distance)
//        print("6: \(l6.latitude), \(l6.longitude)")
//        coordinates6.append(l6)
//        coordinates6.append(antipodes)
//
//        coordinates7 = []
//        coordinates7.append(coordinate)
//        let l7 = getLocation(origin: coordinate, angle: getAngle(index: 7, argument: argument, angle: angle), distance: distance)
//        print("7: \(l7.latitude), \(l7.longitude)")
//        coordinates7.append(l7)
//        coordinates7.append(antipodes)
//    }

}


