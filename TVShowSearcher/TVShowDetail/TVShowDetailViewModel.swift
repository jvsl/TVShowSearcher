import Foundation
import Combine

class TVShowDetailViewModel: ObservableObject {
    @Published var items = [Season]()
    private var subscription: Set<AnyCancellable> = []
    private let service: TVShowDetailServicing
    
    init(service: TVShowDetailServicing = TVShowDetailService()) {
        self.service = service
    }
    
    func fetchSeasons(id: Int) {
        guard let url = URL(string: Endpoints.tvShowDetail.add(id)) else { return }
        
        service.fetchSeaons(url: url)
            .sink { (_) in
            } receiveValue: { [weak self] items in
                    self?.items = items
            }.store(in: &subscription)
    }
}
