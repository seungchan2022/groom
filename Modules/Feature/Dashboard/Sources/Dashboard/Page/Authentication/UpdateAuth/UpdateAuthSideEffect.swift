import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - UpdateAuthSideEffect

struct UpdateAuthSideEffect {
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

extension UpdateAuthSideEffect {
  var userInfo: () -> Effect<UpdateAuthReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.me()
          .receive(on: main)
          .mapToResult()
          .map(UpdateAuthReducer.Action.fetchUserInfo)
      }
    }
  }

  var signOut: () -> Effect<UpdateAuthReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.signOut()
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateAuthReducer.Action.fetchSignOut)
      }
    }
  }

  var updateUserName: (String) -> Effect<UpdateAuthReducer.Action> {
    { name in
      .publisher {
        useCase.authUseCase.updateUserName(name)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateAuthReducer.Action.fetchUpdateUserName)
      }
    }
  }

  var deleteUser: () -> Effect<UpdateAuthReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.deleteUser()
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateAuthReducer.Action.fetchDeleteUser)
      }
    }
  }

  var deleteUserInfo: () -> Effect<UpdateAuthReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.deleteUserInfo()
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateAuthReducer.Action.fetchDeleteUserInfo)
      }
    }
  }

  var deleteProfileImage: () -> Effect<UpdateAuthReducer.Action> {
    {
      .publisher {
        useCase.authUseCase.deleteProfileImage()
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(UpdateAuthReducer.Action.fetchDeleteProfileImage)
      }
    }
  }

  var routeToSignIn: () -> Void {
    {
      navigator.sheet(
        linkItem: .init(path: Link.Dashboard.Path.signIn.rawValue),
        isAnimated: true)
    }
  }

  var routeToUpdatePassword: () -> Void {
    {
      navigator.next(
        linkItem: .init(path: Link.Dashboard.Path.updatePassword.rawValue),
        isAnimated: true)
    }
  }

  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}
