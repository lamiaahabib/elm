//
//  DashboardView.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    var token: String
    @Binding var authState: AuthenticationState // Add a binding to manage the auth state

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                    Button(action: {
                        viewModel.fetchDashboardData(token: token)
                    }) {
                        Text("Retry")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 40)
                            .background(Color.blue)
                            .cornerRadius(10.0)
                    }
                }
            } else {
                ScrollView {
                    VStack {
                        Text("Incident Statistics")
                            .font(.largeTitle)
                            .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Incidents by Status")
                                .font(.title2)
                                .padding(.horizontal)
                            
                            Chart(viewModel.incidentStats) { stat in
                                BarMark(
                                    x: .value("Status", stat.status.description),
                                    y: .value("Count", stat.count)
                                )
                            }
                            .padding()
                        }
                        
                        // Add more charts as needed
                    }
                }
            }
            NavigationLink(destination: NewIncidentView(viewModel: NewIncidentViewModel(), token: token)) {
                           Text("Post a New Incident")
                               .font(.headline)
                               .foregroundColor(.white)
                               .padding()
                               .frame(width: 220, height: 40)
                               .background(Color.green)
                               .cornerRadius(10.0)
                       }
                       .padding(.top, 20)
                   }
                   .onAppear {
                       viewModel.fetchDashboardData(token: token)
                   }
    }
}

#Preview {
    DashboardView(viewModel: DashboardViewModel(), token: "", authState: .constant(.dashboard))
}
