import Foundation

// MARK: - Airbnb.Reservation

extension Airbnb {
  public enum Reservation { }
}

extension Airbnb.Reservation {
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
    public let createdTime: Date
    public let reservedDateList: [Date]

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
      case createdTime = "created_time"
      case reservedDateList = "reserved_dates"
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
