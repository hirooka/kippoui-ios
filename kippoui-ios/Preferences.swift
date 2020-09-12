import SwiftUI

class Preferences: ObservableObject {
    @Published var argument: String {
        didSet {
            UserDefaults.standard.set(argument, forKey: "argument")
        }
    }
    @Published var angle: String {
        didSet {
            UserDefaults.standard.set(angle, forKey: "angle")
        }
    }
    init() {
        UserDefaults.standard.register(defaults: ["argument": "0.0"])
        self.argument = UserDefaults.standard.string(forKey: "argument") ?? "0.0"
        UserDefaults.standard.register(defaults: ["angle": "0"])
        self.angle = UserDefaults.standard.string(forKey: "angle") ?? "0"
    }
}
