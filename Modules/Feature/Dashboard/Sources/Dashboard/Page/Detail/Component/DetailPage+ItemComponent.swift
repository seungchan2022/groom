import _MapKit_SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - DetailPage.ItemComponent

extension DetailPage {
  struct ItemComponent {
    let viewState: ViewState
    let backAction: () -> Void
    let tapAction: () -> Void
    let likeAction: (Airbnb.Detail.Item) -> Void

    @Binding var position: MapCameraPosition
  }
}

extension DetailPage.ItemComponent {
  private var lastReviewDate: String {
    viewState.item.lastReviewDate?.toDate?.toString ?? ""
  }

  private var lastUpdateDate: String {
    viewState.item.lastUpdateDate.toDate?.toString ?? ""
  }

  private var destination: MKCoordinateRegion {
    .init(
      center: CLLocationCoordinate2D(
        latitude: viewState.item.coordinateList.latitude,
        longitude: viewState.item.coordinateList.longitude),
      span: .init())
  }
}

// MARK: - DetailPage.ItemComponent + View

extension DetailPage.ItemComponent: View {
  var body: some View {
    TabView {
      ForEach(DesignSystemImage.allCases.shuffled().prefix(4), id: \.self) { item in
        item.image
          .resizable()
          .scaledToFill()
      }
    }
    .frame(height: 320)
    .tabViewStyle(.page)
    .overlay(alignment: .topLeading) {
      Button(action: { backAction() }) {
        Image(systemName: "chevron.left")
          .foregroundStyle(.black)
          .background {
            Circle()
              .fill(.white)
              .frame(width: 32, height: 32)
          }
          .padding(.horizontal, 24)
          .padding(.top, 64)
      }
    }
    .overlay(alignment: .topTrailing) {
      Button(action: { likeAction(viewState.item) }) {
        Image(systemName: viewState.isLike ? "heart.fill" : "heart")
          .foregroundStyle(viewState.isLike ? .pink : .black)
          .background {
            Circle()
              .fill(.white)
              .frame(width: 32, height: 32)
          }
          .padding(.horizontal, 24)
          .padding(.top, 64)
      }
    }

    VStack(alignment: .leading, spacing: 16) {
      VStack(alignment: .leading, spacing: 12) {
        Text(viewState.item.name)
          .font(.title2)

        VStack(alignment: .leading, spacing: 12) {
          HStack(spacing: 16) {
            if let reviewPerMonth = viewState.item.reviewPerMonth {
              Text("월별 평균 리뷰수: \(String(format: "%.2f", reviewPerMonth))")
            }

            Text("후기: \(viewState.item.reviewCount)개")
              .underline()
              .fontWeight(.semibold)
          }
          .foregroundStyle(.black)

          Text(viewState.item.location)
        }
        .font(.callout)
      }
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, alignment: .leading)

      Divider()

      HStack {
        VStack(alignment: .leading, spacing: 16) {
          Text("호스트 ID: \(viewState.item.hostID)")

          Text("등록한 총 숙소수: \(viewState.item.totalListingCount)")
        }
        .font(.callout)

        Spacer()

        DesignSystemImage.host.image
          .resizable()
          .scaledToFill()
          .frame(width: 60, height: 60)
          .clipShape(Circle())
      }
      .padding(.horizontal, 16)

      Divider()

      VStack(alignment: .leading, spacing: 16) {
        Text("숙소 유형: \(viewState.item.roomType)")
        Text("예약 가능한 일수: \(viewState.item.availableDays)")
      }
      .font(.callout)
      .padding(.horizontal, 16)

      Divider()

      VStack(alignment: .leading, spacing: 16) {
        Text("마지막 리뷰: \(lastReviewDate)")

        Text("마지막 업데이트: \(lastUpdateDate)")
      }
      .font(.callout)
      .padding(.horizontal, 16)

      Divider()

      VStack(alignment: .leading, spacing: 16) {
        Text("숙소 위치")
          .font(.headline)

        Map(position: $position) {
          Marker(
            "Destination",
            coordinate: CLLocationCoordinate2D(
              latitude: viewState.item.coordinateList.latitude,
              longitude: viewState.item.coordinateList.longitude))
        }
        .overlay(alignment: .bottomTrailing) {
          Button(action: { position = .automatic }) {
            Image(systemName: "dot.scope")
              .foregroundStyle(.black)
              .background {
                RoundedRectangle(cornerRadius: 5)
                  .fill(.white)
                  .frame(width: 32, height: 32)
              }
          }
          .padding(8)
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .mapStyle(.standard)
        .onTapGesture {
          tapAction()
        }
      }

      .padding(.horizontal, 16)
    }
    .padding(.top, 20)
    .padding(.bottom, 140)
  }

}

// MARK: - DetailPage.ItemComponent.ViewState

extension DetailPage.ItemComponent {
  struct ViewState: Equatable {
    let item: Airbnb.Detail.Item
    var isLike: Bool
  }
}

extension String {
  fileprivate var toDate: Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: self)
  }
}

extension Date {
  fileprivate var toString: String? {
    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "MMM d, yyyy"
    return displayFormatter.string(from: self)
  }
}
