import UIKit
import WatchConnectivity

class WatchConnector: NSObject, ObservableObject, WCSessionDelegate {
    
//    private var preferences: Preferences
//    private var myAzimuth: MyAzimuth
    
    @Published var count = "222"
    
    let session = WCSession.default
    
    override init(/*preferences: Preferences, myAzimuth: MyAzimuth*/) {
        //self.preferences = preferences
        //self.myAzimuth = myAzimuth
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
            print("WCSession is activated.")
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("\(#file) - \(#function)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#file) - \(#function)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("\(#file) - \(#function)")
    }
    
    func sendMessage() {
        print("\(#file) - \(#function)")
        if session.isReachable {
            session.sendMessage(["count":count], replyHandler: nil, errorHandler: { error in
                print("\(error)")
            })
        }
    }
    
    func sendMessage(message: [String : Any]) {
        print("\(#file) - \(#function)")
        if session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("\(error)")
            })
        }
    }
    
}
