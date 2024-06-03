import DesignSystem
import Domain
import SwiftUI

// MARK: - HomePage.SearchCityResultComponent

extension HomePage {
  struct SearchCityResultComponent {
    let viewState: ViewState
    let tapAction: (Airbnb.Search.City.Item) -> Void
  }
}

extension HomePage.SearchCityResultComponent { }

// MARK: - HomePage.SearchCityResultComponent + View

extension HomePage.SearchCityResultComponent: View {
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

// MARK: - HomePage.SearchCityResultComponent.ViewState

extension HomePage.SearchCityResultComponent {
  struct ViewState: Equatable {
    let item: Airbnb.Search.City.Item
  }

}
