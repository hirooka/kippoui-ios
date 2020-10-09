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
    
    @ObservedObject var watchConnector = WatchConnector()
    
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

        if myAzimuth.coordinates.count > 1 && (drawing || isInit) {
        //if myAzimuth.coordinates0.count > 1 && myAzimuth.coordinates1.count > 1 && (drawing || isInit) {
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
            
            for cs in myAzimuth.coordinates {
                let polyline = MKGeodesicPolyline(coordinates: cs, count: cs.count)
                uiView.addOverlay(polyline)
            }
            
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
            if self.parent.myAzimuth.coordinates.count > 1 {
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
            
            //
            if let lat = manager.location?.coordinate.latitude, let lon = manager.location?.coordinate.longitude {
                
                let distanceDouble = CLLocation(latitude: self.parent.myAzimuth.center.latitude, longitude: self.parent.myAzimuth.center.longitude).distance(from: CLLocation(latitude: lat, longitude: lon))
                let distance = String(format: "%.1f", (distanceDouble.magnitude / 1000))
                
                let lat1 = self.parent.myAzimuth.center.latitude * Double.pi / 180.0
                let lon1 = self.parent.myAzimuth.center.longitude * Double.pi / 180.0
                let lat2 = lat * Double.pi / 180.0
                let lon2 = lon * Double.pi / 180.0
                
                let dLon = lon2 - lon1
                let y = sin(dLon) * cos(lat2)
                let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
                let d = atan2(y, x) * 180.0 / Double.pi
                //print("degree: \(d)")
                var azimuth = "-"
                var degree = 0.0
                if d >= 0.0 {
                    azimuth = String(format: "%.1f", d)
                    degree = d
                } else {
                    azimuth = String(format: "%.1f", d + 360)
                    degree = d + 360
                }
                let direction = getDirection(d: degree)
                
                let latitude = String(format: "%.6f", lat)
                let longitude = String(format: "%.6f", lon)
                
                let df = DateFormatter()
                df.dateStyle = .medium
                df.timeStyle = .medium
                let now = df.string(from: Date())
                let message = ["now":now, "latitude":"\(latitude)", "longitude":"\(longitude)", "azimuth":"\(azimuth)", "distance":"\(distance)", "direction": direction] as [String : Any]
                print("\(message)")
                self.parent.watchConnector.sendMessage(message: message)
            }
        }
        
        func getDirection(d: Double) -> String {
            let a = Double(self.parent.preferences.argument)!
            let lineType = self.parent.preferences.lineType
            if lineType == 0 { // 30
                if d > 345.0 - a && d < 15.0 - a {
                    return "北"
                } else if d > 15.0 - a && d < 75.0 - a {
                    return "北東"
                } else if d > 75.0 - a && d < 105.0 - a {
                    return "東"
                } else if d > 105.0 - a && d < 165.0 - a {
                    return "南東"
                } else if d > 165.0 - a && d < 195.0 - a {
                    return "南"
                } else if d > 195.0 - a && d < 255.0 - a {
                    return "南西"
                } else if d > 255.0 - a && d < 285.0 - a {
                    return "西"
                } else if d > 285.0 - a && d < 345.0 - a {
                    return "北西"
                }
            } else if lineType == 1 { // 45
                if d > 337.5 - a && d < 22.5 - a {
                    return "北"
                } else if d > 22.5 - a && d < 67.5 - a {
                    return "北東"
                } else if d > 67.5 - a && d < 112.5 - a {
                    return "東"
                } else if d > 112.5 - a && d < 157.5 - a {
                    return "南東"
                } else if d > 157.5 - a && d < 202.5 - a {
                    return "南"
                } else if d > 202.5 - a && d < 247.5 - a {
                    return "南西"
                } else if d > 247.5 - a && d < 292.5 - a {
                    return "西"
                } else if d > 292.5 - a && d < 337.5 - a {
                    return "北西"
                }
            } else if lineType == 2 {
                if d > 345.0 - a && d < 15.0 - a {
                    return "子"
                } else if d > 15.0 - a && d < 45.0 - a {
                    return "丑"
                } else if d > 45.0 - a && d < 75.0 - a {
                    return "寅"
                } else if d > 75.0 - a && d < 105.0 - a {
                    return "卯"
                } else if d > 105.0 - a && d < 135.0 - a {
                    return "辰"
                } else if d > 135.0 - a && d < 165.0 - a {
                    return "巳"
                } else if d > 165.0 - a && d < 195.0 - a {
                    return "午"
                } else if d > 195.0 - a && d < 225.0 - a {
                    return "未"
                } else if d > 225.0 - a && d < 255.0 - a {
                    return "申"
                } else if d > 255.0 - a && d < 285.0 - a {
                    return "酉"
                } else if d > 285.0 - a && d < 315.0 - a {
                    return "戌"
                } else if d > 315.0 - a && d < 345.0 - a {
                    return "亥"
                }
            } else if lineType == 3 {
                if d > 352.5 - a && d < 7.5 - a {
                    return "子"
                } else if d > 7.5 - a && d < 22.5 - a {
                    return "癸"
                } else if d > 22.5 - a && d < 37.5 - a {
                    return "丑"
                } else if d > 37.5 - a && d < 52.5 - a {
                    return "艮"
                } else if d > 52.5 - a && d < 67.5 - a {
                    return "寅"
                } else if d > 67.5 - a && d < 82.5 - a {
                    return "甲"
                } else if d > 82.5 - a && d < 97.5 - a {
                    return "卯"
                } else if d > 97.5 - a && d < 112.5 - a {
                    return "乙"
                } else if d > 112.5 - a && d < 127.5 - a {
                    return "辰"
                } else if d > 127.5 - a && d < 142.5 - a {
                    return "巽"
                } else if d > 142.5 - a && d < 157.5 - a {
                    return "巳"
                } else if d > 157.5 - a && d < 172.5 - a {
                    return "丙"
                } else if d > 172.5 - a && d < 187.5 - a {
                    return "午"
                } else if d > 187.5 - a && d < 202.5 - a {
                    return "丁"
                } else if d > 202.5 - a && d < 217.5 - a {
                    return "未"
                } else if d > 217.5 - a && d < 232.5 - a {
                    return "坤"
                } else if d > 232.5 - a && d < 247.5 - a {
                    return "申"
                } else if d > 247.5 - a && d < 262.5 - a {
                    return "庚"
                } else if d > 262.5 - a && d < 277.5 - a {
                    return "酉"
                } else if d > 277.5 - a && d < 292.5 - a {
                    return "辛"
                } else if d > 292.5 - a && d < 307.5 - a {
                    return "戌"
                } else if d > 307.5 - a && d < 322.5 - a {
                    return "乾"
                } else if d > 322.5 - a && d < 337.5 - a {
                    return "亥"
                } else if d > 337.5 - a && d < 352.5 - a {
                    return "壬"
                }
            }
            return "-"
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
}


