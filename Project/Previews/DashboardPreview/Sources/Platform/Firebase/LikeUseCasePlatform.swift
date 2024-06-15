import Architecture
import Combine
import Domain
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Foundation

// MARK: - LikeUseCasePlatform

public struct LikeUseCasePlatform { }

// MARK: LikeUseCase

extension LikeUseCasePlatform: LikeUseCase {

  public var likeDetail: (Domain.Airbnb.Detail.Item) -> AnyPublisher<Void, CompositeErrorRepository> {
    { item in
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
          .collection("wish_list")
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

  public var likeCityDetail: (Domain.Airbnb.SearchCityDetail.Item) -> AnyPublisher<Void, CompositeErrorRepository> {
    { item in
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
          .collection("wish_list")
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

  public var likeCountryDetail: (Domain.Airbnb.SearchCountryDetail.Item) -> AnyPublisher<Void, CompositeErrorRepository> {
    { item in
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
          .collection("wish_list")
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

  public var unLikeDetail: (Domain.Airbnb.Detail.Item) -> AnyPublisher<Void, CompositeErrorRepository> {
    { item in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.invalidTypeCasting))
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wish_list")
          .document("\(item.id)")
          .delete { error in
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

  public var unLikeCityDetail: (Domain.Airbnb.SearchCityDetail.Item) -> AnyPublisher<Void, CompositeErrorRepository> {
    { item in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.invalidTypeCasting))
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wish_list")
          .document("\(item.id)")
          .delete { error in
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

  public var unLikeCountryDetail: (Domain.Airbnb.SearchCountryDetail.Item) -> AnyPublisher<Void, CompositeErrorRepository> {
    { item in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.invalidTypeCasting))
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wish_list")
          .document("\(item.id)")
          .delete { error in
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

  public var getIsLike: (String) -> AnyPublisher<Void, CompositeErrorRepository> {
    { itemID in
      Future<Void, CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wish_list")
          .document(itemID)
          .getDocument { document, error in
            if let error = error {
              return promise(.failure(.other(error)))
            } else if document?.exists == true {
              return promise(.success(Void()))
            }
          }
      }
      .eraseToAnyPublisher()
    }
  }
}
