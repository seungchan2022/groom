import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

// MARK: - WishListPage.ItemComponent

extension ReservationPage {
  struct ItemComponent {
    @Bindable var store: StoreOf<ReservationReducer>
    
    let viewState: ViewState
    let tapAction: (Airbnb.Reservation.Item) -> Void
  }
}

extension ReservationPage.ItemComponent {
  private var dateIntervalString: String {
    
    if viewState.item.reservedDateList.count >= 2 {
      return "예약 날짜: \(viewState.item.reservedDateList.first?.formatted(date: .abbreviated, time: .omitted) ?? "") ~ \(viewState.item.reservedDateList.last?.formatted(date: .abbreviated, time: .omitted) ?? "")"
    }
    return ""
  }
  
}

// MARK: - WishListPage.ItemComponent + View

extension ReservationPage.ItemComponent: View {
  var body: some View {
    VStack(spacing: 8) {
      TabView {
        ForEach(DesignSystemImage.allCases.shuffled().prefix(4), id: \.self) { item in
          item.image
            .resizable()
            .scaledToFill()
        }
      }
      .frame(height: 320)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .tabViewStyle(.page)
      
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 16) {
          Text(viewState.item.location)
            .multilineTextAlignment(.leading)
            .fontWeight(.semibold)
          
          Text(dateIntervalString)
          
        }
        
        Spacer()
      }
      .foregroundStyle(.black)
      .font(.callout)
      
      Divider()
    }
    
    .onTapGesture {
      tapAction(viewState.item)
    }
  }
}

// MARK: - WishListPage.ItemComponent.ViewState

extension ReservationPage.ItemComponent {
  struct ViewState: Equatable {
    let item: Airbnb.Reservation.Item
  }
}
