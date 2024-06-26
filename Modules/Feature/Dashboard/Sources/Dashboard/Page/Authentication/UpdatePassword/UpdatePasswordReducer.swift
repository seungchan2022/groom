import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct UpdatePasswordReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: UpdatePasswordSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var passwordText = ""
    var confirmPasswordText = ""

    var isValidPassword = true
    var isValidConfirmPassword = true
    var isShowPassword = false
    var isShowConfirmPassword = false

    var fetchUpdatePassword: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestUpdatePassword
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case onTapUpdatePassword

    case routeToBack

    case fetchUpdatePassword(Result<Bool, CompositeErrorRepository>)

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

      case .onTapUpdatePassword:
        state.fetchUpdatePassword.isLoading = true
        return sideEffect
          .updatePassword(state.passwordText)
          .cancellable(pageID: pageID, id: CancelID.requestUpdatePassword, cancelInFlight: true)

      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .fetchUpdatePassword(let result):
        state.fetchUpdatePassword.isLoading = false
        switch result {
        case .success:
          sideEffect.routeToBack()
          sideEffect.useCase.toastViewModel.send(message: "비밀번호가 변경되었습니다.")
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
  private let sideEffect: UpdatePasswordSideEffect
}
