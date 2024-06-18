import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - ExplorePage

struct ExplorePage {
  @Bindable var store: StoreOf<ExploreReducer>
}

extension ExplorePage {
  private var isLoading: Bool {
    store.fetchItem.isLoading
  }
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
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getItem)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
