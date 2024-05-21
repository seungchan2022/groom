import ComposableArchitecture
import SwiftUI

// MARK: - ExplorePage

struct ExplorePage {
  @Bindable var store: StoreOf<ExploreReducer>
}

// MARK: View

extension ExplorePage: View {
  var body: some View {
    ScrollView {
      VStack {
        Text("Explore Page")
      }
    }
    .navigationTitle("Explore")
  }
}
