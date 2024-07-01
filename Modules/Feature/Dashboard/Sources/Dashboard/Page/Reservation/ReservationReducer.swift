import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct ReservationReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: ReservationSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var reservationItemList: [Airbnb.Reservation.Item] = []

    var fetchReservationItemList: FetchState.Data<[Airbnb.Reservation.Item]?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestReservationItemList
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case routeToBack

    case getReservationItemList
    case fetchReservationItemList(Result<[Airbnb.Reservation.Item], CompositeErrorRepository>)

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

      case .getReservationItemList:
        state.fetchReservationItemList.isLoading = true
        return sideEffect
          .getReservationItemList()
          .cancellable(pageID: pageID, id: CancelID.requestReservationItemList, cancelInFlight: true)

      case .fetchReservationItemList(let result):
        state.fetchReservationItemList.isLoading = false
        switch result {
        case .success(let itemList):
          state.reservationItemList = itemList
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
  private let sideEffect: ReservationSideEffect
}
