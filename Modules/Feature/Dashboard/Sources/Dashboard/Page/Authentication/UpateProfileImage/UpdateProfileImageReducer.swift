import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct UpdateProfileImageReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: UpdateProfileImageSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var item: Auth.Me.Response = .init(uid: "", email: "", userName: "", photoURL: "")

    var fetchUserInfo: FetchState.Data<Auth.Me.Response?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestUserInfo
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getUserInfo

    case fetchUserInfo(Result<Auth.Me.Response?, CompositeErrorRepository>)

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

      case .getUserInfo:
        return sideEffect
          .userInfo()
          .cancellable(pageID: pageID, id: CancelID.requestUserInfo, cancelInFlight: true)

      case .fetchUserInfo(let result):
        switch result {
        case .success(let item):
          state.item = item ?? .init(uid: "", email: "", userName: "", photoURL: "")
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .throwError(let error):
        return .run { await $0(.throwError(error)) }
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: UpdateProfileImageSideEffect
}
