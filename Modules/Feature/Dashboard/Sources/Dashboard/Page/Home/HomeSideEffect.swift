import Architecture
import CombineExt
import ComposableArchitecture
import Domain
import Foundation

// MARK: - HomeSideEffect

struct HomeSideEffect {
  let useCase: DashboardEnvironmentUsable
  let main: AnySchedulerOf<DispatchQueue>
  let navigator: RootNavigatorType

  public init(
    useCase: DashboardEnvironmentUsable,
    main: AnySchedulerOf<DispatchQueue> = .main,
    navigator: RootNavigatorType)
  {
    self.useCase = useCase
    self.main = main
    self.navigator = navigator
  }
}

extension HomeSideEffect {
  var searchCityItem: (Airbnb.Search.City.Request) -> Effect<HomeReducer.Action> {
    { request in
      .publisher {
        useCase.searchUseCase.searchCity(request)
          .receive(on: main)
          .map {
            Airbnb.Search.City.Compsite(
              request: request,
              response: $0)
          }
          .mapToResult()
          .map(HomeReducer.Action.fetchSearchCityItme)
      }
    }
  }
}
