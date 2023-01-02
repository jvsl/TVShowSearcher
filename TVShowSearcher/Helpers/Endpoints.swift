import Foundation

enum Endpoints: String {
    case tvShowList = "https://api.tvmaze.com/shows?page=%@"
    case tvShowDetail = "https://api.tvmaze.com/shows/%@/seasons"
    case episodeList = "https://api.tvmaze.com/seasons/%@/episodes"
    case tvShowSearch = "https://api.tvmaze.com/search/shows?q=%@"
    
    func add(_ id: Int) -> String {
        String(format: self.rawValue, id.description)
    }
    
    func add(_ query: String) -> String {
        String(format: self.rawValue, query)
    }
}

enum LoadingState {
    case initialLoading
    case success
    case error
    case none
}
