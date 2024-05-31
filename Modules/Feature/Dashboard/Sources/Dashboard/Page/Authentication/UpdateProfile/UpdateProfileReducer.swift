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

    var fetchDeleteUser: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: String, CaseIterable {
    case teardown
    case requstDeleteUser
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case onTapClose

    case onTapDeleteUser

    case routeToSignIn
    case routeToUpdatePassword

    case fetchDeleteUser(Result<Bool, CompositeErrorRepository>)

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
