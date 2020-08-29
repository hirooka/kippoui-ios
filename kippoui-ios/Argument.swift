import SwiftUI

class Argument: ObservableObject {
    @Published var value: Double {
        didSet {
            UserDefaults.standard.set(value, forKey: "value")
        }
    }
    init() {
        UserDefaults.standard.register(defaults: ["value": 7.2])
        self.value = UserDefaults.standard.double(forKey: "value")
    }
}
