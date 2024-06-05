import DesignSystem
import Domain
import SwiftUI

// MARK: - HomePage.SearchCountryResultComponent

extension HomePage {
  struct SearchCountryResultComponent {
    let viewState: ViewState
    let tapAction: (Airbnb.Search.Country.Item) -> Void
  }
}

extension HomePage.SearchCountryResultComponent { }

// MARK: - HomePage.SearchCountryResultComponent + View

extension HomePage.SearchCountryResultComponent: View {
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
    }
  }
}

// MARK: - HomePage.SearchCountryResultComponent.ViewState

extension HomePage.SearchCountryResultComponent {
  struct ViewState: Equatable {
    let item: Airbnb.Search.Country.Item
  }

}
