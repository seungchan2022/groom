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
  
}

// MARK: View

extension DetailPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(title: "") {
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
      VStack(spacing: .zero) {

        Divider()
        
        HStack {
          VStack(alignment: .leading) {
            Text("$")
              .fontWeight(.semibold)
          }
          
          Spacer()
          
          Button(action: { }) {
            Text("예약하기")
              .foregroundStyle(.white)
              .font(.subheadline)
              .fontWeight(.semibold)
              .frame(width: 140, height: 40)
              .background(.pink)
              .clipShape(RoundedRectangle(cornerRadius: 8))
          }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16) // 추가 패딩으로 버튼 크기 조정
        .padding(.bottom, WindowAppearance.safeArea.bottom)
        .background {
          Rectangle()
            .fill(DesignSystemColor.label(.default).color)
            .fill(.white)
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


//  .fullScreenCover(isPresented: $isShowMap) {
//    if let searchCityItem = store.fetchSearchCityItem.value?.itemList.first(where: { $0.id == store.searchCityItem.id }) {
//      Map(position: $position) {
//        Marker(
//          "Destination",
//          coordinate: CLLocationCoordinate2D(
//            latitude: searchCityItem.coordinateList.latitude,
//            longitude: searchCityItem.coordinateList.longitude))
//      }
//      .mapStyle(.standard)
//      .overlay(alignment: .topLeading) {
//        Button(action: { isShowMap = false }) {
//          Image(systemName: "xmark")
//            .imageScale(.large)
//        }
//        .padding(.leading, 16)
//      }
//      .overlay(alignment: .topTrailing) {
//        Button(action: { position = .automatic }) {
//          Image(systemName: "dot.scope")
//            .imageScale(.large)
//            .foregroundStyle(.black)
//            .background {
//              RoundedRectangle(cornerRadius: 5)
//                .fill(.white)
//                .frame(width: 45, height: 45)
//            }
//        }
//        .padding([.bottom, .trailing], 16)
//      }
//    }
//
//    else if let item = store.fetchItem.value?.itemList.first(where: { $0.id == store.item.id }) {
//      Map(position: $position) {
//        Marker(
//          "Destination",
//          coordinate: CLLocationCoordinate2D(
//            latitude: item.coordinateList.latitude,
//            longitude: item.coordinateList.longitude))
//      }
//      .mapStyle(.standard)
//      .overlay(alignment: .bottomTrailing) {
//        Button(action: { position = .automatic }) {
//          Image(systemName: "dot.scope")
//            .foregroundStyle(.black)
//            .background {
//              RoundedRectangle(cornerRadius: 5)
//                .fill(.white)
//                .frame(width: 40, height: 40)
//            }
//        }
//        .padding([.bottom, .trailing], 16)
//      }
//      .overlay(alignment: .topLeading) {
//        Button(action: { isShowMap = false }) {
//          Image(systemName: "xmark")
//            .imageScale(.large)
//        }
//        .padding(.leading, 16)
//      }
//    } else if
//      let searchCountryItem = store.fetchSearchCountryItem.value?.itemList
//        .first(where: { $0.id == store.searchCountryItem.id })
//    {
//      Map(position: $position) {
//        Marker(
//          "Destination",
//          coordinate: CLLocationCoordinate2D(
//            latitude: searchCountryItem.coordinateList.latitude,
//            longitude: searchCountryItem.coordinateList.longitude))
//      }
//      .mapStyle(.standard)
//      .overlay(alignment: .bottomTrailing) {
//        Button(action: { position = .automatic }) {
//          Image(systemName: "dot.scope")
//            .foregroundStyle(.black)
//            .background {
//              RoundedRectangle(cornerRadius: 5)
//                .fill(.white)
//                .frame(width: 40, height: 40)
//            }
//        }
//        .padding([.bottom, .trailing], 16)
//      }
//      .overlay(alignment: .topLeading) {
//        Button(action: { isShowMap = false }) {
//          Image(systemName: "xmark")
//            .imageScale(.large)
//        }
//        .padding(.leading, 16)
//      }
//    }
//  }
