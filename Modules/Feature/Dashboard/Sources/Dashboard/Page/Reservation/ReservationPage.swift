import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - ReservationPage

struct ReservationPage {
  @Bindable var store: StoreOf<ReservationReducer>
}

extension ReservationPage { }

// MARK: View

extension ReservationPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(
          backAction: .init(
            image: Image(systemName: "chevron.left"),
            action: { store.send(.routeToBack) }),
          title: ""),
        largeTitle: "예약 현황")
      {
        VStack(alignment: .leading) {

          if store.reservationItemList.isEmpty {
            Text("예약된 상품이 없습니다.")
          }
          
          LazyVStack(alignment: .leading, spacing: 48) {
            ForEach(store.reservationItemList, id: \.id) { item in
              ItemComponent(
                store: store,
                viewState: .init(item: item),
                tapAction: { _ in })
            }
          }
        }
        .padding(.horizontal, 16)
      }
    }
    .onAppear {
      store.send(.getReservationItemList)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
