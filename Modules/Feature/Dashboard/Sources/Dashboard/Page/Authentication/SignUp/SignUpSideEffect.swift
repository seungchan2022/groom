import Architecture
import ComposableArchitecture
import CombineExt
import Domain
import Foundation

// MARK: - SignUpSideEffect

struct SignUpSideEffect {
  let useCase: DashboardEnvironmentUsable
  let main: AnySchedulerOf<DispatchQueue>
  let navigator: RootNavigatorType

  init(
    useCase: DashboardEnvironmentUsable,
    main: AnySchedulerOf<DispatchQueue> = .main,
    navigator: RootNavigatorType)
  {
    self.useCase = useCase
    self.main = main
    self.navigator = navigator
  }
}

extension SignUpSideEffect {
  var signUp: (Auth.Email.Request) -> Effect<SignUpReducer.Action> {
    { req in
        .publisher {
          useCase.authUseCase.signUp(req)
            .map { _ in true }
            .receive(on: main)
            .mapToResult()
            .map(SignUpReducer.Action.fetchSignUp)
        }
    }
  }
  
  var routeToSignIn: () -> Void {
    {
      navigator
        .back(isAnimated: true)
    }
  }
}
