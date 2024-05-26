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

    // MARK: Lifecycle

    init(id: UUID = UUID()) {
      self.id = id
    }

    // MARK: Internal

    let id: UUID

    var emailText = ""
    var passwordText = ""

    var checkToEmail = ""

    var isValidEmail = true
    var isValidPassword = true

    var isPresentedReset = false

    var fetchSignIn: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchResetPassword: FetchState.Data<Auth.Me.Response?> = .init(isLoading: false, value: .none)

  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSignIn
    case requestResetPassword

  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case onTapSignIn
    case onTapResetPassword

    case fetchSignIn(Result<Bool, CompositeErrorRepository>)
    case fetchResetPassword(Result<Auth.Me.Response?, CompositeErrorRepository>)

    case routeToBack
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

      case .onTapSignIn:
        return sideEffect
          .signIn(.init(email: state.emailText, password: state.passwordText))
          .cancellable(pageID: pageID, id: CancelID.requestSignIn, cancelInFlight: true)

      case .onTapResetPassword:
        return sideEffect
          .resetPassword(state.checkToEmail)
          .cancellable(pageID: pageID, id: CancelID.requestResetPassword, cancelInFlight: true)

      case .fetchSignIn(let result):
        switch result {
        case .success:
          sideEffect.routeToBack()
          return .none

        case .failure:
          sideEffect.useCase.toastViewModel.send(message: "이메일 혹은 비밀번호가 잘못되었습니다.")
          return .none
        }

      case .fetchResetPassword(let result):
        switch result {
        case .success:
          sideEffect.useCase.toastViewModel.send(message: "비밀번호 재설정 링크가 입력하신 이메일로 전송되었습니다.")
          return .none

        case .failure:
          sideEffect.useCase.toastViewModel.send(message: "요청하신 계정은 존재하지 않습니다. 다시 한번 확인해주세요.")
          return .none
        }

      case .routeToBack:
        sideEffect.routeToBack()
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
  private let sideEffect: SignInSideEffect
}
