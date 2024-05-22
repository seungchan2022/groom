import Architecture
import ComposableArchitecture
import Foundation

// MARK: - ExploreSideEffect

struct ExploreSideEffect {
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

extension ExploreSideEffect { 
  var routeToDetail: () -> Void {
    {
      navigator.next(
        linkItem: .init(path: Link.Dashboard.Path.detail.rawValue),
        isAnimated: true)
    }
  }
}
