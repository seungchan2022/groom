import SwiftUI
import ComposableArchitecture
import DesignSystem

// MARK: - ExplorePage

struct ExplorePage {
  @Bindable var store: StoreOf<ExploreReducer>
}

// MARK: View

extension ExplorePage: View {
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "magnifyingglass")
        
        VStack(alignment: .leading) {
          Text("Where to?")
            .font(.footnote)
            .fontWeight(.semibold)
          
          Text("Anywhere - Any Week - Add guests")
            .font(.caption2)
            .foregroundStyle(.gray)
        }
        
        Spacer()
        
        Button(action: { }) {
          Image(systemName: "line.3.horizontal.decrease.circle")
            .foregroundStyle(.black)
        }
      }
      .padding(.horizontal)
      .padding(.vertical, 8)
      .overlay {
        Capsule()
          .stroke(lineWidth: 0.5)
          .foregroundStyle(.gray.opacity(0.4))
      }
      .padding()
      
      ScrollView {
        LazyVStack(spacing: 48) {
          ForEach(0..<5) { _ in
            Button(action:  { store.send(.routeToDetail) }) {
              VStack(spacing: 8) {
                TabView {
                  ForEach(DesignSystemImage.allCases.prefix(4), id: \.self) { item in
                    item.image
                      .resizable()
                      .scaledToFill()
                  }
                }
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .tabViewStyle(.page)
                
                HStack(alignment: .top) {
                  VStack(alignment: .leading) {
                    Text("Miami, Florida")
                      .foregroundStyle(.black)
                      .fontWeight(.semibold)
                    
                    Text("12 mi away")
                      .foregroundStyle(.gray)
                    
                    HStack {
                      Text("$567")
                      
                        .fontWeight(.semibold)
                      
                      Text("night")
                    }
                    .foregroundStyle(.black)
                  }
                  
                  Spacer()
                  
                  HStack {
                    Image(systemName: "star.fill")
                    
                    Text("4.86")
                  }
                  .foregroundStyle(.black)
                }
                .font(.footnote)
              }
            }
          }
        }
        .padding(.horizontal, 16)
      }
      .toolbar(.hidden, for: .navigationBar)
    }
  }
}
