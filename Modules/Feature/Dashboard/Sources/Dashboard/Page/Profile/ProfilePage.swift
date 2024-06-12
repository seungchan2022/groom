import Architecture
import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - ProfilePage

struct ProfilePage {
  @Bindable var store: StoreOf<ProfileReducer>
  var routeSubscriber: ProfileRouteSubscriber
}

// MARK: View

extension ProfilePage: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        switch store.state.status {
        case .isLoggedIn:
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
          .padding(.top, 32)
          .onTapGesture {
            store.send(.routeToUpdateProfileImage)
          }

        case .isLoggedOut:
          VStack(alignment: .leading, spacing: 32) {
            Text("Log in to start planning your next trip.")
              .font(.headline)

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
          }
          .padding(.top, 32) // ~ Sign Up
        }
        VStack(spacing: 32) {
          if store.state.status == .isLoggedIn {
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
          }
        }
        .padding(.top, 32)
      }
      .padding(.horizontal, 16)
    }
    .navigationTitle("Profile")
    .toolbar {
      if store.state.status == .isLoggedIn {
        ToolbarItem(placement: .topBarTrailing) {
          Button(action: { store.isShowResetPassword = true }) {
            Text("Log Out")
              .font(.headline)
              .foregroundStyle(.black)
          }
        }
      }
    }
    .alert(
      "로그아웃을 하시겠습니까?",
      isPresented: $store.isShowResetPassword,
      actions: {
        Button(role: .cancel, action: { }) {
          Text("취소")
        }

        Button(action: { store.send(.onTapSignOut) }) {
          Text("로그아웃")
        }
      })
    .onReceive(routeSubscriber.isRouteEventSubject, perform: { _ in
      store.send(.getUser)
      store.send(.getUserInfo)
    })
    .onAppear {
      store.send(.getUser)
      store.send(.getUserInfo)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
