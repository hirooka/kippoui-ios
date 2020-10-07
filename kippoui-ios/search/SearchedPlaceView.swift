import SwiftUI

struct SearchedPlaceView: View {
    
    var name: String
    var address: String

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(name).font(.largeTitle)
                //Text(address).font(.subheadline)
            }
        }
    }
}
