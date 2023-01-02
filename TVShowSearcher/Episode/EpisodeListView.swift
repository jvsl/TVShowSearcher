import Foundation
import SwiftUI
import Combine

struct EpisodeListView: View {
    @StateObject var viewModel: EpisodeListViewModel
    
    var body: some View {
        switch viewModel.state {
        case .success:
            List(viewModel.items) { item in
                EpisodeCell(item: item)
            }
            .navigationTitle("Season \(viewModel.season.number ?? 0)")
        case .error:
            ErrorView()
        case .initialLoading:
            LoadingView()
        default:
            EmptyView()
        }
    }
}

struct EpisodeCell: View {
    fileprivate enum Layout { }
    let item: Episode

    var body: some View {
        VStack {
            VStack {
                ImageLoader(item.image?.mediumURL)
                Text(item.name).font(.title)
            }.padding(.bottom, Layout.imagePadding)
            
            VStack(alignment: .leading, spacing: Layout.expandableSpacing) {
                HStack {
                    Text("episode").fontWeight(.bold)
                    Text(item.number?.description ?? "-")
                }
                ExpandableText(item.rawSummary ?? "--", lineLimit: Layout.lineLimit)
                    .font(.body)
                    .padding(.bottom, Layout.expandableBottomPadding)
            }
        }
    }
}

private extension EpisodeCell.Layout {
    static let lineLimit: Int = 3
    static let expandableBottomPadding: CGFloat = 16
    static let imagePadding: CGFloat = 8
    static let expandableSpacing: CGFloat = 8
}
