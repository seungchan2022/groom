import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - LoginStatus

public enum LoginStatus: Equatable {
  case isLoggedIn
  case isLoggedOut
}

// MARK: - ProfileReducer

@Reducer
struct ProfileReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: ProfileSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var status: LoginStatus = .isLoggedOut

    var item: Auth.Me.Response = .init(uid: "", email: "", photoURL: "")

    var fetchSignOut: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchUser: FetchState.Data<Bool> = .init(isLoading: false, value: false)
    var fetchUserInfo: FetchState.Data<Auth.Me.Response?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSignOut
    case requestUser
    case requestUserInfo
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getUser
    case getUserInfo

    case onTapSignOut

    case fetchSignOut(Result<Bool, CompositeErrorRepository>)

    case fetchUser(Result<Bool, CompositeErrorRepository>)
    case fetchUserInfo(Result<Auth.Me.Response?, CompositeErrorRepository>)

    case routeToSignIn
    case routeToSignUp

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

      case .getUser:
        return sideEffect
          .user()
          .cancellable(pageID: pageID, id: CancelID.requestUser, cancelInFlight: true)

      case .getUserInfo:
        return sideEffect
          .userInfo()
          .cancellable(pageID: pageID, id: CancelID.requestUserInfo, cancelInFlight: true)

      case .onTapSignOut:
        state.item = .init(uid: "", email: "", photoURL: "")
        state.status = .isLoggedOut
        return sideEffect
          .signOut()
          .cancellable(pageID: pageID, id: CancelID.requestSignOut, cancelInFlight: true)

      case .fetchSignOut(let result):
        switch result {
        case .success:
          state.item = .init(uid: "", email: "", photoURL: "")
          state.status = .isLoggedOut
          sideEffect.routeToSignIn()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchUser(let result):
        switch result {
        case .success(let isLoggedIn):
          switch isLoggedIn {
          case true: state.status = .isLoggedIn
          case false: state.status = .isLoggedOut
          }
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchUserInfo(let result):
        switch result {
        case .success(let item):
          state.item = item ?? .init(uid: "2", email: "555", photoURL: "")
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToSignIn:
        sideEffect.routeToSignIn()
        return .none

      case .routeToSignUp:
        sideEffect.routeToSignUp()
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: ProfileSideEffect
}
