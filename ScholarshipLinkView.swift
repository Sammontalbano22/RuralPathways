import SwiftUI

struct ScholarshipLinkView: View {
    var body: some View {
        VStack {
            Text("Paying for school just got easier!")
                .font(.title2)
                .padding()
            
            // Link with an AsyncImage for loading the Fastweb logo
            Link(destination: URL(string: "https://www.fastweb.com/?utm_source=fw_schools")!) {
                AsyncImage(url: URL(string: "https://www.fastweb.com/assets/widgets/generic_scholarship_search/fastweb-logo.png")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 50)
                } placeholder: {
                    ProgressView() // Show a loading indicator while the image loads
                }
            }
            
            Spacer()
        }
        .navigationTitle("Scholarship Search")
        .padding()
    }
}

struct ScholarshipLinkView_Previews: PreviewProvider {
    static var previews: some View {
        ScholarshipLinkView()
    }
}

