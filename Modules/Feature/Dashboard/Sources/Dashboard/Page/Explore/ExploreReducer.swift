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

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case routeToDetail

    case throwError(CompositeErrorRepository)
  }

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { _, action in
      switch action {
      case .binding:
        return .none

      case .teardown:
        return .concatenate(
          CancelID.allCases.map { .cancel(pageID: pageID, id: $0) })

      case .routeToDetail:
        sideEffect.routeToDetail()
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
