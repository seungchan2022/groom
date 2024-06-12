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

// MARK: - WishListUseCasePlatform

public struct WishListUseCasePlatform { }

// MARK: WishListUseCase

extension WishListUseCasePlatform: WishListUseCase {
  public var getItemList: () -> AnyPublisher<[Domain.Airbnb.WishList.Item], CompositeErrorRepository> {
    {
      Future<[Domain.Airbnb.WishList.Item], CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return promise(.failure(.invalidTypeCasting))
        }

        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wish_list")
          .getDocuments { snapshot, error in
            if let error = error {
              return promise(.failure(.other(error)))
            }

            guard let documents = snapshot?.documents else {
              return promise(.failure(.invalidTypeCasting))
            }

            let itemList: [Domain.Airbnb.WishList.Item] = documents.compactMap { document in
              do {
                let item = try Firestore.Decoder().decode(Domain.Airbnb.WishList.Item.self, from: document.data())
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
