import DesignSystem
import Domain
import SwiftUI

// MARK: - WishListPage.ItemComponent

extension WishListPage {
  struct ItemComponent {
    let viewState: ViewState
    let tapAction: (Airbnb.WishList.Item) -> Void
  }
}

extension WishListPage.ItemComponent { }

// MARK: - WishListPage.ItemComponent + View

extension WishListPage.ItemComponent: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      DesignSystemImage.allCases.shuffled().first?.image
        .resizable()
        .frame(width: 160, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
          RoundedRectangle(cornerRadius: 20)
            .stroke(.gray, lineWidth: 2)
            .shadow(radius: 10)
        }

      Text(viewState.item.name)
        .multilineTextAlignment(.leading)

      Spacer()
    }
    .frame(height: 250)
    .onTapGesture {
      tapAction(viewState.item)
    }
  }
}

// MARK: - WishListPage.ItemComponent.ViewState

extension WishListPage.ItemComponent {
  struct ViewState: Equatable {
    let item: Airbnb.WishList.Item
  }
}
