import Architecture
import ComposableArchitecture
import Domain
import Foundation

@Reducer
struct SignUpReducer {

  // MARK: Lifecycle

  init(
    pageID: String = UUID().uuidString,
    sideEffect: SignUpSideEffect)
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
    var confirmPasswordText = ""

    var fetchSignUp: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var isValidEmail = true
    var isValidPassword = true
    var isValidConfirmPassword = true

    init(id: UUID = UUID()) {
      self.id = id
    }
  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSignUp
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case onTapSignUp
    case fetchSignUp(Result<Bool, CompositeErrorRepository>)

    case routeToSignIn

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

      case .onTapSignUp:
        return sideEffect
          .signUp(.init(email: state.emailText, password: state.passwordText))
          .cancellable(pageID: pageID, id: CancelID.requestSignUp, cancelInFlight: true)

      case .fetchSignUp(let result):
        switch result {
        case .success:
          sideEffect.routeToSignIn()
          return .none

        case .failure(let error):
          return .run { await $0(.throwError(error)) }
        }

      case .routeToSignIn:
        sideEffect.routeToSignIn()
        return .none

      case .throwError(let error):
        sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
        return .none
      }
    }
  }

  // MARK: Private

  private let pageID: String
  private let sideEffect: SignUpSideEffect
}
