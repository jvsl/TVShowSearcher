import Foundation
import Kingfisher
import SwiftUI

struct ImageLoader: View {
    private let imageURL: URL?
    @State var downloadFailure = false
    
    init(_ imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    var body: some View {
        if !downloadFailure {
            KFImage.url(imageURL)
                .loadDiskFileSynchronously()
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .resizable()
                .onFailure {_ in
                    downloadFailure = true
                }
                .placeholder {
                    ProgressView()
                }
                .scaledToFit()
                .cornerRadius(8)
            
        } else {
            Image("placeholder")
                .resizable()
                .scaledToFit()
        }
    }
}
