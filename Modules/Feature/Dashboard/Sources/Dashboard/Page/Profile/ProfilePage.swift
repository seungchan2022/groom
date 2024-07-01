import Architecture
import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - ProfilePage

struct ProfilePage {
  @Bindable var store: StoreOf<ProfileReducer>
  var routeSubscriber: ProfileRouteSubscriber
}

extension ProfilePage {
  private var tabNavigationComponentViewState: TabNavigationComponent.ViewState {
    .init(activeMatchPath: Link.Dashboard.Path.profile.rawValue)
  }

  private var isLoading: Bool {
    store.fetchUser.isLoading
      || store.fetchUserInfo.isLoading
  }
}

// MARK: View

extension ProfilePage: View {
  var body: some View {
    VStack(spacing: .zero) {
      DesignSystemNavigation(
        barItem: .init(title: ""),
        largeTitle: "Profile")
      {
        VStack(alignment: .leading) {
          switch store.state.status {
          case .isLoggedIn:
            VStack {
              VStack(alignment: .leading) {
                HStack(spacing: 12) {
                  RemoteImage(url: store.item.photoURL ?? "") {
                    Image(systemName: "person.circle")
                      .resizable()
                      .frame(width: 100, height: 100)
                      .fontWeight(.ultraLight)
                  }
                  .scaledToFill()
                  .frame(width: 100, height: 100)
                  .clipShape(Circle())

                  VStack(alignment: .leading) {
                    Text("이메일: \(store.item.email ?? "")")

                    Text("이름: \(store.item.userName ?? "")")
                  }

                  Spacer()

                  Image(systemName: "chevron.right")
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 14, height: 20)
                }

                Divider()
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .onTapGesture {
                store.send(.routeToUpdateProfileImage)
              }

              VStack(spacing: 32) {
                Button(action: { store.send(.routeToUpdateAuth) }) {
                  VStack {
                    HStack {
                      Image(systemName: "lock.square")
                        .resizable()
                        .foregroundStyle(.black)
                        .frame(width: 20, height: 20)

                      Text("로그인 / 보안")
                        .font(.headline)
                        .foregroundStyle(.black)

                      Spacer()

                      Image(systemName: "chevron.right")
                        .resizable()
                        .fontWeight(.light)
                        .foregroundStyle(.black)
                        .frame(width: 14, height: 20)
                    }
                    Divider()
                  }
                }

                Button(action: { store.send(.routeToReservation) }) {
                  VStack {
                    HStack {
                      Image(systemName: "bookmark")
//                        .resizable()
                        .foregroundStyle(.black)
                        .frame(width: 20, height: 20)

                      Text("예약 현황")
                        .font(.headline)
                        .foregroundStyle(.black)

                      Spacer()

                      Image(systemName: "chevron.right")
                        .resizable()
                        .fontWeight(.light)
                        .foregroundStyle(.black)
                        .frame(width: 14, height: 20)
                    }
                    Divider()
                  }
                }
              }
              .padding(.top, 32)
            }

          case .isLoggedOut:
            VStack(alignment: .leading, spacing: 32) {
              Text("Log in to start planning your next trip.")
                .font(.headline)
                .padding(.horizontal, 16)

              Button(action: { store.send(.routeToSignIn) }) {
                Text("Log In")
                  .foregroundStyle(.white)
                  .frame(height: 50)
                  .frame(maxWidth: .infinity)
                  .background(.pink)
                  .clipShape(RoundedRectangle(cornerRadius: 8))
              }

              HStack {
                Text("Don't have an account?")
                  .font(.headline)

                Button(action: { store.send(.routeToSignUp) }) {
                  Text("Sign up")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .underline()
                }
              }
              .padding(.horizontal, 16)
            }
            .padding(.top, 32) // ~ Sign Up
          }
        }
        .padding(.horizontal, 16)
      }

      TabNavigationComponent(
        viewState: tabNavigationComponentViewState,
        tapAction: { store.send(.routeToTabBarItem($0)) })
    }
    .ignoresSafeArea(.all, edges: .bottom)
    .onReceive(routeSubscriber.isRouteEventSubject, perform: { _ in
      store.send(.getUser)
      store.send(.getUserInfo)
    })
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getUser)
      store.send(.getUserInfo)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
