import SwiftUI
import ComposableArchitecture

struct HomePage {
  @Bindable var store: StoreOf<HomeReducer>
}

extension HomePage: View {
  var body: some View {
    Text("Home Page")
  }
}
