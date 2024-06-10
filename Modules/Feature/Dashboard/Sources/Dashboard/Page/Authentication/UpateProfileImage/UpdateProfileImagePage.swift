import ComposableArchitecture
import SwiftUI

// MARK: - UpdateProfileImagePage

struct UpdateProfileImagePage {
  @Bindable var store: StoreOf<UpdateProfileImageReducer>
}

// MARK: View

extension UpdateProfileImagePage: View {
  var body: some View {
    ScrollView {
      VStack {
        Image(systemName: "person.circle")
          .resizable()
          .frame(width: 200, height: 200)

        VStack {
          Text("이메일: \(store.item.email ?? "")")

          Text("이름: \(store.item.userName ?? "")")
        }
        .padding(.top, 32)
      }

      Divider()
        .padding(.top, 32)
    }
    .navigationTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden()
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button(action: { store.send(.routeToBack) }) {
          Image(systemName: "chevron.left")
            .imageScale(.large)
        }
      }
    }
    .onAppear {
      store.send(.getUserInfo)
    }
    .onDisappear {
      store.send(.teardown)
    }
  }
}
