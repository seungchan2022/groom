import ComposableArchitecture
import SwiftUI

// MARK: - WishListPage

struct WishListPage {
  @Bindable var store: StoreOf<WishListReducer>
}

// MARK: View

extension WishListPage: View {
  var body: some View {
    ScrollView {
      switch store.state.status {
      case .isLoggedIn:
        VStack(alignment: .leading) {
          Text("로그인 성공")
            .font(.largeTitle)

          Text("User ID: \(store.item.uid)")
          Text("User Email: \(store.item.email ?? "")")
        }
        .padding(.top, 32)
        .padding(.leading, 16)

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
    .onAppear {
      store.send(.getUser)
      store.send(.getUserInfo)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
