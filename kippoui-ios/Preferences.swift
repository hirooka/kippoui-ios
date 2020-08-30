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
        UserDefaults.standard.register(defaults: ["argument": "7.2"])
        self.argument = UserDefaults.standard.string(forKey: "argument") ?? "7.2"
        UserDefaults.standard.register(defaults: ["angle": "30"])
        self.angle = UserDefaults.standard.string(forKey: "argument") ?? "30"
    }
}
