import Foundation
import SwiftUI
import Kingfisher

struct DetailView: View {
    @StateObject var viewModel = TVShowDetailViewModel()
    let movie: TVShow
    
    var body: some View {
        ScrollView {
            VStack {
                DetailHeaderView(movie: movie)
                
                VStack(alignment: .leading) {
                    DetailInfoView(movie: movie)
                    Divider()
                    DetailSeasonsView(viewModel: viewModel, movie: movie)
                }.navigationTitle(movie.name)
            }
        }
    }
}

struct DetailHeaderView: View {
    fileprivate enum Layout { }
    let movie: TVShow
    
    struct Constants {
        static let imageSize: CGFloat = 300
        static let lineLimit: Int = 3
        static let padding: CGFloat = 16
    }
    
    var body: some View {
        VStack(alignment: .center) {
            ImageLoader(movie.image?.mediumURL)
                .frame(width: Layout.imageSize, height: Layout.imageSize)
            VStack(alignment: .leading) {
                ExpandableText(
                    movie.summary?.htmlToString ?? "--", lineLimit: Layout.lineLimit)
                .font(.body)
                .padding([.leading, .trailing], Layout.padding)
            }
        }.padding(.bottom, Constants.padding)
    }
}

private extension DetailHeaderView.Layout {
    static let imageSize: CGFloat = 300
    static let lineLimit: Int = 3
    static let padding: CGFloat = 16
}

struct DetailInfoListView: View {
    let text: LocalizedStringKey
    let data: [String]
    
    var body: some View {
        HStack {
            Text(text).fontWeight(.bold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(data, id: \.self) { day in
                        Text(day)
                    }
                }
            }
        }
    }
}

struct DetailInfoView: View {
    fileprivate enum Layout { }
    let movie: TVShow
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.spacing) {
            DetailInfoListView(text: "genre", data: movie.genres)
            HStack {
                Text("starts").fontWeight(.bold)
                Text(movie.schedule.time)
            }
            DetailInfoListView(text: "every", data: movie.schedule.days)
        }.padding([.leading, .trailing, .bottom], Layout.padding)
    }
}

private extension DetailInfoView.Layout {
    static let spacing: CGFloat = 2
    static let padding: CGFloat = 16
}

struct DetailSeasonsView: View {
    @StateObject var viewModel: TVShowDetailViewModel
    fileprivate enum Layout { }
    let movie: TVShow

    var body: some View {
        VStack(alignment: .leading) {
            Text("seasons")
                .fontWeight(.bold)
                .font(.title)
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach(viewModel.items, id: \.self) { item in
                        NavigationLink(
                            destination: EpisodeListView(
                                viewModel: EpisodeListViewModel(season: item)))
                        {
                            ImageLoader(item.image?.mediumURL)
                                .frame(height: Layout.imageSize)
                        }
                        
                    }
                }.onAppear {
                    viewModel.fetchSeasons(id: movie.id)
                }
            }
        }.padding([.leading, .trailing], Layout.padding)
    }
}

private extension DetailSeasonsView.Layout {
    static let imageSize: CGFloat = 200
    static let padding: CGFloat = 16
}
