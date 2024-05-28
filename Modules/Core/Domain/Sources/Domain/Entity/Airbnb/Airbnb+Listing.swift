import Foundation

// MARK: - Airbnb.Listing

extension Airbnb {
  public enum Listing { }
}

extension Airbnb.Listing {
  public struct Request: Equatable, Sendable, Codable {
    public let perPage: Int

    public init(perPage: Int = 20) {
      self.perPage = perPage
    }

    private enum CodingKeys: String, CodingKey {
      case perPage = "limit"
    }
  }

  public struct Response: Equatable, Sendable, Codable {
    public let totalCount: Int
    public let itemList: [Item]

    private enum CodingKeys: String, CodingKey {
      case totalCount = "total_count"
      case itemList = "results"
    }
  }

  public struct Item: Identifiable, Equatable, Sendable, Codable {
    public let id: Int

    private enum CodingKeys: String, CodingKey {
      case id
    }
  }
}
