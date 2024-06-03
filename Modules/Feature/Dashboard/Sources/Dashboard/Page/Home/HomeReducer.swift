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

    var searchCityItemList: [Airbnb.Search.City.Item] = []

    var fetchSearchCityItem: FetchState.Data<Airbnb.Search.City.Compsite?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSearchCity
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case searchCity(String)

    case fetchSearchCityItem(Result<Airbnb.Search.City.Compsite, CompositeErrorRepository>)

    case routeToSearchDetail(Airbnb.Search.City.Item)

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

        if state.query != state.fetchSearchCityItem.value?.request.query {
          state.searchCityItemList = []
        }

        return .none

      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .searchCity(let query):
        state.fetchSearchCityItem.isLoading = true
        return sideEffect
          .searchCityItem(.init(query: query))
          .cancellable(pageID: pageID, id: CancelID.requestSearchCity, cancelInFlight: true)

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

      case .routeToSearchDetail(let item):
        sideEffect.routeToSearchDetail(item)
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
