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
    .navigationTitle("WishList")
  }
}
