import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - SignInSideEffect

struct SignInSideEffect {
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

extension SignInSideEffect {
  var routeToSignUp: () -> Void {
    {
      navigator.next(
        linkItem: .init(path: Link.Dashboard.Path.signUp.rawValue),
        isAnimated: true)
    }
  }
}
