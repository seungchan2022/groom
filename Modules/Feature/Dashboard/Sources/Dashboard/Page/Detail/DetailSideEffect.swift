import Architecture
import ComposableArchitecture
import Domain
import Foundation

// MARK: - DetailSideEffect

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
  var getItem: (Airbnb.Listing.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.airbnbDetailUseCase.detail(item.serialized())
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchItem)
      }
    }
  }

  var getSearchCityItem: (Airbnb.Search.City.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.airbnbDetailUseCase.searchCityDetail(item.serialized())
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchSearchCityItem)
      }
    }
  }

  var getSearchCountryItem: (Airbnb.Search.Country.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.airbnbDetailUseCase.searchCountryDetail(item.serialized())
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchSearchCountryItem)
      }
    }
  }

  var getIsLike: (String) -> Effect<DetailReducer.Action> {
    { itemId in
      .publisher {
        useCase.likeUseCase.getIsLike(itemId)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchIsLike)
      }
    }
  }

  var likeDetail: (Airbnb.Detail.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.likeUseCase.likeDetail(item)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchLikeDetail)
      }
    }
  }

  var unLikeDetail: (Airbnb.Detail.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.likeUseCase.unLikeDetail(item)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchUnLikeDetail)
      }
    }
  }

  var likeCityDetail: (Airbnb.SearchCityDetail.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.likeUseCase.likeCityDetail(item)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchLikeCityDetail)
      }
    }
  }

  var unLikeCityDetail: (Airbnb.SearchCityDetail.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.likeUseCase.unLikeCityDetail(item)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchUnLikeCityDetail)
      }
    }
  }

  var likeCountryDetail: (Airbnb.SearchCountryDetail.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.likeUseCase.likeCountryDetail(item)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchLikeCountryDetail)
      }
    }
  }

  var unLikeCountryDetail: (Airbnb.SearchCountryDetail.Item) -> Effect<DetailReducer.Action> {
    { item in
      .publisher {
        useCase.likeUseCase.unLikeCountryDetail(item)
          .map { _ in true }
          .receive(on: main)
          .mapToResult()
          .map(DetailReducer.Action.fetchUnLikeCountryDetail)
      }
    }
  }

  var routeToBack: () -> Void {
    {
      navigator.back(isAnimated: true)
    }
  }
}

extension Airbnb.Listing.Item {
  fileprivate func serialized() -> Airbnb.Detail.Request {
    .init()
  }
}

extension Airbnb.Search.City.Item {
  fileprivate func serialized() -> Airbnb.SearchCityDetail.Request {
    .init(query: city)
  }
}

extension Airbnb.Search.Country.Item {
  fileprivate func serialized() -> Airbnb.SearchCountryDetail.Request {
    .init(query: country)
  }
}
