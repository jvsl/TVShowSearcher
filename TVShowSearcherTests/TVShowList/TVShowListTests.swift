import Combine
import XCTest
@testable import TVShowSearcher

final class TVShowListTests: XCTestCase {

    private let items: [TVShow] = [.fixture()]
    private lazy var service: TVShowListServicing = TVShowListServiceMock(
        scenario: .success(model: items))
    private lazy var sut: TVShowListViewModel = TVShowListViewModel(service: service)
    
    func testSuccess_tvShowArray_shouldReturnStateSuccess() throws {
        XCTAssertEqual(sut.state, .success)
    }
    
    func testFailure_tvShowArray_shouldReturnStateError() throws {
        let service = TVShowListServiceMock(scenario: .failure(error: NSError()))
        let viewModel = TVShowListViewModel(service: service)
       
        XCTAssertEqual(viewModel.state, .error)
    }
    
    func testLoadNexPage_nilItem_shouldReturnCurrentPageAs3() throws {
        XCTAssertEqual(sut.currentPage, 1)
        self.sut.callNextPageIfNeeded(currentItem: nil)
          
        XCTAssertEqual(self.sut.currentPage, 2)
        XCTAssertEqual(self.sut.state, .success)
    }
}

struct TVShowListServiceMock: TVShowListServicing {
    enum Scenario {
         case success(model: [TVShow])
         case failure(error: Error)
     }
    
    var scenario: Scenario
        
        init(scenario: Scenario) {
            self.scenario = scenario
        }
    
    let deviceStateSub = PassthroughSubject<[TVShowSearcher.TVShow], Error>()
    
    func fetchTVShow(_ url: URL) -> AnyPublisher<[TVShowSearcher.TVShow], Error> {
        switch scenario {
            case .success(let model):
                return Just(model)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
    }
}

private extension TVShow {
    static func fixture() -> TVShow{
        TVShow(id: 1,
               url: "google.com",
               name: "game of thrones",
               genres: ["fiction"],
               schedule: Schedule(time: "10h30pm",
                                  days: ["Sunday"]),
               image: TVShowImage(
                medium: "https://static.tvmaze.com/uploads/images/medium_portrait/305/764844.jpg",
                original: "https://static.tvmaze.com/uploads/images/medium_portrait/305/764844.jpg"),
               summary: "A tv show about dragons"
               )
    }
}
