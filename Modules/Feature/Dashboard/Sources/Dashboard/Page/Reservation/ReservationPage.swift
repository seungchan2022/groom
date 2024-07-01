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
        VStack {
          Text("예약 페이지")
          Text("\(store.reservationItemList.count)")

          ForEach(store.reservationItemList, id: \.id) { item in
            Text(item.name)
          }
        }
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
