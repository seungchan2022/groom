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

extension DetailPage { }

// MARK: View

extension DetailPage: View {
  var body: some View {
    ScrollView {
      if let item = store.fetchItem.value?.itemList.first(where: { $0.id == store.item.id }) {
        ItemComponent(
          viewState: .init(item: item),
          backAction: { store.send(.routeToBack) },
          tapAction: { isShowMap = true },
          position: $position)
      }
    }
    .fullScreenCover(isPresented: $isShowMap) {
      if let item = store.fetchItem.value?.itemList.first(where: { $0.id == store.item.id }) {
        Map(position: $position) {
          Marker(
            "Destination",
            coordinate: CLLocationCoordinate2D(
              latitude: item.coordinateList.latitude,
              longitude: item.coordinateList.longitude))
        }
        .mapStyle(.standard)
        .mapControls {
          MapCompass()
          MapUserLocationButton()
          MapPitchToggle()
        }
        .overlay(alignment: .bottomTrailing) {
          Button(action: { position = .automatic }) {
            Image(systemName: "dot.scope")
              .foregroundStyle(.black)
              .background {
                RoundedRectangle(cornerRadius: 5)
                  .fill(.white)
                  .frame(width: 40, height: 40)
              }
          }
          .padding([.bottom, .trailing], 16)
        }
        .overlay(alignment: .topLeading) {
          Button(action: { isShowMap = false }) {
            Image(systemName: "xmark")
              .imageScale(.large)
          }
          .padding(.leading, 16)
        }
      }
    }
    .ignoresSafeArea()
    .toolbar(.hidden, for: .navigationBar)
    .onAppear {
      store.send(.getItem(store.item))
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
