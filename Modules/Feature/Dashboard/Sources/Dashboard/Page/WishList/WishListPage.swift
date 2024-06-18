import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - WishListPage

struct WishListPage {
  @Bindable var store: StoreOf<WishListReducer>
  var routeSubscriber: WishListRouteSubscriber
}

extension WishListPage {
  private var gridColumnList: [GridItem] {
    Array(
      repeating: .init(.flexible()),
      count: store.isGridLayout ? 1 : 2)
  }

  private var isLoading: Bool {
    store.fetchUser.isLoading
      || store.fetchUserInfo.isLoading
      || store.fetchWishList.isLoading
  }
}

// MARK: View

extension WishListPage: View {
  var body: some View {
    ScrollView {
      switch store.state.status {
      case .isLoggedIn:
        VStack(alignment: .leading) {
          if store.wishList.isEmpty {
            Text("위시리스트가 없습니다. \n원하시는 숙소의 하트 버튼을 눌러 위시리스트를 추가해주세요.")
          }

          LazyVGrid(columns: gridColumnList) {
            ForEach(store.wishList.sorted(by: { $0.createdTime > $1.createdTime })) { item in
              ItemComponent(
                store: store,
                viewState: .init(item: item),
                tapAction: { store.send(.routeToDetail($0)) })
            }
          }
        }
        .padding(.top, 32)
        .padding(.horizontal, 16)

      case .isLoggedOut:
        VStack {
          VStack(alignment: .leading, spacing: 8) {
            Text("Log in to view your wishlist.")
              .font(.headline)
              .fontWeight(.bold)

            Text("You can create, view or edit wishlist once you've \nlogged in")
              .textScale(.secondary)
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 32)

          Button(action: {
            store.send(.routeToSignIn)
          }) {
            Text("Log In")
              .foregroundStyle(.white)
              .frame(height: 50)
              .frame(maxWidth: .infinity)
              .background(.pink)
              .clipShape(RoundedRectangle(cornerRadius: 8))
          }
        }
        .padding(.horizontal, 16)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .navigationTitle("WishList")
    .navigationBarTitleDisplayMode(.large)
    .toolbar {
      if store.state.status == .isLoggedIn && !store.wishList.isEmpty {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: {
            withAnimation(.smooth) {
              store.isGridLayout.toggle()
            }
          }) {
            Image(systemName: store.isGridLayout ? "rectangle.split.1x2.fill" : "rectangle.split.2x2.fill")
              .imageScale(.large)
          }
        }
      }
    }
    .onReceive(routeSubscriber.isRouteEventSubject, perform: { _ in
      store.send(.getUser)
      store.send(.getUserInfo)
      store.send(.getWishList)
    })
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getUser)
      store.send(.getUserInfo)
      store.send(.getWishList)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
