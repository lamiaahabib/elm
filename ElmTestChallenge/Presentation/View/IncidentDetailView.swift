//
//  IncidentDetailView.swift
//  ElmTestChallenge
//
//  Created by lamiaa on 6/2/24.
//



import SwiftUI
import MapKit

struct IncidentDetailView: View {
    @ObservedObject var viewModel: IncidentDetailViewModel
    var token: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.incident.description)
                .font(.headline)
                .padding()

            ForEach(viewModel.incident.medias ?? []) { media in
                Text(media.url)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
            }

            HStack {
                Button(action: {
                    viewModel.changeIncidentStatus(token: token, newStatus: .inProgress)
                }) {
                    Text("Change Status to In Progress")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(8.0)
                }
                .padding(.trailing, 10)

                Button(action: {
                    viewModel.changeIncidentStatus(token: token, newStatus: .completed)
                }) {
                    Text("Change Status to Completed")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8.0)
                }
            }
            .padding()

            // Display worker location
            if viewModel.incident.latitude != 0, viewModel.incident.longitude != 0 {
                Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: viewModel.incident.latitude, longitude: viewModel.incident.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))), annotationItems: [viewModel.incident]) { _ in
                    MapPin(coordinate: CLLocationCoordinate2D(latitude: viewModel.incident.latitude, longitude: viewModel.incident.longitude))
                }
                .frame(height: 200)
                .cornerRadius(8.0)
                .padding(.top, 10)
            }

            Spacer()
        }
        .navigationBarTitle("Incident Details", displayMode: .inline)
        .padding()
        .alert(isPresented: .constant(viewModel.errorMessage != nil || viewModel.successMessage != nil)) {
            if let errorMessage = viewModel.errorMessage {
                return Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            } else if let successMessage = viewModel.successMessage {
                return Alert(title: Text("Success"), message: Text(successMessage), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("OK")))
            }
        }
    }
}
#Preview {
    IncidentDetailView(viewModel: IncidentDetailViewModel(incident: Incident(id: "1", description: "Test Incident", latitude: 37.7749, longitude: -122.4194, status: IncidentStatus.submitted.rawValue, priority: 1, typeId: 1, issuerId: "1", assigneeId: "2", createdAt: "2022-01-01T12:00:00Z", updatedAt: "2022-01-02T12:00:00Z", medias: [])), token: "")

}
