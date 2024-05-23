import Architecture
import Domain

public protocol DashboardEnvironmentUsable {
  var authUseCase: AuthUseCase { get }
  var toastViewModel: ToastViewActionType { get }
}
