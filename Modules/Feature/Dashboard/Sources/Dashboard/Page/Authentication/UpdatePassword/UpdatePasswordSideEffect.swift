import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - UpdatePasswordSideEffect

struct UpdatePasswordSideEffect {
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

extension UpdatePasswordSideEffect {
  var updatePassword: (String) -> Effect<UpdatePasswordReducer.Action> {
    { newPassword in
        .publisher {
          useCase.authUseCase.updatePassword(newPassword)
            .map { _ in true }
            .receive(on: main)
            .mapToResult()
            .map(UpdatePasswordReducer.Action.fetchUpdatePassword)
        }
    }
  }
  
  var close: () -> Void {
    {
      navigator.close(
        isAnimated: true,
        completeAction: { })
    }
  }
}

