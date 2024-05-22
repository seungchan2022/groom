import Architecture
import ComposableArchitecture
import Foundation


struct DetailSideEffect {
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

extension DetailSideEffect {
  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}
