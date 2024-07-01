import ComposableArchitecture
import DesignSystem
import MapKit
import SwiftUI

// MARK: - DetailPage

struct DetailPage {
  @Bindable var store: StoreOf<DetailReducer>

  @State private var position: MapCameraPosition = .automatic
  @State private var isShowMap = false

}

extension DetailPage {
  private var isLoading: Bool {
    store.fetchItem.isLoading
      || store.fetchSearchCityItem.isLoading
      || store.fetchSearchCountryItem.isLoading
      || store.fetchIsLike.isLoading
  }

  /// Set<DateComponents>를 정렬된 Array로 변환
  private var sortedDateList: [Date] {
    Array(store.selectedDateList).compactMap {
      Calendar.current.date(from: $0)
    }.sorted()
  }

  /// 언제 ~ 언제까지를 나타낼 String
  private var dateIntervalString: String {
    let datesArr = sortedDateList // 정렬된 Array를 가지고 사용

    if datesArr.count >= 2 {
      return "\(datesArr.first?.formatted(date: .abbreviated, time: .omitted) ?? "") ~ \(datesArr.last?.formatted(date: .abbreviated, time: .omitted) ?? "")"
    }

    return "날짜를 선택해주세요"
  }

  private var filledDateListInterval: Set<DateComponents> {
    let sortedDates = sortedDateList // 정렬된 Array를 가지고 사용

    // 시작 날짜와 마지막 날짜 가져오기
    guard let startDate = sortedDates.first, let endDate = sortedDates.last else {
      return store.selectedDateList
    }

    var allDates: Set<DateComponents> = [] // 두 날짜 사이를 포함할 집합
    var currentDate = startDate

    //    while 루프를 사용하여 currentDate가 endDate보다 작거나 같을 때까지 반복합니다. 각 반복에서 currentDate를 DateComponents로 변환하고 이를 allDates 집합에 추가합니다. 그런 다음 currentDate에 하루를 더합니다. 이 과정을 통해 startDate와 endDate 사이의 모든 날짜를 allDates에 추가합니다.
    while currentDate <= endDate {
      let components = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
      allDates.insert(components)
      currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
    }

    return allDates
  }

}

// MARK: View

extension DetailPage: View {
  var body: some View {
    VStack {
      ScrollView {
        if let searchCityItem = store.fetchSearchCityItem.value?.itemList.first(where: { $0.id == store.searchCityItem.id }) {
          SearchCityResultComponent(
            viewState: .init(
              item: searchCityItem,
              isLike: store.state.isLike),
            backAction: { store.send(.routeToBack) },
            tapAction: { isShowMap = true },
            likeAction: {
              if !store.state.isLike {
                store.send(.onTapLikeCityDetail($0))
              } else {
                store.send(.onTapUnLikeCityDetail($0))
              }
            },
            position: $position)
        } else if let item = store.fetchItem.value?.itemList.first(where: { $0.id == store.item.id }) {
          ItemComponent(
            viewState: .init(
              item: item,
              isLike: store.state.isLike),
            backAction: { store.send(.routeToBack) },
            tapAction: { isShowMap = true },
            likeAction: {
              if !store.state.isLike {
                store.send(.onTapLikeDetail($0))
              } else {
                store.send(.onTapUnLikeDetail($0))
              }

            },
            position: $position)
        } else if
          let searchCountryItem = store.fetchSearchCountryItem.value?.itemList
            .first(where: { $0.id == store.searchCountryItem.id })
        {
          SearchCountryResultComponent(
            viewState: .init(
              item: searchCountryItem,
              isLike: store.state.isLike),
            backAction: { store.send(.routeToBack) },
            tapAction: { isShowMap = true },
            likeAction: {
              if !store.state.isLike {
                store.send(.onTapLikeCountryDetail($0))
              } else {
                store.send(.onTapUnLikeCountryDetail($0))
              }
            },
            position: $position)
        }
      }
      // 하단 커스텀 예약 바

      if let item = store.fetchItem.value?.itemList.first(where: { $0.id == store.item.id }) {
        ReservationItemComponent(
          viewState: .init(item: item),
          tapAction: { store.send(.onTapReservationDetail(item, sortedDateList)) },
          store: store)
          .sheet(isPresented: $store.isShowCalendar) {
            VStack {
              Button(action: {
                store.selectedDateList = []
                store.selectedDate = "날짜를 선택해주세요"

              }) {
                Text("날짜 지우기")
              }

              MultiDatePicker("Dates", selection: $store.selectedDateList, in: Date()...)
            }
          }

          .onChange(of: store.selectedDateList) { _, new in
            if new.count == 2 {
              store.selectedDateList = filledDateListInterval
              store.selectedDate = dateIntervalString
              if filledDateListInterval.count == store.selectedDateList.count {
                store.isShowCalendar = false
              }
            }
          }
      }

      else if let searchCityItem = store.fetchSearchCityItem.value?.itemList.first(where: { $0.id == store.item.id }) {
        ReservationCityItemComponent(
          viewState: .init(item: searchCityItem),
          tapAction: { store.send(.onTapReservationCityDetail(searchCityItem, sortedDateList)) },
          store: store)
          .sheet(isPresented: $store.isShowCalendar) {
            VStack {
              Button(action: {
                store.selectedDateList = []
                store.selectedDate = "날짜를 선택해주세요"

              }) {
                Text("날짜 지우기")
              }

              MultiDatePicker("Dates", selection: $store.selectedDateList, in: Date()...)
            }
          }

          .onChange(of: store.selectedDateList) { _, new in
            if new.count == 2 {
              store.selectedDateList = filledDateListInterval
              store.selectedDate = dateIntervalString
              if filledDateListInterval.count == store.selectedDateList.count {
                store.isShowCalendar = false
              }
            }
          }
      } else if
        let searchCountryItem = store.fetchSearchCountryItem.value?.itemList
          .first(where: { $0.id == store.searchCountryItem.id })
      {
        ReservationCountryItemComponent(
          viewState: .init(item: searchCountryItem),
          tapAction: { store.send(.onTapReservationCountryDetail(searchCountryItem, sortedDateList)) },
          store: store)
          .sheet(isPresented: $store.isShowCalendar) {
            VStack {
              Button(action: {
                store.selectedDateList = []
                store.selectedDate = "날짜를 선택해주세요"

              }) {
                Text("날짜 지우기")
              }

              MultiDatePicker("Dates", selection: $store.selectedDateList, in: Date()...)
            }
          }

          .onChange(of: store.selectedDateList) { _, new in
            if new.count == 2 {
              store.selectedDateList = filledDateListInterval
              store.selectedDate = dateIntervalString
              if filledDateListInterval.count == store.selectedDateList.count {
                store.isShowCalendar = false
              }
            }
          }
      }
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .ignoresSafeArea(.all, edges: .top)
    .toolbar(.hidden, for: .navigationBar)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getItem(store.item))
      store.send(.getSearchCityItem(store.searchCityItem))
      store.send(.getSearchCountryItem(store.searchCountryItem))
      store.send(.getIsLike)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
