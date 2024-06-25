import Architecture
import ComposableArchitecture
import DesignSystem
import Functor
import SwiftUI

// MARK: - HomePage

struct HomePage {
  @Bindable var store: StoreOf<HomeReducer>

  @Bindable var exploreStore: StoreOf<ExploreReducer>

}

extension HomePage {

  private var cityItemList: [String] {
    [
      "London", "Paris", "Sicily", "New-york-city", "Shanghai", "Puglia", "Sydney",
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

  private var countryItemList: [String] {
    [
      "United states", "Italy", "Spain", "United kingdom", "France", "Australia", "China", "Greece", "Canada", "Ireland",
      "Germany", "Portugal", "Brazil", "Denmark", "Argentina", "South africa", "Turkey", "Mexico", "Netherlands",
      "Chile", "Japan", "Austria", "Belgium", "Czech republic", "Norway", "Taiwan", "Switzerland", "Sweden", "Singapore",
      "Belize",
    ]
  }
}

// MARK: View

extension HomePage {
  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.Dashboard.Path.home.rawValue)
  }
  
  private var queryBinder: Binding<String> {
    .init(
      get: { store.query },
      set: { new in
        guard store.query != new else { return }
        store.send(.set(\.query, new))

        guard !new.isEmpty else { return }
        store.send(.searchCity(new))
      })
  }

  private var countryBinder: Binding<String> {
    .init(
      get: { store.country },
      set: { new in
        guard store.country != new else { return }
        store.send(.set(\.country, new))

        guard !new.isEmpty else { return }
        store.send(.searchCountry(new))
      })
  }

  private var isLoading: Bool {
    store.fetchSearchCityItem.isLoading
      || store.fetchSearchCountryItem.isLoading
  }
}

// MARK: View

extension HomePage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: "Home") {
        VStack {
          VStack {
            HStack {
              Text("City")
              Spacer()

              Picker("", selection: queryBinder) {
                Text("Select a city")
                  .tag("")
                ForEach(cityItemList, id: \.self) { item in
                  Text(item)
                    .tag(item)
                }
              }
              .pickerStyle(.menu)
              .tint(.gray)
            }
            .padding(.leading, 16)

            Divider()

            HStack {
              Text("Country")
              Spacer()

              Picker("", selection: countryBinder) {
                Text("Select a country")
                  .tag("")
                ForEach(countryItemList, id: \.self) { item in
                  Text(item)
                    .tag(item)
                }
              }
              .pickerStyle(.menu)
              .tint(.gray)
            }
            .padding(.leading, 16)
          }
          .background {
            RoundedRectangle(cornerRadius: 5)
              .stroke(.black, lineWidth: 1)
          }
          .padding(.horizontal, 12)

          switch (store.query.isEmpty, store.country.isEmpty) {
          case (true, true):
            ExplorePage(store: exploreStore)

          case (false, true):
            ScrollView {
              LazyVStack(spacing: 48) {
                ForEach(store.searchCityItemList) { item in
                  SearchCityResultComponent(
                    viewState: .init(item: item),
                    tapAction: { store.send(.routeToCityDetail($0)) })
                }
              }
              .padding(.horizontal, 16)
            }

          case (true, false):
            ScrollView {
              LazyVStack(spacing: 48) {
                ForEach(store.searchCountryItemList) { item in
                  SearchCountryResultComponent(
                    viewState: .init(item: item),
                    tapAction: { store.send(.routeToCountryDetail($0)) })
                }
              }
              .padding(.horizontal, 16)
            }

          case (false, false):
            EmptyView()
          }
        }
      }
      
      
      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { store.send(.routeToTabBarItem($0)) })
    }
    .scrollDismissesKeyboard(.immediately)
    .toolbar(.hidden, for: .navigationBar)
    .ignoresSafeArea(.all, edges: .bottom)
    .setRequestFlightView(isLoading: isLoading)
    .onChange(of: store.query) { _, new in
      guard !new.isEmpty else { return }
      store.send(.set(\.country, ""))
    }
    .onChange(of: store.country) { _, new in
      guard !new.isEmpty else { return }
      store.send(.set(\.query, ""))
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
