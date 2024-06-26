import Foundation

// MARK: - Airbnb.Detail

extension Airbnb {
  public enum Detail { }
  public enum SearchCityDetail { }
  public enum SearchCountryDetail { }
}

extension Airbnb.Detail {
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

    // MARK: Public

    public let id: Int
    public let name: String
    public let hostID: Int
    public let roomType: String
    public let price: Int
    public let reviewCount: Int
    public let lastReviewDate: String?
    public let reviewPerMonth: Double?
    public let totalListingCount: Int
    public let availableDays: Int
    public let lastUpdateDate: String
    public let country: String
    public let city: String
    public let location: String
    public let coordinateList: Coordinate

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
      case id
      case name
      case hostID = "host_id"
      case roomType = "room_type"
      case price = "column_10"
      case reviewCount = "number_of_reviews"
      case lastReviewDate = "last_review"
      case reviewPerMonth = "reviews_per_month"
      case totalListingCount = "calculated_host_listings_count"
      case availableDays = "availability_365"
      case lastUpdateDate = "updated_date"
      case country = "column_19"
      case city
      case location = "column_20"
      case coordinateList = "coordinates"
    }
  }

  public struct Coordinate: Equatable, Sendable, Codable {
    public let latitude: Double
    public let longitude: Double

    private enum CodingKeys: String, CodingKey {
      case latitude = "lat"
      case longitude = "lon"
    }
  }
}

extension Airbnb.SearchCityDetail {

  public struct Request: Equatable, Sendable, Codable {
    public let perPage: Int
    public let query: String

    public init(
      perPage: Int = 20,
      query: String)
    {
      self.perPage = perPage
      self.query = "city:\(query)"
    }

    private enum CodingKeys: String, CodingKey {
      case perPage = "limit"
      case query = "refine"
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

    // MARK: Public

    public let id: Int
    public let name: String
    public let hostID: Int
    public let roomType: String
    public let price: Int
    public let reviewCount: Int
    public let lastReviewDate: String?
    public let reviewPerMonth: Double?
    public let totalListingCount: Int
    public let availableDays: Int
    public let lastUpdateDate: String
    public let country: String
    public let city: String
    public let location: String
    public let coordinateList: Coordinate

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
      case id
      case name
      case hostID = "host_id"
      case roomType = "room_type"
      case price = "column_10"
      case reviewCount = "number_of_reviews"
      case lastReviewDate = "last_review"
      case reviewPerMonth = "reviews_per_month"
      case totalListingCount = "calculated_host_listings_count"
      case availableDays = "availability_365"
      case lastUpdateDate = "updated_date"
      case country = "column_19"
      case city
      case location = "column_20"
      case coordinateList = "coordinates"
    }
  }

  public struct Coordinate: Equatable, Sendable, Codable {
    public let latitude: Double
    public let longitude: Double

    private enum CodingKeys: String, CodingKey {
      case latitude = "lat"
      case longitude = "lon"
    }
  }

}

extension Airbnb.SearchCountryDetail {

  public struct Request: Equatable, Sendable, Codable {
    public let perPage: Int
    public let query: String

    public init(
      perPage: Int = 20,
      query: String)
    {
      self.perPage = perPage
      self.query = "column_19:\(query)"
    }

    private enum CodingKeys: String, CodingKey {
      case perPage = "limit"
      case query = "refine"
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

    // MARK: Public

    public let id: Int
    public let name: String
    public let hostID: Int
    public let roomType: String
    public let price: Int
    public let reviewCount: Int
    public let lastReviewDate: String?
    public let reviewPerMonth: Double?
    public let totalListingCount: Int
    public let availableDays: Int
    public let lastUpdateDate: String
    public let country: String
    public let city: String
    public let location: String
    public let coordinateList: Coordinate

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
      case id
      case name
      case hostID = "host_id"
      case roomType = "room_type"
      case price = "column_10"
      case reviewCount = "number_of_reviews"
      case lastReviewDate = "last_review"
      case reviewPerMonth = "reviews_per_month"
      case totalListingCount = "calculated_host_listings_count"
      case availableDays = "availability_365"
      case lastUpdateDate = "updated_date"
      case country = "column_19"
      case city
      case location = "column_20"
      case coordinateList = "coordinates"
    }
  }

  public struct Coordinate: Equatable, Sendable, Codable {
    public let latitude: Double
    public let longitude: Double

    private enum CodingKeys: String, CodingKey {
      case latitude = "lat"
      case longitude = "lon"
    }
  }

}
