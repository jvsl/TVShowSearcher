import SwiftUI

struct ExpandableText: View {
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    private var text: String
    
    let lineLimit: Int
    
    init(_ text: String, lineLimit: Int) {
        self.text = text
        self.lineLimit = lineLimit
    }
    
    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? "read less" : " read more"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .lineLimit(expanded ? nil : lineLimit)
                .background(
                    Text(text).lineLimit(lineLimit)
                        .background(GeometryReader { visibleTextGeometry in
                            ZStack {
                                Text(self.text)
                                    .background(GeometryReader { fullTextGeometry in
                                        Color.clear.onAppear {
                                            self.truncated = fullTextGeometry.size.height > visibleTextGeometry.size.height
                                        }
                                    })
                            }
                            .frame(height: .greatestFiniteMagnitude)
                        })
                        .hidden()
                )
            if truncated {
                Button(action: {
                    withAnimation {
                        expanded.toggle()
                    }
                }, label: {
                    Text(moreLessText)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                })
            }
        }
    }
}

extension View {
    func sync(_ published: Binding<String>, with binding: Binding<String>) -> some View {
        self.onChange(of: published.wrappedValue) { published in
            binding.wrappedValue = published
        }
        .onChange(of: binding.wrappedValue) { binding in
            published.wrappedValue = binding
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView {
            Text("Loading")
                .font(.title2)
        }
        .progressViewStyle(CircularProgressViewStyle(tint: .black))
    }
}


struct ErrorView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer()
            Text("unavailable")
                .font(.title)
                .fontWeight(.bold)
            Text("error")
                .font(.body)
                .padding(8)
            Spacer()
        }
        
    }
}
