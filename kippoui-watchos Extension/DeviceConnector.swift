import WatchConnectivity

class DeviceConnector: NSObject, ObservableObject, WCSessionDelegate {
    
    @Published var distance = "-"
    
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
            self.distance = "\(message["count"] as! String)"
        }
    }
}
