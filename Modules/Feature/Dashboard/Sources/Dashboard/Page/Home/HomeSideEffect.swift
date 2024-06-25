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
          .map(HomeReducer.Action.fetchSearchCityItem)
      }
    }
  }

  var searchCountryItem: (Airbnb.Search.Country.Request) -> Effect<HomeReducer.Action> {
    { request in
      .publisher {
        useCase.searchUseCase.searchCountry(request)
          .receive(on: main)
          .map {
            Airbnb.Search.Country.Compsite(
              request: request,
              response: $0)
          }
          .mapToResult()
          .map(HomeReducer.Action.fetchSearchCountryItem)
      }
    }
  }

  var routeToCityDetail: (Airbnb.Search.City.Item) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Dashboard.Path.detail.rawValue,
          items: item),
        isAnimated: true)
    }
  }

  var routeToCountryDetail: (Airbnb.Search.Country.Item) -> Void {
    { item in
      navigator.next(
        linkItem: .init(
          path: Link.Dashboard.Path.detail.rawValue,
          items: item),
        isAnimated: true)
    }
  }
  
  var routeToTabBarItem: (String) -> Void {
    { path in
      guard path != Link.Dashboard.Path.home.rawValue else { return }
      navigator.replace(linkItem: .init(path: path), isAnimated: false)
    }
  }
}
