import Architecture
import ComposableArchitecture
import SwiftUI

// MARK: - ProfilePage

struct ProfilePage {
  @Bindable var store: StoreOf<ProfileReducer>
}

// MARK: View

extension ProfilePage: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        switch store.state.status {
        case .isLoggedIn:
          VStack(alignment: .leading) {
            Text("로그인 성공")
              .font(.largeTitle)

            Text("User ID: \(store.item.uid)")
            Text("User Email: \(store.item.email ?? "")")
          }
          .padding(.top, 32)

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
          Button(action: { }) {
            VStack {
              HStack {
                Image(systemName: "gear")
                  .resizable()
                  .foregroundStyle(.black)
                  .frame(width: 20, height: 20)

                Text("Settings")
                  .font(.headline)
                  .foregroundStyle(.black)

                Spacer()

                Image(systemName: "chevron.right")
                  .resizable()
                  .foregroundStyle(.black)
                  .frame(width: 14, height: 20)
              }

              Divider()
            }
          }

          Button(action: { }) {
            VStack {
              HStack {
                Image(systemName: "gear")
                  .resizable()
                  .foregroundStyle(.black)
                  .frame(width: 20, height: 20)

                Text("Accessibility")
                  .font(.headline)
                  .foregroundStyle(.black)

                Spacer()

                Image(systemName: "chevron.right")
                  .resizable()
                  .foregroundStyle(.black)
                  .frame(width: 14, height: 20)
              }

              Divider()
            }
          }

          Button(action: { }) {
            VStack {
              HStack {
                Image(systemName: "questionmark.circle")
                  .resizable()
                  .foregroundStyle(.black)
                  .frame(width: 20, height: 20)

                Text("Visit the Help Center")
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
          
          
          Button(action: { store.send(.routeToUpdatePassword) }) {
            VStack {
              HStack {
                Image(systemName: "shield.righthalf.filled")
                  .resizable()
                  .foregroundStyle(.black)
                  .frame(width: 20, height: 20)

                Text("비밀번호 변경")
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
      .padding(.horizontal, 16)
    }
    .navigationTitle("Profile")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: { store.send(.onTapSignOut) }) {
          Text("Log Out")
            .font(.headline)
            .foregroundStyle(.black)
        }
      }
    }
    .onAppear {
      store.send(.getUser)
      store.send(.getUserInfo)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
