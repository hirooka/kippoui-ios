import SwiftUI

struct SearchedPlaceRow: View {
    var searchedPlace: SearchedPlace
    var body: some View {
        SearchedPlaceView(name: searchedPlace.name, address: searchedPlace.address)
    }
}
