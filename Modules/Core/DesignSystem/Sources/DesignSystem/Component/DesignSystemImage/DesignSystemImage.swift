import Foundation
import SwiftUI

public enum DesignSystemImage: CaseIterable, Equatable {
  case image1
  case image2
  case image3
  case image4
  case image5
  case image6
  case image7
  case image8
  case host

  // MARK: Public

  public var image: Image {
    var image: Image {
      switch self {
      case .image1:
        Asset.Image.image1.swiftUIImage
      case .image2:
        Asset.Image.image2.swiftUIImage
      case .image3:
        Asset.Image.image3.swiftUIImage
      case .image4:
        Asset.Image.image4.swiftUIImage
      case .image5:
        Asset.Image.image5.swiftUIImage
      case .image6:
        Asset.Image.image6.swiftUIImage
      case .image7:
        Asset.Image.image7.swiftUIImage
      case .image8:
        Asset.Image.image8.swiftUIImage
      case .host:
        Asset.Image.host.swiftUIImage
      }
    }

    return image
  }
}
