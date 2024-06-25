import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct HomeReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: HomeSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var query = ""
    var country = ""

    var searchCityItemList: [Airbnb.Search.City.Item] = []
    var searchCountryItemList: [Airbnb.Search.Country.Item] = []

    var fetchSearchCityItem: FetchState.Data<Airbnb.Search.City.Compsite?> = .init(isLoading: false, value: .none)
    var fetchSearchCountryItem: FetchState.Data<Airbnb.Search.Country.Compsite?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSearchCity
    case requestSearchCountry
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case searchCity(String)
    case searchCountry(String)

    case fetchSearchCityItem(Result<Airbnb.Search.City.Compsite, CompositeErrorRepository>)
    case fetchSearchCountryItem(Result<Airbnb.Search.Country.Compsite, CompositeErrorRepository>)

    case routeToCityDetail(Airbnb.Search.City.Item)
    case routeToCountryDetail(Airbnb.Search.Country.Item)

    case routeToTabBarItem(String)

    
    case throwError(CompositeErrorRepository)
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.query):
        guard !state.query.isEmpty else {
          state.searchCityItemList = []

          return .none
        }

        return .none

      case .binding(\.country):
        guard !state.country.isEmpty else {
          state.searchCountryItemList = []
          return .none
        }

        return .none

      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .searchCity(let query):
        state.fetchSearchCityItem.isLoading = true
        state.searchCountryItemList = []
        return sideEffect
          .searchCityItem(.init(query: query))
          .cancellable(pageID: pageID, id: CancelID.requestSearchCity, cancelInFlight: true)

      case .searchCountry(let query):
        state.fetchSearchCountryItem.isLoading = true
        state.searchCityItemList = []
        return sideEffect
          .searchCountryItem(.init(query: query))
          .cancellable(pageID: pageID, id: CancelID.requestSearchCountry, cancelInFlight: true)

      case .fetchSearchCityItem(let result):
        state.fetchSearchCityItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchSearchCityItem.value = item
          state.searchCityItemList = state.searchCityItemList + item.response.itemList
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchSearchCountryItem(let result):
        state.fetchSearchCountryItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchSearchCountryItem.value = item
          state.searchCountryItemList = state.searchCountryItemList + item.response.itemList
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToCityDetail(let item):
        sideEffect.routeToCityDetail(item)
        return .none

      case .routeToCountryDetail(let item):
        sideEffect.routeToCountryDetail(item)
        return .none
        
      case .routeToTabBarItem(let matchPath):
        sideEffect.routeToTabBarItem(matchPath)
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: HomeSideEffect
}
