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

public struct WishListUseCasePlatform {
  public init() { }
}

// MARK: WishListUseCase

extension WishListUseCasePlatform: WishListUseCase {
  public var getItemList: () -> AnyPublisher<[Domain.Airbnb.WishList.Item], CompositeErrorRepository> {
    {
      Future<[Domain.Airbnb.WishList.Item], CompositeErrorRepository> { promise in
        guard let me = Auth.auth().currentUser else {
          return
        }

        /// Firestore 경로 설정
        Firestore.firestore()
          .collection("users")
          .document(me.uid)
          .collection("wish_list")
          /// getDocuments 메서드를 호출하여 Firestore에서 데이터를 가져옴
          .getDocuments { snapshot, error in
            if let error = error {
              return promise(.failure(.other(error)))
            }

            /// 문서 확인 => snapshot에서 documents 배열 가져옴
            guard let documents = snapshot?.documents else {
              return promise(.failure(.invalidTypeCasting))
            }

            /// 각 문서를 순회하며 데이터 디코딩
            /// Domain.Airbnb.WishList.Item 타입 객체로 변환하고 compackMap으로 필터링
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
