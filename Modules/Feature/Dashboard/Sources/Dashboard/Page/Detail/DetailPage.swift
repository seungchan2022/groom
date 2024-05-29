import ComposableArchitecture
import DesignSystem
import MapKit
import SwiftUI

// MARK: - DetailPage

struct DetailPage {
  @Bindable var store: StoreOf<DetailReducer>

}

// MARK: View

extension DetailPage: View {
  var body: some View {
    ScrollView {
      if let item = store.fetchItem.value?.itemList.first(where: { $0.id == store.item.id }) {
        ItemComponent(
          viewState: .init(item: item),
          backAction: { store.send(.routeToBack) })
      }
    }
    .ignoresSafeArea()
    .toolbar(.hidden, for: .navigationBar)
    .onAppear {
      store.send(.getItem(store.item))
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
