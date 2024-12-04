//
//  SATResourceView.swift
//  CollegePathwaysAI
//
//  Created by sam Montalbano on 11/7/24.
//

import SwiftUI

struct SATResourcesView: View {
    @State private var resources = [SATResource]()
    
    var body: some View {
        List(resources) { resource in
            VStack(alignment: .leading) {
                Text(resource.title)
                    .font(.headline)
                Text(resource.description)
                    .font(.subheadline)
                Link("Learn More", destination: URL(string: resource.link)!)
                    .font(.subheadline)
            }
            .padding(.vertical, 5)
        }
        .navigationTitle("SAT Preparation")
        .onAppear {
            
        }
        
        
    }
}
