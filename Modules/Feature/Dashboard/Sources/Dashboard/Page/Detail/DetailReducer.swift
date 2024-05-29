import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct DetailReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: DetailSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    let item: Airbnb.Listing.Item

    var fetchItem: FetchState.Data<Airbnb.Detail.Response?> = .init(isLoading: false, value: .none)

    init(
      id: UUID = UUID(),
      item: Airbnb.Listing.Item)
    {
      self.id = id
      self.item = item
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestItem
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getItem(Airbnb.Listing.Item)
    case fetchItem(Result<Airbnb.Detail.Response, CompositeErrorRepository>)

    case routeToBack

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

      case .getItem(let item):
        state.fetchItem.isLoading = true
        return sideEffect
          .getItem(item)
          .cancellable(pageID: pageID, id: CancelID.requestItem, cancelInFlight: true)

      case .fetchItem(let result):
        state.fetchItem.isLoading = false
        switch result {
        case .success(let item):
          state.fetchItem.value = item
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: DetailSideEffect
}
