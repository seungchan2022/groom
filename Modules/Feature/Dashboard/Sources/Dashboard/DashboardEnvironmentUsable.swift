import Architecture
import Domain

public protocol DashboardEnvironmentUsable {
  var authUseCase: AuthUseCase { get }
  var airbnbUseCase: AirbnbUseCase { get }
  var airbnbDetailUseCase: AirbnbDetailUseCase { get }
  var toastViewModel: ToastViewActionType { get }
}
