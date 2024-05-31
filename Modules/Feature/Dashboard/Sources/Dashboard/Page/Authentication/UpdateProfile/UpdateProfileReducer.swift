import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct UpdateProfileReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: UpdateProfileSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var isShowDeleteUser = false

    var item: Auth.Me.Response = .init(uid: "", email: "", userName: "", photoURL: "")

    var fetchDeleteUser: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchUserInfo: FetchState.Data<Auth.Me.Response?> = .init(isLoading: false, value: .none)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: String, CaseIterable {
    case teardown
    case requestUser
    case requestUserInfo
    case requstDeleteUser
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case getUserInfo

    case onTapClose

    case onTapDeleteUser

    case routeToSignIn
    case routeToUpdatePassword

    case fetchUserInfo(Result<Auth.Me.Response?, CompositeErrorRepository>)

    case fetchDeleteUser(Result<Bool, CompositeErrorRepository>)

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

      case .onTapClose:
        sideEffect.close()
        return .none

      case .onTapDeleteUser:
        return sideEffect
          .deleteUser()
          .cancellable(pageID: pageID, id: CancelID.requstDeleteUser, cancelInFlight: true)

      case .routeToSignIn:
        sideEffect.routeToSignIn()
        return .none

      case .routeToUpdatePassword:
        sideEffect.routeToUpdatePassword()
        return .none

      case .fetchUserInfo(let result):
        switch result {
        case .success(let item):
          state.item = item ?? .init(uid: "", email: "", userName: "", photoURL: "")
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .fetchDeleteUser(let result):
        switch result {
        case .success:
          sideEffect.useCase.toastViewModel.send(message: "계정이 탈퇴되었습니다.")
          sideEffect.close()
          sideEffect.routeToSignIn()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: UpdateProfileSideEffect
}
