import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - DestinationSearchOption

public enum DestinationSearchOption {
  case location
  case date
  case guest
}

// MARK: - ExploreReducer

@Reducer
struct ExploreReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: ExploreSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var isShowSearchDestination = false

    var destinationText = ""
    var peopleCount: Int = .zero
    var fromDate = Date()
    var toDate = Date()

    var isSelectedOption: DestinationSearchOption = .location

    var itemList: [Airbnb.Listing.Item] = []

    var fetchItem: FetchState.Data<Airbnb.Listing.Response?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestItem
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getItem
    case fetchItem(Result<Airbnb.Listing.Response, CompositeErrorRepository>)

    case routeToDetail(Airbnb.Listing.Item)

    case throwError(CompositeErrorRepository)
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .getItem:
        state.fetchItem.isLoading = true
        return sideEffect
          .getItem(.init())
          .cancellable(pageID: pageID, id: CancelID.requestItem, cancelInFlight: true)

      case .fetchItem(let result):
        state.fetchItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchItem.value = item
          state.itemList = state.itemList + item.itemList
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToDetail(let item):
        sideEffect.routeToDetail(item)
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: ExploreSideEffect
}
