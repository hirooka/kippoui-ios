import SwiftUI

class Preferences: ObservableObject {
    
    @Published var argument: Double {
        didSet {
            UserDefaults.standard.set(argument, forKey: "argument")
        }
    }

    @Published var lineType : Int {
        didSet {
            UserDefaults.standard.set(lineType, forKey: "lineType")
        }
    }
    
    init() {
        UserDefaults.standard.register(defaults: ["argument": 0.0])
        self.argument = UserDefaults.standard.double(forKey: "argument")
        UserDefaults.standard.register(defaults: ["lineType": 0])
        self.lineType = UserDefaults.standard.integer(forKey: "lineType")
    }
}
