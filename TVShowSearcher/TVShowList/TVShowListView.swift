import Foundation
import SwiftUI
import Kingfisher

struct TVShowList: View {
    @ObservedObject var viewModel = TVShowListViewModel()
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
                case .initialLoading:
                    LoadingView()
                case .success:
                    TVShowGridView(viewModel: viewModel)
                case .error:
                    ErrorView()
                default:
                    EmptyView()
            }
        }.accentColor(.black)
    }
}

struct TVShowGridView: View {
    @ObservedObject var viewModel = TVShowListViewModel()
    
    private let columns = [GridItem(.adaptive(minimum: 210, maximum: 225)),
                           GridItem(.adaptive(minimum: 210, maximum: 225))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                TVShowCell(viewModel: viewModel)
                LoadingCellView(
                    isFailed: viewModel.cellLoading)
                .onTapGesture(perform: onTapLoadView)
            }.padding([.leading, .trailing], 16)
        }
        .navigationTitle("tvShowNavigationTitle")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: TVShowSearchView()) {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
            }
        }
    }
    
    private func onTapLoadView() {
        if viewModel.cellLoading {
            viewModel.cellLoading = false
            viewModel.loadContent()
        }
    }
}

struct LoadingCellView: View {
    let isFailed: Bool
    
    var body: some View {
        Text(isFailed ? "Loading...": "Some error occured")
            .foregroundColor(isFailed ? .gray : .red)
            .bold()
            .padding()
    }
}

struct TVShowCell: View {
    let viewModel: TVShowListViewModel
    
    var body: some View {
        ForEach(viewModel.items) { item in
            NavigationLink(destination: DetailView(movie: item)) {
                VStack {
                    ImageLoader(item.image?.mediumURL)
                    Text(item.name)
                        .truncationMode(.tail)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                }
                .onAppear {
                    viewModel.callNextPageIfNeeded(currentItem: item)
                }
            }
        }
    }
}

