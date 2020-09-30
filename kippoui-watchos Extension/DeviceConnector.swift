import WatchConnectivity

class DeviceConnector: NSObject, ObservableObject, WCSessionDelegate {
    
    @Published var azimuth = "-"
    @Published var distance = "-"
    @Published var latitude = "-"
    @Published var longitude = "-"
    @Published var now = "-"
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("WCSession is activated.")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("\(#file) - \(#function)")
        print("\(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("\(#file) - \(#function)")
        print("didReceiveMessage: \(message)")
        DispatchQueue.main.async {
            self.azimuth = "\(message["azimuth"] as! String)"
            self.distance = "\(message["distance"] as! String)"
            self.latitude = "\(message["latitude"] as! String)"
            self.longitude = "\(message["longitude"] as! String)"
            self.now = "\(message["now"] as! String)"
        }
    }
}
