import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct SignInReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: SignInSideEffect)
  {
    self.pageID = pageID
    self.sideEffect = sideEffect
  }

  // MARK: Internal

  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID

    var emailText = ""
    var passwordText = ""

    var isValidEmail = true
    var isValidPassword = true

    var fetchSignIn: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSignIn
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case onTapSignIn

    case fetchSignIn(Result<Bool, CompositeErrorRepository>)

    case routeToBack
    case routeToSignUp
    case routeToRestPassword

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

      case .onTapSignIn:
        return sideEffect
          .signIn(.init(email: state.emailText, password: state.passwordText))
          .cancellable(pageID: pageID, id: CancelID.requestSignIn, cancelInFlight: true)

      case .fetchSignIn(let result):
        switch result {
        case .success:
          sideEffect.routeToBack()
          return .none

        case .failure:
          sideEffect.useCase.toastViewModel.send(message: "이메일 혹은 비밀번호가 잘못되었습니다.")
          return .none
        }

      case .routeToBack:
        sideEffect.routeToBack()
        return .none

      case .routeToSignUp:
        sideEffect.routeToSignUp()
        return .none

      case .routeToRestPassword:
        sideEffect.routeToRestPassword()
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: SignInSideEffect
}
