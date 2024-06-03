import Architecture
import ComposableArchitecture
import DesignSystem
import Functor
import SwiftUI

// MARK: - HomePage

struct HomePage {
  @Bindable var store: StoreOf<HomeReducer>

  @Bindable var exploreStore: StoreOf<ExploreReducer>

  @State var throttleEvent: ThrottleEvent = .init(value: "", delaySeconds: 1.5)
}

extension HomePage {

  private var cityItemList: [String] {
    [
      "City", "London", "Paris", "Sicily", "New-york-city", "Shanghai", "Puglia", "Sydney",
      "Beijing", "Los-angeles", "Rio-de-janeiro", "Rome", "Copenhagen", "Visualisations",
      "Berlin", "South-aegean", "Lisbon", "Buenos-aires", "Cape-town", "Istanbul",
      "Melbourne", "Hawaii", "Mexico-city", "Madrid", "Toronto", "Barcelona", "Milan",
      "Girona", "Amsterdam", "Crete", "Montreal", "Mallorca", "Santiago", "Tokyo",
      "Vienna", "San-diego", "Edinburgh", "Prague", "Western-australia", "Lyon",
      "Florence", "Porto", "Athens", "Hong-kong", "Munich", "Bordeaux", "Broward-county",
      "Clark-county-nv", "Austin", "Brussels", "Oslo", "Washington-dc", "Venice",
      "Dublin", "Taipei", "Naples", "Stockholm", "Chicago", "Valencia", "San-francisco",
      "Singapore", "Santa-clara-county", "New-orleans", "Nashville", "Sevilla",
      "Seattle", "Twin-cities-msa", "Malaga", "Northern-rivers", "Euskadi", "Vancouver",
      "Barwon-south-west-vic", "Tasmania", "Greater-manchester", "Vaud", "Portland",
      "Denver", "Bologna", "Rhode-island", "Victoria", "Boston", "Geneva", "Menorca",
      "Oakland", "Thessaloniki", "Belize", "Ottawa", "San-mateo-county", "Bristol",
      "Bergamo", "Jersey-city", "Quebec-city", "Antwerp", "Asheville", "New-brunswick",
      "Trentino", "Santa-cruz-county", "Columbus", "Ghent", "Cambridge", "Barossa-valley",
      "Salem-or", "Pacific-grove",
    ]
  }
}

// MARK: View

extension HomePage: View {
  var body: some View {
    VStack {
      HStack {
        Text("City")
        Spacer()

        Picker("", selection: $store.query) {
          ForEach(cityItemList, id: \.self) { item in
            Text(item)
              .tag(item)
          }
        }
        .pickerStyle(.menu)
        .tint(.gray)
      }
      .padding(.leading, 16)

      if store.query.isEmpty {
        ExplorePage(store: exploreStore)
      } else {
        ScrollView {
          LazyVStack(spacing: 48) {
            ForEach(store.searchCityItemList) { item in
              SearchCityResultComponent(
                viewState: .init(item: item),
                tapAction: { store.send(.routeToSearchDetail($0)) })
            }
          }
          .padding(.horizontal, 16)
        }
      }
    }
    .scrollDismissesKeyboard(.immediately)
    .navigationTitle("Explore")
    .navigationBarTitleDisplayMode(.large)
    .toolbar(.visible, for: .navigationBar)
    .onChange(of: store.query) { _, new in
      throttleEvent.update(value: new)
    }
    .onAppear {
      throttleEvent.apply { _ in
        store.send(.searchCity(store.query))
      }
    }
    .onDisappear {
      throttleEvent.reset()
      store.send(.teardown)
    }
  }
}
