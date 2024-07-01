import Combine
import Domain
import Firebase
import FirebaseStorage

// MARK: - ReservationUseCasePlatform

public struct ReservationUseCasePlatform {
  public init() { }
}

// MARK: ReservationUseCase

extension ReservationUseCasePlatform: ReservationUseCase {

  public var reservationDetail: (Domain.Airbnb.Detail.Item, [Date]) -> AnyPublisher<Void, Domain.CompositeErrorRepository> {
    { item, dateList in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.userCancelled))
        }
        var data: [String: Any] = [
          "id" : item.id,
          "name" : item.name,
          "host_id" : item.hostID,
          "room_type" : item.roomType,
          "column_10" : item.price,
          "number_of_reviews" : item.reviewCount,
          "calculated_host_listings_count" : item.totalListingCount,
          "availability_365" : item.availableDays,
          "updated_date" : item.lastUpdateDate,
          "column_19" : item.country,
          "city" : item.city,
          "column_20" : item.location,
          "coordinates": [
            "lat": item.coordinateList.latitude,
            "lon": item.coordinateList.longitude,
          ],
          "created_time": Timestamp(),
          "reserved_dates": dateList.map { $0 },
        ]

        if let lastReviewDate = item.lastReviewDate {
          data["last_review"] = lastReviewDate
        }

        if let reviewPerMonth = item.reviewPerMonth {
          data["reviews_per_month"] = reviewPerMonth
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("reservation")
          .document("\(item.id)")
          .setData(data) { error in
            if let error = error {
              return promise(.failure(.other(error)))
            } else {
              return promise(.success(Void()))
            }
          }
      }
      .eraseToAnyPublisher()
    }
  }

  public var reservationCityDetail: (Domain.Airbnb.SearchCityDetail.Item, [Date]) -> AnyPublisher<
    Void,
    Domain.CompositeErrorRepository
  > {
    { item, dateList in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.userCancelled))
        }
        var data: [String: Any] = [
          "id" : item.id,
          "name" : item.name,
          "host_id" : item.hostID,
          "room_type" : item.roomType,
          "column_10" : item.price,
          "number_of_reviews" : item.reviewCount,
          "calculated_host_listings_count" : item.totalListingCount,
          "availability_365" : item.availableDays,
          "updated_date" : item.lastUpdateDate,
          "column_19" : item.country,
          "city" : item.city,
          "column_20" : item.location,
          "coordinates": [
            "lat": item.coordinateList.latitude,
            "lon": item.coordinateList.longitude,
          ],
          "created_time": Timestamp(),
          "reserved_dates": dateList.map { $0 },
        ]

        if let lastReviewDate = item.lastReviewDate {
          data["last_review"] = lastReviewDate
        }

        if let reviewPerMonth = item.reviewPerMonth {
          data["reviews_per_month"] = reviewPerMonth
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("reservation")
          .document("\(item.id)")
          .setData(data) { error in
            if let error = error {
              return promise(.failure(.other(error)))
            } else {
              return promise(.success(Void()))
            }
          }
      }
      .eraseToAnyPublisher()
    }
  }

  public var reservationCountryDetail: (Domain.Airbnb.SearchCountryDetail.Item, [Date]) -> AnyPublisher<
    Void,
    Domain.CompositeErrorRepository
  > {
    { item, dateList in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.userCancelled))
        }
        var data: [String: Any] = [
          "id" : item.id,
          "name" : item.name,
          "host_id" : item.hostID,
          "room_type" : item.roomType,
          "column_10" : item.price,
          "number_of_reviews" : item.reviewCount,
          "calculated_host_listings_count" : item.totalListingCount,
          "availability_365" : item.availableDays,
          "updated_date" : item.lastUpdateDate,
          "column_19" : item.country,
          "city" : item.city,
          "column_20" : item.location,
          "coordinates": [
            "lat": item.coordinateList.latitude,
            "lon": item.coordinateList.longitude,
          ],
          "created_time": Timestamp(),
          "reserved_dates": dateList.map { $0 },
        ]

        if let lastReviewDate = item.lastReviewDate {
          data["last_review"] = lastReviewDate
        }

        if let reviewPerMonth = item.reviewPerMonth {
          data["reviews_per_month"] = reviewPerMonth
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("reservation")
          .document("\(item.id)")
          .setData(data) { error in
            if let error = error {
              return promise(.failure(.other(error)))
            } else {
              return promise(.success(Void()))
            }
          }
      }
      .eraseToAnyPublisher()
    }
  }

  public var getReservationList: () -> AnyPublisher<[Airbnb.Reservation.Item], CompositeErrorRepository> {
    {
      Future<[Airbnb.Reservation.Item], CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.userCancelled))
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("reservation")
          .getDocuments { snapshot, error in
            if let error = error {
              return promise(.failure(.other(error)))
            }

            guard let documents = snapshot?.documents else {
              return promise(.failure(.invalidTypeCasting))
            }

            let itemList: [Domain.Airbnb.Reservation.Item] = documents.compactMap { document in
              do {
                let item = try Firestore.Decoder().decode(Domain.Airbnb.Reservation.Item.self, from: document.data())
                return item
              } catch {
                return .none
              }
            }

            promise(.success(itemList))
          }
      }
      .eraseToAnyPublisher()
    }
  }
}
