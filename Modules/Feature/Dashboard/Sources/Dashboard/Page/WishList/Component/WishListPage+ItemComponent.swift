import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - WishListPage.ItemComponent

extension WishListPage {
  struct ItemComponent {
    @Bindable var store: StoreOf<WishListReducer>

    let viewState: ViewState
    let tapAction: (Airbnb.WishList.Item) -> Void
  }
}

extension WishListPage.ItemComponent { }

// MARK: - WishListPage.ItemComponent + View

extension WishListPage.ItemComponent: View {
  var body: some View {
    VStack {
      if store.isGridLayout {
        VStack(spacing: 8) {
          TabView {
            ForEach(DesignSystemImage.allCases.shuffled().prefix(4), id: \.self) { item in
              item.image
                .resizable()
                .scaledToFill()
            }
          }
          .frame(height: 320)
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .tabViewStyle(.page)

          HStack(alignment: .top) {
            VStack(alignment: .leading) {
              Text(viewState.item.location)
                .multilineTextAlignment(.leading)
                .fontWeight(.semibold)

              Text(viewState.item.country)

              Text(viewState.item.city)

              HStack {
                Text("$\(viewState.item.price)")
                  .fontWeight(.semibold)
              }
            }

            Spacer()

            Text("후기 \(viewState.item.reviewCount)개")
              .underline()
          }
          .foregroundStyle(.black)
          .font(.callout)
        }
      } else {
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
      }
    }
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
