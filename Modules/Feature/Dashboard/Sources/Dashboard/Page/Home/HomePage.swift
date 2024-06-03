import Architecture
import ComposableArchitecture
import DesignSystem
import Functor
import SwiftUI

// MARK: - HomePage

struct HomePage {
  @Bindable var store: StoreOf<HomeReducer>

  @Bindable var exploreStore: StoreOf<ExploreReducer>

  @State var throttleEvent: ThrottleEvent = .init(value: "", delaySeconds: 1.5)

}

// MARK: View

extension HomePage: View {
  var body: some View {
    VStack {
      if store.query.isEmpty {
        ExplorePage(store: exploreStore)
      } else {
        ScrollView {
          LazyVStack(spacing: 48) {
            ForEach(store.searchCityItemList) { item in
              SearchCityResultComponent(
                viewState: .init(item: item),
                tapAction: { _ in })
            }
          }
          .padding(.horizontal, 16)
        }
      }
    }
    .scrollDismissesKeyboard(.immediately)
    .navigationTitle("Explore")
    .navigationBarTitleDisplayMode(.large)
    .toolbar(.visible, for: .navigationBar)
    .searchable(text: $store.query)
    .onChange(of: store.query) { _, new in
      throttleEvent.update(value: new)
    }
    .onAppear {
      throttleEvent.apply { _ in
        store.send(.searchCity(store.query))
      }
    }
    .onDisappear {
      throttleEvent.reset()
      store.send(.teardown)
    }
  }
}
