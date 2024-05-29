import Architecture
import Dashboard
import Domain
import Foundation
import LinkNavigator
import Platform

// MARK: - AppSideEffect

struct AppSideEffect: DependencyType, DashboardEnvironmentUsable {
  let authUseCase: AuthUseCase
  let airbnbUseCase: AirbnbUseCase
  let airbnbDetailUseCase: AirbnbDetailUseCase
  let toastViewModel: ToastViewActionType
}
