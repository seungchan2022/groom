import SwiftUI
import ComposableArchitecture

struct SamplePage {
  @Bindable var store: StoreOf<SampleReducer>
}


extension SamplePage: View {
  var body: some View {
    Text("Sample Page")
  }
}
