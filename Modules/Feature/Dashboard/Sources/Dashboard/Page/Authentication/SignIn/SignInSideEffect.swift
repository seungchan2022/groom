import Architecture
import CombineExt
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
  var signIn: (Auth.Email.Request) -> Effect<SignInReducer.Action> {
    { req in
      .publisher {
        useCase.authUseCase.signIn(req)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(SignInReducer.Action.fetchSignIn)
      }
    }
  }

  var resetPassword: (String) -> Effect<SignInReducer.Action> {
    { email in
      .publisher {
        useCase.authUseCase.resetPassword(email)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(SignInReducer.Action.fetchResetPassword)
      }
    }
  }

  var googleSignIn: () -> Effect<SignInReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.googleSignIn()
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(SignInReducer.Action.fetchGoogleSignIn)
      }
    }
  }

  var routeToClose: (Bool?) -> Void {
    { isLogIn in
      navigator.close(
        isAnimated: true,
        completeAction: {
          guard let isLogIn else { return }

          navigator.send(
            item: .init(
              path: Link.Dashboard.Path.wishList.rawValue,
              items: WishListRouteItem(isLogIn: isLogIn)))

          navigator.send(
            item: .init(
              path: Link.Dashboard.Path.profile.rawValue,
              items: ProfileRouteItem(isLogIn: isLogIn)))
        })
    }
  }

  var routeToSignUp: () -> Void {
    {
      navigator.next(
        linkItem: .init(path: Link.Dashboard.Path.signUp.rawValue),
        isAnimated: true)
    }
  }
}
