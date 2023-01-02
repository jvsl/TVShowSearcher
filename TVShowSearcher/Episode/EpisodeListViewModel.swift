import Combine
import Foundation

class EpisodeListViewModel: ObservableObject {
    @Published var items = [Episode]()
    @Published var state: LoadingState = .none
    private var subscription: Set<AnyCancellable> = []
    private let service: EpisodeListServicing = EpisodeListService()
    let season: Season
    
    init(season: Season) {
        self.season = season
        fetchEpisodes()
    }
    
    func fetchEpisodes() {
        guard let url = URL(string:  Endpoints.episodeList.add(season.id)) else { return }
        
        state = .initialLoading
        
        service.fechEpisodes(url: url)
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .failure:
                        self?.state = .error
                    case .finished:
                        debugPrint("finished")
                    }
                } ,
                receiveValue: { [weak self] items in
                    self?.state = .success
                    self?.items = items
                }
            ).store(in: &subscription)
    }
}
