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
          return promise(.failure(.invalidTypeCasting))
        }

        var data: [String: Any] = [
          "id" : item.id,
          "name" : item.name,
          "hostID" : item.hostID,
          "roomType" : item.roomType,
          "price" : item.price,
          "reviewCount" : item.reviewCount,
          "totalListingCount" : item.totalListingCount,
          "availableDays" : item.availableDays,
          "lastUpdateDate" : item.lastUpdateDate,
          "country" : item.country,
          "city" : item.city,
          "location" : item.location,
          "coordinateList": [
            "latitude": item.coordinateList.latitude,
            "longitude": item.coordinateList.longitude,
          ],
        ]

        if let lastReviewDate = item.lastReviewDate {
          data["lastReviewDate"] = lastReviewDate
        }

        if let reviewPerMonth = item.reviewPerMonth {
          data["reviewPerMonth"] = reviewPerMonth
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wishList")
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
          return promise(.failure(.invalidTypeCasting))
        }

        var data: [String: Any] = [
          "id" : item.id,
          "name" : item.name,
          "hostID" : item.hostID,
          "roomType" : item.roomType,
          "price" : item.price,
          "reviewCount" : item.reviewCount,
          "totalListingCount" : item.totalListingCount,
          "availableDays" : item.availableDays,
          "lastUpdateDate" : item.lastUpdateDate,
          "country" : item.country,
          "city" : item.city,
          "location" : item.location,
          "coordinateList": [
            "latitude": item.coordinateList.latitude,
            "longitude": item.coordinateList.longitude,
          ],
        ]

        if let lastReviewDate = item.lastReviewDate {
          data["lastReviewDate"] = lastReviewDate
        }

        if let reviewPerMonth = item.reviewPerMonth {
          data["reviewPerMonth"] = reviewPerMonth
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wishList")
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
          return promise(.failure(.invalidTypeCasting))
        }

        var data: [String: Any] = [
          "id" : item.id,
          "name" : item.name,
          "hostID" : item.hostID,
          "roomType" : item.roomType,
          "price" : item.price,
          "reviewCount" : item.reviewCount,
          "totalListingCount" : item.totalListingCount,
          "availableDays" : item.availableDays,
          "lastUpdateDate" : item.lastUpdateDate,
          "country" : item.country,
          "city" : item.city,
          "location" : item.location,
          "coordinateList": [
            "latitude": item.coordinateList.latitude,
            "longitude": item.coordinateList.longitude,
          ],
        ]

        if let lastReviewDate = item.lastReviewDate {
          data["lastReviewDate"] = lastReviewDate
        }

        if let reviewPerMonth = item.reviewPerMonth {
          data["reviewPerMonth"] = reviewPerMonth
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wishList")
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
          .collection("wishList")
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
          .collection("wishList")
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
          .collection("wishList")
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
          return promise(.failure(.invalidTypeCasting))
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wishList")
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
