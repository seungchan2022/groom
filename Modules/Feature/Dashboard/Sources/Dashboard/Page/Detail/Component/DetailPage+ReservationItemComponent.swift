import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - DetailPage.ReservationItemComponent

extension DetailPage {
  struct ReservationItemComponent {
    let viewState: ViewState

    let tapAction: () -> Void

    @Bindable var store: StoreOf<DetailReducer>
  }
}

// MARK: - DetailPage.ReservationItemComponent + View

extension DetailPage.ReservationItemComponent: View {
  var body: some View {
    VStack(spacing: .zero) {
      Divider()

      HStack {
        Button(action: {
          store.selectedDateList = []
          store.selectedDate = "날짜를 선택해주세요"
          store.isShowCalendar = true
        }) {
          VStack(alignment: .leading) {
            Text("$\(viewState.item.price) / 박")
              .fontWeight(.semibold)

            Text(store.selectedDate)
              .multilineTextAlignment(.leading)
              .underline()
          }
        }
        .foregroundStyle(.black)
        Spacer()

        Button(action: { tapAction() }) {
          Text("예약하기")
            .foregroundStyle(.white)
            .font(.subheadline)
            .fontWeight(.semibold)
            .frame(width: 140, height: 40)
            .background(store.selectedDateList.isEmpty ? .pink.opacity(0.1) : .pink)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .disabled(store.selectedDateList.isEmpty)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 16)
      .padding(.bottom, WindowAppearance.safeArea.bottom)
      .background {
        Rectangle()
          .fill(DesignSystemColor.label(.default).color)
          .fill(.white)
      }
    }
  }

}

// MARK: - DetailPage.ReservationItemComponent.ViewState

extension DetailPage.ReservationItemComponent {
  struct ViewState: Equatable {
    let item: Airbnb.Detail.Item
  }
}
