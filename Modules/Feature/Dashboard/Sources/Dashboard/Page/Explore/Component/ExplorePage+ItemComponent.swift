import DesignSystem
import Domain
import SwiftUI

// MARK: - ExplorePage.ItemComponent

extension ExplorePage {
  struct ItemComponent {
    let viewState: ViewState
    let tapAction: (Airbnb.Listing.Item) -> Void
  }
}

extension ExplorePage.ItemComponent { }

// MARK: - ExplorePage.ItemComponent + View

extension ExplorePage.ItemComponent: View {
  var body: some View {
    Button(action: { tapAction(viewState.item) }) {
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
    }
  }
}

// MARK: - ExplorePage.ItemComponent.ViewState

extension ExplorePage.ItemComponent {
  struct ViewState: Equatable {
    let item: Airbnb.Listing.Item
  }

}
