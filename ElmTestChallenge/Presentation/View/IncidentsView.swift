//
//  IncidentsView.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//

import SwiftUI
import MapKit


struct IncidentsView: View {
    @ObservedObject var viewModel: IncidentsViewModel
    var token: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) { // Decreased the spacing between filter items
                // Filter Controls
                VStack(spacing: 8) { // Decreased the spacing within the filter section
                    HStack {
                        Text("Status:")
                        Picker("Status", selection: $viewModel.selectedStatus) {
                            Text("All").tag(IncidentStatus?.none)
                            ForEach(IncidentStatus.allCases) { status in
                                Text(status.description).tag(status as IncidentStatus?)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: viewModel.selectedStatus) {
                            viewModel.applyFilters()
                        }
                    }
                    
                    HStack {
                        Text("Start Date:")
                        DatePicker("", selection: Binding(
                            get: { viewModel.startDate ?? Date() },
                            set: { newDate in viewModel.setFilter(startDate: newDate, endDate: viewModel.endDate) }
                        ), displayedComponents: .date)
                        .onChange(of: viewModel.startDate) {
                            viewModel.applyFilters()
                        }
                        .labelsHidden()
                    }
                    
                    HStack {
                        Text("End Date:")
                        DatePicker("", selection: Binding(
                            get: { viewModel.endDate ?? Date() },
                            set: { newDate in viewModel.setFilter(startDate: viewModel.startDate, endDate: newDate) }
                        ), displayedComponents: .date)
                        .onChange(of: viewModel.endDate) {
                            viewModel.applyFilters()
                        }
                        .labelsHidden()
                    }
                    
                    Button(action: {
                        viewModel.resetFilters()
                    }) {
                        Text("Reset Filters")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 40) // Decreased height
                            .background(Color.red)
                            .cornerRadius(10.0) // Adjusted corner radius
                    }
                }
                .padding([.leading, .trailing, .top], 10) // Adjusted padding
                
                // Incidents List
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                        Button(action: {
                            viewModel.fetchIncidents(token: token)
                        }) {
                            Text("Retry")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 220, height: 40) // Decreased height
                                .background(Color.blue)
                                .cornerRadius(10.0) // Adjusted corner radius
                        }
                    }
                } else {
                    List(viewModel.filteredIncidents) { incident in
                        NavigationLink(destination: IncidentDetailView(viewModel: IncidentDetailViewModel(incident: incident), token: token)) {
                            VStack(alignment: .leading) {
                                Text(incident.description)
                                    .font(.headline)
                                ForEach(incident.medias ?? []) { media in
                                    Text(media.url)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 5) // Reduced vertical padding
                        }
                    }
                }
                
                NavigationLink(destination: DashboardView(viewModel: DashboardViewModel(), token: token, authState: .constant(.dashboard))) {
                    Text("Open Dashboard")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 40) // Decreased height
                        .background(Color.green)
                        .cornerRadius(10.0) // Adjusted corner radius
                }
                .padding(.top, 8)
            }
            .onAppear {
                viewModel.fetchIncidents(token: token)
            }
            .navigationBarTitle("Incidents")
        }
    }
}


#Preview {
    IncidentsView(viewModel: IncidentsViewModel(), token: "")
}
