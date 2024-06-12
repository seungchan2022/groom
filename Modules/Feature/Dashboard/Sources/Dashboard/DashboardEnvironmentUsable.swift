import Architecture
import Domain

public protocol DashboardEnvironmentUsable {
  var authUseCase: AuthUseCase { get }
  var airbnbUseCase: AirbnbUseCase { get }
  var airbnbDetailUseCase: AirbnbDetailUseCase { get }
  var likeUseCase: LikeUseCase { get }
  var searchUseCase: SearchUseCase { get }
  var wishListUseCase: WishListUseCase { get }
  var toastViewModel: ToastViewActionType { get }
}
