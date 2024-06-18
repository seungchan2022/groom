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

    var isShowReset = false

    var isShowPassword = false

    var fetchSignIn: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchResetPassword: FetchState.Data<Bool> = .init(isLoading: false, value: false)

    var fetchGoogleSignIn: FetchState.Data<Bool> = .init(isLoading: false, value: false)

  }

  enum CancelID: Equatable, CaseIterable {
    case teardown
    case requestSignIn
    case requestResetPassword
    case requestGoogleSignIn
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case teardown

    case onTapSignIn
    case onTapResetPassword
    case onTapGoogleSignIn

    case fetchSignIn(Result<Bool, CompositeErrorRepository>)
    case fetchResetPassword(Result<Bool, CompositeErrorRepository>)
    case fetchGoogleSignIn(Result<Bool, CompositeErrorRepository>)

    case routeToClose
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
        state.fetchSignIn.isLoading = true
        return sideEffect
          .signIn(.init(email: state.emailText, password: state.passwordText))
          .cancellable(pageID: pageID, id: CancelID.requestSignIn, cancelInFlight: true)

      case .onTapResetPassword:
        state.fetchResetPassword.isLoading = true
        return sideEffect
          .resetPassword(state.checkToEmail)
          .cancellable(pageID: pageID, id: CancelID.requestResetPassword, cancelInFlight: true)

      case .onTapGoogleSignIn:
        state.fetchGoogleSignIn.isLoading = true
        return sideEffect
          .googleSignIn()
          .cancellable(pageID: pageID, id: CancelID.requestGoogleSignIn, cancelInFlight: true)

      case .fetchSignIn(let result):
        state.fetchSignIn.isLoading = false
        switch result {
        case .success:
          sideEffect.routeToClose(true)
          return .none

        case .failure:
          sideEffect.useCase.toastViewModel.send(message: "이메일 혹은 비밀번호가 잘못되었습니다.")
          return .none
        }

      case .fetchResetPassword(let result):
        state.fetchResetPassword.isLoading = false
        switch result {
        case .success:
          sideEffect.useCase.toastViewModel.send(message: "비밀번호 재설정 링크가 입력하신 이메일로 전송되었습니다.")
          return .none

        case .failure:
          sideEffect.useCase.toastViewModel.send(message: "요청하신 계정은 존재하지 않습니다. 다시 한번 확인해주세요.")
          return .none
        }

      case .fetchGoogleSignIn(let result):
        state.fetchGoogleSignIn.isLoading = false
        switch result {
        case .success:
          sideEffect.useCase.toastViewModel.send(message: "구글 로그인 성공")
          sideEffect.routeToClose(true)
          return .none

        case .failure(let error):
          sideEffect.useCase.toastViewModel.send(errorMessage: error.displayMessage)
          return .run { await $0(.throwError(error)) }
        }

      case .routeToClose:
        sideEffect.routeToClose(.none)
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
