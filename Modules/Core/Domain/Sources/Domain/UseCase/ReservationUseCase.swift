import Combine
import Foundation

public protocol ReservationUseCase {
  var reservationDetail: (Airbnb.Detail.Item, [Date]) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var reservationCityDetail: (Airbnb.SearchCityDetail.Item, [Date]) -> AnyPublisher<Void, CompositeErrorRepository> { get }
  var reservationCountryDetail: (Airbnb.SearchCountryDetail.Item, [Date]) -> AnyPublisher<Void, CompositeErrorRepository> { get }

  var getReservationList: () -> AnyPublisher<[Airbnb.Reservation.Item], CompositeErrorRepository> { get }
}
