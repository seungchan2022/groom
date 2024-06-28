import ComposableArchitecture
import DesignSystem
import SwiftUI

// MARK: - UpdateAuthPage

struct UpdateAuthPage {
  @Bindable var store: StoreOf<UpdateAuthReducer>
}

extension UpdateAuthPage {
  private var isGoogleUser: Bool {
    store.item.email?.hasSuffix("@gmail.com") ?? false
  }

  private var isLoading: Bool {
    store.fetchUserInfo.isLoading
      || store.fetchUpdateUserName.isLoading
      || store.fetchDeleteUser.isLoading
      || store.fetchDeleteUserInfo.isLoading
      || store.fetchDeleteProfileImage.isLoading
  }
}

// MARK: View

extension UpdateAuthPage: View {
  var body: some View {
    VStack {
      DesignSystemNavigation(
        barItem: .init(
          backAction: .init(
            image: Image(systemName: "chevron.left"),
            action: { store.send(.routeToBack) }),
          title: "로그인/보안",
          moreActionList: [
            .init(
              title: "로그아웃",
              action: { store.isShowSignOut = true }),
          ]),
        isShowDivider: true)
      {
        VStack(spacing: 24) {
          HStack {
            VStack(alignment: .leading, spacing: 12) {
              Text("이메일")

              Text(store.item.email ?? "")
            }

            Spacer()
          }
          .padding(.horizontal, 16)

          Divider()

          HStack {
            VStack(alignment: .leading, spacing: 12) {
              Text("이름")
              Text(store.item.userName ?? "")
            }

            Spacer()

            Button(action: {
              store.userName = ""
              store.isShowUpdateUser = true
            }) {
              Text("변경")
            }
          }
          .padding(.horizontal, 16)

          Divider()

          if !isGoogleUser {
            HStack {
              VStack(alignment: .leading, spacing: 12) {
                Text("비밀번호")
                Text("************")
              }

              Spacer()

              Button(action: { store.send(.routeToUpdatePassword) }) {
                Text("변경")
              }
            }
            .padding(.horizontal, 16)

            Divider()
          }
        }
      }
    }
    .alert(
      "로그아웃을 하시겠습니까?",
      isPresented: $store.isShowSignOut,
      actions: {
        Button(role: .cancel, action: { }) {
          Text("취소")
        }

        Button(action: { store.send(.onTapSignOut) }) {
          Text("로그아웃")
        }
      })
    .alert(
      "이름을 변경하시겠습니까?",
      isPresented: $store.isShowUpdateUser,
      actions: {
        TextField("이름", text: $store.userName)
          .autocorrectionDisabled(true)

        Button(role: .cancel, action: { }) {
          Text("취소")
        }

        Button(action: { store.send(.onTapUpdateUserName) }) {
          Text("확인")
        }
      },
      message: {
        Text("이름을 변경하시고 싶으면, 변경하고 싶으신 이름을 작성하시고 확인을 눌러주세요.")
      })
    .alert(
      "계정을 탈퇴 하시겠습니까?",
      isPresented: $store.isShowDeleteUser,
      actions: {
        Button(role: .cancel, action: { }) {
          Text("취소")
        }

        Button(action: {
          store.send(.onTapDeleteUser)
          store.send(.onTapDeleteUserInfo)
          store.send(.deleteProfileImage)
        }) {
          Text("계정 탈퇴")
        }
      })
    .overlay(alignment: .bottom) {
      Button(action: { store.isShowDeleteUser = true }) {
        Text("계정 탈퇴")
      }
      .padding(.bottom, 64)
      .padding(.top, 32)
    }
    .toolbar(.hidden, for: .navigationBar)
    .setRequestFlightView(isLoading: isLoading)
    .onAppear {
      store.send(.getUserInfo)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
