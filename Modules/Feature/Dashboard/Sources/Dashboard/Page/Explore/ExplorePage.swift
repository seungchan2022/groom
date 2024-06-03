import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - ExplorePage

struct ExplorePage {
  @Bindable var store: StoreOf<ExploreReducer>
}

// MARK: View

extension ExplorePage: View {
  var body: some View {
    VStack {
      ScrollView {
        LazyVStack(spacing: 48) {
          ForEach(store.itemList) { item in
            ItemComponent(
              viewState: .init(item: item),
              tapAction: { store.send(.routeToDetail($0)) })
          }
        }
        .padding(.horizontal, 16)
      }
    }
    .onAppear {
      store.send(.getItem)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
