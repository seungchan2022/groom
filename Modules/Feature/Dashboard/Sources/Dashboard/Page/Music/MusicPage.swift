import SwiftUI
import ComposableArchitecture

struct MusicPage {
  @Bindable var store: StoreOf<MusicReducer>
}

extension MusicPage: View {
  var body: some View {
    Text("Music Detail Page")
  }
}
